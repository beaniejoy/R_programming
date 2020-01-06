# chap12_2_LogisticRegression

# 오즈비 vs 로짓변환
# P(Y/N)에서 -inf ~ inf --> 0 ~ 1로 변환하기 위해 로짓변환



###############################################
# 15_2. 로지스틱 회귀분석(Logistic Regression) 
###############################################

# 목적 : 일반 회귀분석과 동일하게 종속변수와 독립변수 간의 관계를 나타내어 
# 향후 예측 모델을 생성하는데 있다.

# 차이점 : 종속변수가 범주형 데이터를 대상으로 하며 입력 데이터가 주어졌을 때
# 해당 데이터의결과가 특정 분류로 나눠지기 때문에 분류분석 방법으로 분류된다.
# 유형 : 이항형(종속변수가 2개 범주-Yes/No), 다항형(종속변수가 3개 이상 범주-iris 꽃 종류)
# 다항형 로지스틱 회귀분석 : nnet, rpart 패키지 이용 
# a : 0.6,  b:0.3,  c:0.1 -> a 분류 

# 분야 : 의료, 통신, 기타 데이터마이닝

# 선형회귀분석 vs 로지스틱 회귀분석 
# 1. 로지스틱 회귀분석 결과는 0과 1로 나타난다.(이항형)
# 2. 정규분포 대신에 이항분포를 따른다.
# 3. 로직스틱 모형 적용 : 변수[-무한대, +무한대] -> 변수[0,1]사이에 있도록 하는 모형 
#    -> 로짓변환 : 출력범위를 [0,1]로 조정
# 4. 종속변수가 2개 이상인 경우 더미변수(dummy variable)로 변환하여 0과 1를 갖도록한다.
#    예) 혈액형 AB인 경우 -> [1,0,0,0] AB(1) -> A,B,O(0)


# 로짓변환 vs sigmoid function

# 1) 로짓변환 : 오즈비에 log(자연로그)함수 적용
p = 0.5 # 성공확률
odds_ratio <- p / (1-p)
logit1 <- log(odds_ratio) # 0

p = 1 # 성공확률
odds_ratio <- p / (1-p)
logit2 <- log(odds_ratio) # Inf(양의무한대)

p = 0 # 성공확률
odds_ratio <- p / (1-p)
logit3 <- log(odds_ratio) # -Inf(음의 무한대)

# [정리] p=0.5 : 0 / p >0.5 : Inf / p < 0.5 : -Inf

# 2) sigmoid function
sig1 <- 1 / (1 + exp(-logit1)) # logit1: 0
sig1 # 0.5

sig2 <- 1 / (1 + exp(-logit2)) # logit2: Inf
sig2 # 1

sig3 <- 1 / (1 + exp(-logit3)) # logit3: -Inf
sig3 # 0

# [정리] logit = 0 : 0.5 / logit = Inf : 1 / logit = -Inf : 0
# 값의 범위 : 0 ~ 1 확률값(cut off)



# 단계1. 데이터 가져오기
weather = read.csv("C:/dev/Rwork/data/weather.csv", stringsAsFactors = F) 
dim(weather)  # 366  15
head(weather)
str(weather)

# chr 칼럼, Date, RainToday 칼럼 제거 
weather_df <- weather[, c(-1, -6, -8, -14)]
str(weather_df)

# RainTomorrow 칼럼 -> 로지스틱 회귀분석 결과(0,1)에 맞게 더미변수 생성      
weather_df$RainTomorrow[weather_df$RainTomorrow=='Yes'] <- 1
weather_df$RainTomorrow[weather_df$RainTomorrow=='No'] <- 0
weather_df$RainTomorrow <- as.numeric(weather_df$RainTomorrow)
head(weather_df)

#  단계2.  데이터 셈플링
idx <- sample(1:nrow(weather_df), nrow(weather_df)*0.7)
train <- weather_df[idx, ]
test <- weather_df[-idx, ]


#  단계3.  로지스틱  회귀모델 생성 : 학습데이터 
weater_model <- glm(RainTomorrow ~ ., data = train, family = 'binomial')
weater_model 
summary(weater_model) 
# Coefficients:
#                Estimate Std. Error z value Pr(>|z|)    
# (Intercept)   148.75461   50.21263   2.962 0.003052 ** 
# MinTemp        -0.14758    0.08103  -1.821 0.068551 .  
# MaxTemp         0.13939    0.23882   0.584 0.559464    
# Rainfall       -0.20324    0.09388  -2.165 0.030393 *  
# Sunshine       -0.34459    0.12030  -2.864 0.004178 ** 
# WindGustSpeed   0.09918    0.02888   3.434 0.000594 *** (설명력 크다.)
# WindSpeed      -0.07315    0.03936  -1.858 0.063122 .  
# Humidity        0.05966    0.03086   1.933 0.053187 .  
# Pressure       -0.15471    0.04850  -3.190 0.001423 ** 
# Cloud           0.08120    0.12405   0.655 0.512710    
# Temp            0.08724    0.26196   0.333 0.739122    



# 단계4. 로지스틱  회귀모델 예측치 생성 : 검정데이터 
# newdata=test : 새로운 데이터 셋, type="response" : 0~1 확률값으로 예측 
pred <- predict(weater_model, newdata=test, type="response")  
pred 
range(pred, na.rm=T) # 8.900507e-05 ~ 9.560825e-01 / 0 ~ 1과 거의 밀접함
summary(pred)
str(pred) # Named num [1:110]

# cut off = 0.5 적용
cpred <- ifelse(pred >= 0.5, 1, 0) # 예측치(0, 1)
y_true <- test$RainTomorrow # 정답(실측치 0, 1)

# 교차분할표(confusion matrix)
t <- table(y_true, cpred)
#       cpred
# y_true  0  1
#      0 87  7 = 94
#      1  9  7 = 16

acc <- (83 + 13) / sum(t) # 정확히 예측한 경우
cat('accuracy =',acc) # 0.8727273 (예측정확도)

(7 + 9) / sum(t) # 0.1454545

# 특이도 : No(실제) -> No(예측도 no일 확률)
acc_no <- 87 / 94 # 비가 안올경우 0.9255319
# 재현율(=민감도) : YES(실제) -> YES(예측도 yes일 확률)
recall <- 7 / 16 # 비가 올 경우 0.4375
# 정확률 : model(yes) -> yes
precision <- 7 / 14

# F1 Score : no != yes(불균형)
f1_score = 2 * ((precision * recall) / (precision +recall))
f1_score # 0.4666667



### ROC Curve를 이용한 모형평가(분류정확도)  ####
# Receiver Operating Characteristic

install.packages("ROCR")
library(ROCR)

# ROCR 패키지 제공 함수 : prediction() -> performance
pr <- prediction(pred, test$RainTomorrow)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)




###############################################
# 다향형 로지스틱 회귀분석 
###############################################


install.packages("nnet")
library(nnet)


# 이항분류 vs 다항분류
# sigmoid : 이항분류(0 ~ 1 확률, cutoff=0.5)
# softmax : 다항분류(0 ~ 1 확률, 확률합 = 1)
# ex) class1=0.9, class2=0.1, class3=0.1 , 전체확률을 1로 만들어주게끔 한다.

names(iris)
idx <- sample(nrow(iris), nrow(iris)*0.7)
train_iris <- iris[idx, ]
test_iris <- iris[-idx, ]

# 다항분류 model
model <- multinom(Species ~., data=train_iris)
# weights:  18 (10 variable)
# initial  value 115.354290 
# iter  10 value 6.126347
# iter  20 value 4.943154
# iter  30 value 4.831278
# iter  40 value 4.786005
# iter  50 value 4.774299
# iter  60 value 4.774231
# iter  70 value 4.774168
# iter  80 value 4.774152
# iter  90 value 4.774149
# iter 100 value 4.774135
# final  value 4.774135  -> 점차 오차가 줄어듬


# model 평가 : test
y_pred <- predict(model, newdata=test_iris, type="probs") 
# 확률값으로 결과를 반환하겠다.
# type="probs" : y의 예측치를 0 ~ 1확률 (합=1) -> softmax
y_pred <- predict(model, newdata=test_iris, type="class") 
# type="class" : 꽃 종류로 반환, 도메인 이름으로 예측할 때

range(y_pred)
# 1.036303e-34(0) ~ 1.000000e+00(1)
y_pred
str(y_pred)

y_true <- test_iris$Species

t <- table(y_true, y_pred)
#            y_pred     1개 빼고 정확하게 예측
# y_true     setosa versicolor virginica
# setosa         20          0         0
# versicolor      0          8         1 
# virginica       0          0        16

acc <- (t[1,1] + t[2,2] + t[3,3]) / sum(t)
acc # 0.9777778 아주 높은 정확도


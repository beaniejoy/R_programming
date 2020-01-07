# chap12_1_LinearRegression


##############################
# 1. 단순선형회귀분석
##############################
# - 독립변수(1) -> 종속변수(1) 미치는 영향

setwd("c:/dev/Rwork/data")
product <- read.csv("product.csv")
str(product)
# 'data.frame':	264 obs. of  3 variables:

x <- product$제품_적절성# 독립변수
y <- product$"제품_만족도" # 종속변수

df <- data.frame(x, y)
df

# 2) 회귀모델 생성
model <- lm(y ~ x, data = df)
model
# Coefficients: 회귀계수(기울기, 절편)
# (Intercept)       x  
# 0.7789(절편) 0.7393(기울기)

# 회귀방정식(y) = 0.7393 * x + 0.7789
head(df)
# x = 4, y = 3
x = 4; 
Y = 3 # 관측치
y = 0.7393 * x + 0.7789 # 예측치
y # 3.7361

seq(10, 5, -2)
# 오차 = 관측치(정답) - 예측치
err <- Y - y
err # -0.7361

abs(err) # 절대값
mse = mean(err^2)
# mean squared error(평균제곱오차)
mse # 0.5418432 - 제곱 (부호+, 패널티)
# 모델이 얼마나 잘 설명하고 있는지 mse를 통해 알 수 있다.
# mse가 0에 수렵할수록 그만큼 모델의 예측력이 뛰어나다는 의미

names(model) # 회귀모델에서 반환한 12개의 컬럼이름을 볼 수 있다.
# 그중 자주 쓰이는 것은
# coefficients : 계수
# residuals : 오차(잔차)
# fitted.values: 적합치(예측치)

model$coefficients
model$residuals # 각 관측치에 대한 각 예측치와의 차이(오차)
model$fitted.values # 각 x값에 대한 예측치(?)


# 3) 회귀모델 분석
summary(model)

# <회귀모델 분석 순서>
# 1. F검정 통계량: 모델의 유의성 검정(p-value: < 2.2e-16 < 0.05)
# 2. 모델의 설명력: Adjusted R-squared(0.5865) <- 1에 가까울수록 예측력(설명력)이 좋다.
# 3. x변수 유의성 검정: 영향력 판단(p < 0.05 ***강도 판단)
# ***, **, *: x -> y 설명력의 강도


# R-squared = R^2 (상관계수 제곱)
R <- sqrt(0.5865)
R # 0.7658329 : 비교적 높은 상관성을 보인다.


# 4) 회귀선 : 회귀방정식에 의해서 구해진 직선식(예측치)

# x, y 산점도
plot(df$x, df$y)
# 회귀선(직선)
abline(model, col="red") # 직전에 그린 그래프에 직선을 그리는 함수



##############################
# 2. 다중선형회귀분석
##############################
# - 독립변수(n) -> 종속변수(1) 미치는 영향

install.packages("car")
library(car)

str(Prestige)
# 'data.frame':	102 obs. of  6 variables:
# 102 직업군 대상: 교육수준, 수입, 여성비율, 평판, 직, 유형
row.names(Prestige) # 102직업군 이름

# subset
newdata <- Prestige[c(1:4)]
str(newdata)

# 상관분석
cor(newdata)
# prestige - education 간에 상관성이 가장 높다.
#            education(x1) income   women(x2)  prestige(x3)
# education 1.00000000  0.5775802  0.06185286  0.8501769
# income    0.57758023  1.0000000 -0.44105927  0.7149057

# 다중 선형회귀 모델
model <- lm(income ~ education + women + prestige, data=newdata)
model
# Coefficients:
#   (Intercept)    education        women     prestige  
#        -253.8        177.2        -50.9        141.4

# gov.administrators 데이터의 실제 데이터값 대입
income <- 12351 # Y(정답) -> 관측치
education <- 13.11 # x1
women <- 11.16 # x2
prestige <- 68.8 # x3

y_pred <- 177.2*education + -50.9*women + 141.4*prestige + (-253.8)
y_pred # 11229.57 -> 예측치

err <- income - y_pred
err # 1121.432 설명력을 의미한다.


# 4) 회귀모델 분석
summary(model)
# 모델 유의성 : p-value=< 2.2e-16 < 0.05
# 설명력: Adjusted R-squared:  0.6323
# 유의성 검정
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept) -253.850   1086.157  -0.234    0.816  
# education    177.199    187.632   0.944    0.347 (영향없음, education은 income에 대한 설명력 부족)
# women        -50.896      8.556  -5.948 4.19e-08 ***
# prestige     141.435     29.910   4.729 7.58e-06 ***



##############################
# 3. 변수 선택법
##############################
# - 최적 모델을 위한 x변수 선택

newdata2 <- Prestige[c(1:5)]
str(newdata2)

library(MASS)
model2 <- lm(income ~ ., data=newdata2)
model2

# 후진제거법
step <- stepAIC(model2, direction = "both")
step

# 최적의 회귀모형(by 후진제거법)
model3 <- lm(formula = income ~ women + prestige, data = newdata2)
summary(model3)
# F-statistic: p-value=< 2.2e-16
# Adjusted R-squared:  0.6327 > 0.6323(전에 education까지 x에 포함할때 / 설명력 증가)
# women        -48.385      8.128  -5.953 4.02e-08 ***
# prestige     165.875     14.988  11.067  < 2e-16 ***



##############################
# 4. 기계 학습
##############################

iris_data <- iris[-5]
str(iris_data)
# 'data.frame':	150 obs. of  4 variables:


# 1) train/test set(70 vs 30)
idx <- sample(x=nrow(iris_data), size=nrow(iris_data)*0.7, replace=FALSE) # F : 비복원추출
idx
train <- iris_data[idx, ]
test <- iris_data[-idx, ]

dim(train) # 105  4(y+x)
dim(test) # 45  4(y+x)

# 2) model(train)
model <- lm(Sepal.Length ~ ., data=train)
summary(model)

# 3) model 평가(test)
y_pred <- predict(model, test) # y의 예측치(model에 대입해서 나온 결과값)
y_pred
y_true <- test$Sepal.Length # y의 정답(실측치)
y_true
# 평가: mean square error 평균제곱오차)
mse <- mean((y_true - y_pred)^2)
mse # 0.083205 비복원 랜덤샘플 추출해서 겨롸값이 다르게 나온다.

cor(y_true, y_pred)
# 0.945081 상당히 높은 상관계수를 보이고 있다.
# 실측치와 예측치의 평균과 표준편차를 비교해 상관계수를 도출한 것

# y real value vs y prediction
plot(y_true, col="blue", type="o", pch=18)
points(y_pred, col="red", type="o", pch=19)
title("real value vs prediction")
#범례)
legend("topleft", legend=c("read","pred"),
       col=c("blue","red"), pch=c(18,19))




##########################################
##  5. 선형회귀분석 잔차검정과 모형진단
##########################################

# 1. 변수 모델링  
# 2. 회귀모델 생성 
# 3. 모형의 잔차검정 
#   1) 잔차의 등분산성 검정
#   2) 잔차의 정규성 검정 
#   3) 잔차의 독립성(자기상관) 검정 
# 4. 다중공선성 검사 
# 5. 회귀모델 생성/ 평가 


names(iris)

# 1. 변수 모델링 : y:Sepal.Length <- x:Sepal.Width,Petal.Length,Petal.Width
formula = Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width


# 2. 회귀모델 생성 
model <- lm(formula = formula,  data=iris)
model
names(model)


# 3. 모형의 잔차검정
plot(model)
#Hit <Return> to see next plot: 잔차 vs 적합값 -> 패턴없이 무작위 분포(포물선 분포 좋지않은 적합) 
#Hit <Return> to see next plot: Normal Q-Q -> 정규분포 : 대각선이면 잔차의 정규성 
#Hit <Return> to see next plot: 척도 vs 위치 -> 중심을 기준으로 고루 분포 
#Hit <Return> to see next plot: 잔차 vs 지렛대값 -> 중심을 기준으로 고루 분포 

# (1) 등분산성 검정 
plot(model, which =  1) # 위에 HIT 4개 중에 선택
methods('plot') # plot()에서 제공되는 객체 보기 

# (2) 잔차 정규성 검정
attributes(model) # coefficients(계수), residuals(잔차), fitted.values(적합값)
res <- residuals(model) # 잔차 추출 
res <- model$residuals # 잔차 추출

shapiro.test(res) # 정규성 검정 - p-value = 0.9349 >= 0.05
# 귀무가설 : 정규성과 차이가 없다.

# 정규성 시각화  
hist(res, freq = F) 
qqnorm(res) # 선명한 대각선 형태를 가짐

# (4) 잔차의 독립성(자기상관 검정 : Durbin-Watson) 
install.packages('lmtest')
library(lmtest) # 자기상관 진단 패키지 설치 
dwtest(model) # 더빈 왓슨 값(0 ~ 4 / 2에 가까울수록 독립적)
# DW = 2.0604, p-value = 0.6013 > 0.05 (차이가 없다.)

# 4. 다중공선성 검사
# - 독립변수가 2개이상이고 독립변수 간의 강한 상관관계로 인해서 발생하는 문제
# - ex) 생년월일, 생일

library(car)

sqrt(vif(model)) > 2 # TRUE 
# Sepal.Width Petal.Length  Petal.Width
#   FALSE         TRUE         TRUE

# 5. 모델 생성/평가 
formula = Sepal.Length ~ Sepal.Width + Petal.Length 
cor(iris[-5])
model <- lm(formula = formula,  data=iris)
summary(model) # 모델 평가

# p-value: < 2.2e-16
# Adjusted R-squared:  0.838 
#             Estimate Std. Error t value Pr(>|t|)    
# (Intercept)   2.24914    0.24797    9.07 7.04e-16 ***
# Sepal.Width   0.59552    0.06933    8.59 1.16e-14 ***
# Petal.Length  0.47192    0.01712   27.57  < 2e-16 ***






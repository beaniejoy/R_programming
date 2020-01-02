# chap08_Hypothesis_basic


# 가설(Hypothesis) : 어떤 사건을 설명하기 위한 가정
# 검정(Test) : 검정통계량(표본)으로 가설 채택 or 기각 과정
# 추정 : 표본을 통해서 모집단을 확률적으로 추측
# 신뢰구간 : 모수를 포함하는 구간(채택역), 벗어나면(기각역)
# 유의수준 : 알파 표시, 오차 범위의 기준
# 구간추정 : 신뢰구간과 검정통계량을 비교해서 가설 기각 유무 결정


##################
# 1. 가설과 검정
##################


# 귀무가설(H0) : 중2학년 남학생 평균키는 165.2cm와 차이가 없다.
# 대립가설(H1) : 중2학년 남학생 평균키는 165.2cm와 차이가 있다.

# 1. 모집단에서 표본 추출(1,000 학생)
x <- rnorm(1000, mean = 165.2, sd = 1) # 정규분포

hist(x)

# 정규성 검정
# 귀무가설 : 정규분포와 차이가 없다.(0)
shapiro.test(x)
# W = 0.99884, p-value = 0.7811
# w: 검정통계량, p-value: 유의확률
# p-value = 0.7811 >= 알파(0.05) -> H0 채택


# 2. 평균차이 검정 : 평균 = 165.2cm
t.test(x, mu=165.2)
# t = -1.074, df = 999, p-value = 0.2831
# t, df : 검정통계량
# p-value : 유의확률
# p-value = 0.2831 > 0.05 : 귀무가설 채택

# 95 percent confidence interval: 95% 신뢰수준
#   165.1064 165.2274 : 신뢰구간(하한값~상한값), 채택역
# 165.1064 < mu = 165.2 < 165.2274 : 신뢰구간 안에 평균값이 들어옴: 채택역(H0채택)
mean(x) # 실제 평균 -> 165.1669, 실제평균이 신뢰구간 안에 들어가있음(통계량 : 표본의 통계)

# [x해설] 검정통계량이 신뢰구간에 포함되므로 
# 모수의 평균키는 165.2cm와 차이가 없다고 볼 수 있다.


# 3. 기각역의 평균검정
t.test(x, mu=165.09, conf.level = 0.95) # 95신뢰수준을 기본으로 한다.
# 귀무가설 : 평균키 165.09cm 차이가 없다.(X)
# 대립가설 : 평균키 165.09cm 차이가 있다.(O)
# t = 2.4928, df = 999, p-value = 0.01283
# p-value = 0.01283 < 알파(0.05) -> H0 기각
# 95 percent confidence interval:
#   165.1064 165.2274
# 165.1064 ~ 165.2274 : 기각역에 평균치가 속한다.


# 4. 신뢰수준 변경(95% -> 99%)
t.test(x, mu=165.2, conf.level = 0.99)
# t = -1.074, df = 999, p-value = 0.2831 >= 0.05(H0 채택)
# 99 percent confidence interval:
#   165.0873 165.2465
# 신뢰수준 향상 -> 신뢰구간 넓어짐(가설 기각이 어려워짐)


#######################
# 2. 표준화 vs 정규화
#######################

# 1. 표준화 : 정규분포 -> 표준정규분포(0, 1)

# 정규분포
n <- 2000
x <- rnorm(n, mean = 100, sd = 10)

shapiro.test(x)
# W = 0.99885, p-value = 0.2154 > 유의수준(알파): H0채택(정규분포와 차이가 없다.)

# 표준화
# 표준화 공식(z) = (x - mu) / sd(x)
mu <- mean(x)
# [1] 100.2821
z = (x - mu) / sd(x)
z # 표준 정규분포
hist(z)
mean(z) # -5.994022e-16 -> 0에 수렴하는 값
sd(z) # 1


# scale() 함수 이용
z2 <- as.data.frame(scale(x)) # matrix -> data.frame
str(z2)
z2 <- z2$V1
hist(z2)
mean(z2) # -5.994022e-16
sd(z2) # 1


# 2. 정규화
# - 특정 변수값을 일정한 범위(0~1)로 일치시키는 과정
str(iris)
head(iris)
summary(iris[-5])

# 1) scale() 함수
# 정규화 -> data.frame으로 형변환
iris_norm <- as.data.frame(scale(iris[-5]))
summary(iris_norm)

# 2) 정규화 함수 정의(0~1)
nor <- function(x){
  n <- (x - min(x)) / (max(x) - min(x))
  return(n)
}

iris_norm2 <- apply(iris[-5], 2, nor)
summary(iris_norm2)
head(iris_norm2)


##########################
# 3. 데이터셋에서 샘플링
##########################

# sample(x, size, replace = FALSE) # 비복원추출(기본값)

no <- 1:100 # 번호
score <- runif(100, min = 40, max = 100) # 성적

df <- data.frame(no, score)
df
nrow(df) # 100

# 15명 학생샘플링
idx <- sample(x = nrow(df), size = 15)
idx

sam <- df[idx, ]
sam

# train(70%)/test(30%) dataset
idx <- sample(x = nrow(df), size = nrow(df)*0.7)
idx

train <- df[idx, ] # model 학습용
test <- df[-idx, ] # model 평가용
dim(train)# 70  2
dim(test) # 30  2


##########################
# train/test model 적용
##########################

# 50/50으로
idx <- sample(nrow(iris), nrow(iris)*0.5)

train <- iris[idx, ]
test <- iris[-idx, ]
dim(train) # 75  5
dim(test) # 75  5

head(iris)
# Sepal.Length : y(종속변수) -> 정답
# Petal.Length : x(독립변수) -> 입력
# model : 꽃잎 길이 -> 꽃받침 길이 

# train dataset model
# lm() : linear model(선형회귀모델)
model <- lm(Sepal.Length ~ Petal.Length, data=train)
pred <- model$fitted.values # 에측치

# test dataset model
model2 <- lm(Sepal.Length ~ Petal.Length, data=test)
pred2 <- model2$fitted.values # 예측치


# train_x, test_x
train_x <- train$Sepal.Length # train의 
test_x <- test$Sepal.Length # test의 

# 정답 vs 예측치
plot(train_x, pred, col="blue",pch=18) # train
points(test_x, pred2, col="red",pch=19) # test

# 범례
legend("topleft", legend = c("train","test"),
       col = c("blue", "red"), pch = c(18,19))


#################################
## <제13장 연습문제>
################################# 

# 01. mpg 데이터 셋을 대상으로 7:3 비율로 학습데이터와 검정데이터로 각각 
# 샘플링한 후 각 단계별로 분류분석을 수행하시오.

# 조건) x,y 변수선택  
#       독립변수(설명변수) : displ + cyl + year 
#       종속변수(반응변수) : cty

library(rpart) # 분류모델 사용
library(ggplot2) # dataset 사용
data(mpg)
str(mpg) 

# 단계1 : 학습데이터와 검정데이터 샘플링
idx_m <- sample(nrow(mpg), nrow(mpg)*0.7)
train_mpg <- mpg[idx_m, ]
test_mpg <- mpg[-idx_m, ]

# 단계2 : 학습데이터 이용 분류모델 생성 
model_mpg <- rpart(cty ~ displ + cyl + year, data=train_mpg)
model_mpg

# 단계3 : 검정데이터 이용 예측치 생성 및 평가 
m_pred <- predict(model_mpg, test_mpg)
m_true <- test_mpg$cty
# y변수 : 연속형 평가
cor(m_true, m_pred) # 0.8449232

# 단계4 : 분류분석 결과 시각화
rpart.plot(model_mpg)
# 단계5 : 분류분석 결과 해설


# 02. weather 데이터를 이용하여 다음과 같은 단계별로 의사결정 트리 방식으로 분류분석을 수행하시오. 

# 조건1) rpart() 함수 이용 분류모델 생성 
# 조건2) y변수 : RainTomorrow, x변수 : Date와 RainToday 변수 제외한 나머지 변수로 분류모델 생성 
# 조건3) 모델의 시각화를 통해서 y에 가장 영향을 미치는 x변수 확인 
# 조건4) 비가 올 확률이 50% 이상이면 ‘Yes Rain’, 50% 미만이면 ‘No Rain’으로 범주화

# 단계1 : 데이터 가져오기
library(rpart) # model 생성 
library(rpart.plot) # 분류트리 시각화 

setwd("c:/Rwork/data")
weather = read.csv("weather.csv", header=TRUE) 

# 단계2 : 데이터 샘플링
weather.df <- weather[, c(-1,-14)]
summary(weather.df)
idx <- sample(1:nrow(weather.df), nrow(weather.df)*0.7)
weather_train <- weather.df[idx, ]
weather_test <- weather.df[-idx, ]

# 단계3 : 분류모델 생성
model_weather <- rpart(RainTomorrow ~ ., data=weather_train)
model_weather

# 단계4 : 분류모델 시각화 - 중요변수 확인 
rpart.plot(model_weather)


# 단계5 : 예측 확률 범주화('Yes Rain', 'No Rain') 
pred_w <- predict(model_weather, weather_test)
pred_w

str(pred_w)
# no >= 0.5 면 "No Rain"
weather_class <- ifelse(pred_w[ ,1] >= 0.5, "No Rain", "Yes Rain")

true_w <- weather_test$RainTomorrow
true_w

table(weather_class, weather_test$RainTomorrow)

# 단계6 : 혼돈 matrix 생성 및 분류 정확도 구하기
# weather_class No Yes
#      No Rain  84  17
#      Yes Rain  5   4
acc <- (84+4) / nrow(weather_test)
acc

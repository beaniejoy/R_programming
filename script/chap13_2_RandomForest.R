# chap13_2_RandomForest


# 패키지 설치
install.packages("randomForest")
library(randomForest)

names(iris)

##############################
## 분류트리(y변수 : 범주형)
##############################

# 1. model
model <- randomForest(Species ~ . , data=iris)
# 500개의 dataset을 생성 -> 500 tree(1대1로 대응, model) -> 예측치

model
# error rate: 6%
# 분류 정확도 94%
# Number of trees: 500 (기본값)
# No. of variables tried at each split: 2 -> 노드분류에 사용된 변수의 개수

# 혼동 매트릭스도 보여줌
# Confusion matrix:
#            setosa versicolor virginica class.error
# setosa         50          0         0        0.00
# versicolor      0         47         3        0.06
# virginica       0          4        46        0.08

?randomForest
model2 <- randomForest(Species ~ ., 
                       data = iris, 
                       ntree=400, # tree 개수
                       mtry = 2, # 자식노드로 나눌 때 고려할 변수의 개수
                       importance = TRUE, # 변수의 중요도를 알아볼 때
                       na.action = na.omit) # na가 있을 때 어떻게 하겠는지
model2
?importance
importance(model2)
# MeanDecreaseGini: 불확실성을 의미한다, 노드 불순도 개선에 영향을 주는 정도
# y에 중요한 영향을 끼치는 정도(?), 중요한변수
# Petal.Length와 Petal.Width가 중요한 요소역할을 한다.

varImpPlot(model2)


##############################
## 회귀트리(y변수 : 연속형)
##############################

library(MASS)
data("Boston")

str(Boston)
#crim : 도시 1인당 범죄율 
#zn : 25,000 평방피트를 초과하는 거주지역 비율
#indus : 비상업지역이 점유하고 있는 토지 비율  
#chas : 찰스강에 대한 더미변수(1:강의 경계 위치, 0:아닌 경우)
#nox : 10ppm 당 농축 일산화질소 
#rm : 주택 1가구당 평균 방의 개수 
#age : 1940년 이전에 건축된 소유주택 비율 
#dis : 5개 보스턴 직업센터까지의 접근성 지수  
#rad : 고속도로 접근성 지수 
#tax : 10,000 달러 당 재산세율 
#ptratio : 도시별 학생/교사 비율 
#black : 자치 도시별 흑인 비율 
#lstat : 하위계층 비율 
#medv(y) : 소유 주택가격 중앙값 (단위 : $1,000)

# 'data.frame':	506 obs. of  14 variables:
# y = medv(주택의 중앙값)
# x = 13칼럼

# 랜덤포레스트의 설명변수 개수 a는 얼마가 적당한가
# 회귀트리 : 1/3p 분류트리: p의 제곱근=sqrt(전체변수 개수)
# 변수간 상관성에 따라

p = 14
(1/3) * p # 4.666667

mtry = round((1/3)*p) # 반올림
mtry = floor((1/3)*p) # 절삭(내림)
mtry # 4
?randomForest
model3 <- randomForest(medv ~ ., 
                       data = Boston, 
                       ntree=500, # tree 개수
                       mtry = mtry, # 자식노드로 나눌 때 고려할 변수의 개수
                       importance = TRUE, # 변수의 중요도를 알아볼 때
                       na.action = na.omit) # na가 있을 때 어떻게 하겠는지
model3
#  Mean of squared residuals: 10.29901 (MSE, ERROR)

# 중요변수 시각화
varImpPlot(model3)
str(Bostom)













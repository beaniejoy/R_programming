# chap11_Correlation


# dataset 가져오기
product <- read.csv("product.csv")
# 친밀도, 적절성, 만족도 : 5점 (등간척도)
str(product)


# 1. 상관분석
# - 두 변수의 확률분포의 상관관계 정도를 나타내는 계수 (-1 ~ +1)
# 비율, 등간척도 : pearson / 순서척도 : spearman
corr <- cor(product, method="pearson") # 상관계수 행렬
#               제품_친밀도 제품_적절성 제품_만족도
# 제품_친밀도   1.0000000   0.4992086   0.4671450
# 제품_적절성   0.4992086   1.0000000   0.7668527
# 제품_만족도   0.4671450   0.7668527   1.0000000

#만족도와 적절성이 높은 상관관계를 가지고 있다.(양의 상관관계)

cor(x=product$제품_적절성, y=product$제품_만족도) # 0.7668527


# 2. 상관분석 시각화
install.packages("corrplot")
library(corrplot)

corrplot(corr, method="number")
corrplot(corr, method="square")
corrplot(corr, method="circle")

install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)

chart.Correlation(product)


# 공분산
# - 두 변수의 확률분포의 상관관계 정도를 나타내는 값

# 상관계수 vs 공분산
# 상관계수 : 상관관계의 정도(크기), 방향(양, 음의 방향)
# 공분산 : 정도(크기)를 알려줌
cov(product) # 공분산 행렬
#               제품_친밀도 제품_적절성 제품_만족도
# 제품_친밀도   0.9415687   0.4164218   0.3756625
# 제품_적절성   0.4164218   0.7390108   0.5463331
# 제품_만족도   0.3756625   0.5463331   0.6868159
# 대각선 제외하고 만족도, 적절성 간에 공분산이 가장 크다.



##################
# iris 적용
##################
cor(iris[-5])
#              Sepal.Length Sepal.Width Petal.Length Petal.Width
# Sepal.Length    1.0000000  -0.1175698    0.8717538   0.8179411
# Sepal.Width    -0.1175698   1.0000000   -0.4284401  -0.3661259
# Petal.Length    0.8717538  -0.4284401    1.0000000   0.9628654
# Petal.Width     0.8179411  -0.3661259    0.9628654   1.0000000
#  -> Sepal.Length와 Petal.Length간에 가장 강한 상관관계를 보임

# 산점도 표현 / 양의 상관계수 0.9628654
plot(iris$Petal.Length, iris$Petal.Width)

# 음의 상관계수 -0.4284401
plot(iris$Sepal.Width, iris$Petal.Length)





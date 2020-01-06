#################################
## <제12장 연습문제>
################################# 

# 01. mpg의 엔진크기(displ)가 고속도록주행마일(hwy)에 어떤 영향을 미치는가?    
# <조건1> 단순선형회귀모델 생성 
# <조건2> 회귀선 시각화 
# <조건3> 회귀분석 결과 해석 : 모델 유의성검정, 설명력, x변수 유의성 검정  

library(ggplot2)
data(mpg)

x <- mpg$displ
y <- mpg$hwy

df <- data.frame(x, y)
# 단순선형회귀모델 생성
model <- lm(y ~ x,data=df)
# 회귀선 시각화
plot(df$x, df$y)
text(df$x, df$y, labels=df$y, cex=0.7, pos=1, col="blue") # 그래프에 번호 텍스트 부여
?text
abline(model, col="red")

# 회귀분석 결과 해석
summary(model)
# 모델 유의성검정: p-value: < 2.2e-16 < 0.05 (H0기각, 유의하다.)
# 설명력: Adjusted R-squared:  0.585 : 어느정도 설명력이 존재
# x변수 유의성 검정: t=-18.15 p=<2e-16 *** 유의하다. 설명력이 강하다.



# 02. product 데이터셋을 이용하여 다음과 같은 단계로 다중회귀분석을 수행하시오.
setwd("c:/dev/Rwork/data")
product <- read.csv("product.csv", header=TRUE)

#  단계1 : 학습데이터(train),검정데이터(test)를 7 : 3 비율로 샘플링
pro_idx <- sample(x= nrow(product), size = nrow(product)*0.7)
pro_idx

train_pro <- product[pro_idx, ]
test_pro <- product[-pro_idx, ]
dim(train_pro)
dim(test_pro)
train_pro

#  단계2 : 학습데이터 이용 회귀모델 생성 
#           변수 모델링) y변수 : 제품_만족도, x변수 : 제품_적절성, 제품_친밀도
model_pro <- lm(제품_만족도 ~ ., data=train_pro)
summary(model_pro)

#  단계3 : 검정데이터 이용 모델 예측치 생성 
pro_pred <- predict(model_pro, test_pro)
pro_true <- test_pro["제품_만족도"]

#  단계4 : 모델 평가 : cor()함수 이용  
cor(pro_true, pro_pred) # 0.7657624

# 03. ggplot2패키지에서 제공하는 diamonds 데이터 셋을 대상으로 
# carat, table, depth 변수 중 다이아몬드의 가격(price)에 영향을 
# 미치는 관계를 다중회귀 분석을 이용하여 예측하시오.
#조건1) 다이아몬드 가격 결정에 가장 큰 영향을 미치는 변수는?
#조건2) 다중회귀 분석 결과를 정(+)과 부(-) 관계로 해설

library(ggplot2)
data(diamonds)
names(diamonds)

data_dia <- diamonds[c("carat","depth","table","price")]

model_dia <- lm(price ~., data=data_dia)
summary(model_dia)
# Coefficients:
#              Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 13003.441    390.918   33.26   <2e-16 ***
# carat        7858.771     14.151  555.36   <2e-16 ***
# depth        -151.236      4.820  -31.38   <2e-16 ***
# table        -104.473      3.141  -33.26   <2e-16 ***

# price - table, depth은 -관계 / carat은 +관계, 전부 영향력이 상당히 강하다.
# Adjusted R-squared:  0.8537 
# p-value: < 2.2e-16 < 0.05

step <- stepAIC(model_dia, direction = "both")
step



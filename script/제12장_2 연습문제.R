#################################
## <제12장_2 연습문제>
################################# 

# 01.  admit 객체를 대상으로 다음과 같이 로지스틱 회귀분석을 수행하시오.
# <조건1> 변수 모델링 : y변수 : admit, x변수 : gre, gpa, rank 
# <조건2> 7:3비율로 데이터셋을 구성하여 모델과 예측치 생성 
# <조건3> 분류 정확도 구하기 

# 파일 불러오기
setwd("c:/dev/Rwork/data")
admit <- read.csv("admit.csv")
str(admit) # 'data.frame':	400 obs. of  4 variables:
#$ admit: 입학여부 - int  0 1 1 1 0 1 1 0 1 0 ...
#$ gre  : 시험점수 - int  380 660 800 640 520 760 560 400 540 700 ...
#$ gpa  : 시험점수 - num  3.61 3.67 4 3.19 2.93 3 2.98 3.08 3.39 3.92 ...
#$ rank : 학교등급 - int  3 3 1 4 4 2 1 2 3 2 ...

# 1. train/test data 구성 
ad_idx <- sample(x = nrow(admit),size = nrow(admit) * 0.7, replace = F )
train_ad <- admit[ad_idx, ]
test_ad <- admit[-ad_idx, ]

# 2. model 생성 
model_ad <- glm(admit ~ ., data = train_ad, family = 'binomial')
model_ad
summary(model_ad)
# Coefficients:
#              Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -4.284665   1.401744  -3.057 0.002238 ** 
# gre          0.002718   0.001365   1.992 0.046362 *  
# gpa          0.934895   0.396455   2.358 0.018367 *  
# rank        -0.565157   0.156750  -3.605 0.000312 ***

# 3. predict 생성 
pred_ad <- predict(model_ad, newdata=test_ad, type="response")
pred_ad
range(pred_ad)
summary(pred_ad)

# 4. 모델 평가(분류정확도) : 혼돈 matrix 이용/ROC Curve 이용
ad_pred <- ifelse(pred_ad >= 0.5, 1, 0)
ad_true <- test_ad$admit

# 1) 혼돈 matrix 이용
t <- table(ad_true, ad_pred)
t
#       ad_pred
# ad_true  0  1
#       0 77  7 84
#       1 25 11 36
acc <- (77 + 11) / sum(t)
acc # 0.7333333

# 특이도
specificity <- 77 / 84
# 재현율(민감도)
recall_ad <- 11 / 36
# 정확률
prec_ad <- 11 / 18

fvalue_ad <- 2*((prec_ad*recall_ad)/(prec_ad+recall_ad))

# 2) ROCR 패키지 제공 함수 : prediction() -> performance
pr <- prediction(pred_ad, test_ad$admit)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)




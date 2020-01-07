# chap13_1_DecisionTree

# 관련 패키지 설치
install.packages("rpart")
library(rpart)

# tree 시각화 패키지
install.packages("rpart.plot")
library(rpart.plot)

# 1. dataset(train/test) : iris
idx <- sample(nrow(iris), nrow(iris)*0.7)
train <- iris[idx, ]
test <- iris[-idx, ]
names(iris)

summary(train$Species)

# 2. 분류모델
model <- rpart(Species ~ ., data=train)
model
# 시작노드를 시작으로 3:3:3으로 분류

# 분류모델 시각화
rpart.plot(model)
# 가장 중요한 요소(칼럼)가 루트노드 분류조건으로 온다.
# [중요변수] 가장 중요한변수 : "Petal.Length"

# 3. 모델 평가
y_pred <- predict(model, test) # 비율 예측치
y_pred

y_pred <- predict(model, test, type="class")
y_pred

y_true <- test$Species

# 교차분할표(Confusion matrix)
table(y_true, y_pred)

acc <- (15 + 13 + 16) / nrow(test)
acc # 0.9777778


######################
# Titanic 분류분석
######################

titanic3 <- read.csv("titanic3.csv")
str(titanic3)


# int -> Factor(범주형) 변환
titanic3$survived <- factor(titanic3$survived, levels=c(0,1))
table(titanic3$survived)
# 0   1 
# 809 500 
809 / 1309 # 0.618029

# subset 생성 : 칼럼 제외
titanic <- titanic3[-c(3, 8, 10, 12:14)]
str(titanic)
# 'data.frame':	1309 obs. of  8 variables:
# survived: Factor w/ 2

# train/test set
idx <- sample(nrow(titanic), nrow(titanic)*0.8)
train <- titanic[idx, ]
test <- titanic[-idx, ]

model <- rpart(survived ~ ., data=train)
model
rpart.plot(model)

y_pred <- predict(model, test, type="class")
y_true <- test$survived

table(y_true, y_pred)
#       y_pred
# y_true   0   1
#      0 148  17
#      1  34  63
acc <- (148 + 63) / nrow(test)
acc # 0.8053435

table(test$survived)
#   0   1 
# 165  97 

# 정확률
precision <- 63 / 80
precision # 0.7875
# 재현율(민감도)
recall <- 63/97
recall # 0.6494845
# F1 score
f1_score <- 2*(precision*recall)/(precision+recall)
f1_score




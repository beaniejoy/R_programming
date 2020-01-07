# chap10_Ttest_Anova

#############################
# 1-1. 단일집단 비율차이 검정
#############################

# - 비모수 검정

# 1) data 가져오기
setwd("c:/dev/Rwork/data")

data <- read.csv("one_sample.csv")
head(data)


# 2) 빈도/통계량
x <- data$survey
summary(x)
table(x)
# 0(불만족)   1(만족) 
#   14         136     -> 150

# 3) 가설검정
# - 방향성이 없는 가설
# binom.test(성공횟수, 시행횟수, p=확률)
# (성공횟수: 여기서는 불만족의 명수, 시행횟수: 150, p= 20% : 14년도 불만족 고객비율)
binom.test(14, 150, p=0.2)
# p-value = 0.0006735 < 0.05 (H0기각, 15년도 CS교육후 차이가 발생)
binom.test(14, 150, p=0.2, alternative = "two.sided", conf.level = 0.95)
# 위와 같은 표현

?binom.test
# binom.test(x, n, p = 0.5,
#            alternative = c("two.sided", "less", "greater"),
#            conf.level = 0.95)
# "two.sided" : 양측검정을 기본으로 하고 있음
# conf.level = 0.95 : 신뢰수준 95% 기본

# - 대립가설 채택: 방향성이 있는 가설
# 기존의 비율이 더 큰지, 새로운 집단의 비율이 더 큰지
# 알아보고자 할 때 방향성이 있는 가설이라고 한다.
# 2015(14) > 2014(20%) - 기각(연구가설)
binom.test(14, 150, p=0.2, alternative = "greater") # 신뢰수준 95% 기본
# p-value = 0.9999 >= 0.05 (H0 채택, HA 기각)

# 2015(14) < 2014(20%) - 채택(연구가설)
binom.test(14, 150, p=0.2, alternative = "less")
# p-value = 0.0003179 < 0.05 (H0 기각, HA 채택)

# [해설] 불만율이 14년도가 더 많다. 15년도 cs교육이 어느정도 효과가 있었다.


#############################
# 1-2. 단일집단 평균차이 검정
#############################
data <- read.csv("one_sample.csv")
head(data)

time <- data$time
mean(time, na.rm=T) # 5.556881
x <- na.omit(time)
x
length(x) # 109

# 3) 전체조건 : 정규성검정
shapiro.test(x)
# W = 0.99137, p-value = 0.7242

# 4) 단일집단 평균차이 검정
t.test(x, mu=5.2)
# t = 3.9461, df = 108, p-value = 0.0001417 < 0.05
?t.test # 양측검정을 기본으로 한다.
# p-value = 0.0001417 < 0.05 H0기각
# t: -1.96 ~ +1.96 (95%) : 채택역


# 대립가설 : 단측검정(방향성)
# A회사 > 국내(0)
t.test(x, mu=5.2, alternative = "greater")
# p-value = 7.083e-05 < 0.05

# A회사 < 국내(X)
t.test(x, mu=5.2, alternative = "less")
# p-value = 0.9999 >= 0.05


#############################
# 2-1. 두 집단 비율 차이 검정
#############################
# 1) 실습데이터 가져오기
data <- read.csv("two_sample.csv", header=TRUE)
head(data)

# 2) 두 집단 subset 설정
data$method
data$survey
# 데이터 정제/전처리
x <- data$method
y <- data$survey

table(x)
table(y)

table(x, y)
# y
# x  0   1(만족)
# 1  40 110 -> 집단1(ppt)
# 2  15 135 -> 집단2(실습)

# 3) 두 집단 비율차이 검증 - prop.test()
help(prop.test)

# 양측검정
# prop.test(x(), n(시행횟수), p, alternative, correct)
prop.test(c(110,135), c(150,150))
# p-value = 0.0003422
# prop 1    prop 2 
# 0.7333333 0.9000000
prop.test(c(110,135), c(150,150), alternative="two.sided")
# p-value = 0.0003422

# 대립가설 : 단측검정(방법1 > 방법2)
prop.test(c(110,135), c(150,150), alternative = "greater")
# p-value = 0.9998

# 대립가설 : 단측검정(방법1 < 방법2) - 채택
prop.test(c(110,135), c(150,150), alternative = "less")
# p-value = 0.0001711 < 0.05 (HA채택)


#############################
# 2-2. 두 집단 평균차이 검정
#############################
data <- read.csv("two_sample.csv", header=TRUE)
data
print(data)
head(data)
summary(data) #NA 존재 유무

result <- subset(data, !is.na(score), c(method, score))
result
length(result$score) # 227

# 데이터 분리
# 1) 교육방법 별로 분리
a <- subset(result, method == 1)
b <- subset(result, method == 2)

# 2) 교육방법에서 점수 추출
a1 <- a$score
b1 <- b$score

# 3) 분포모양 검정 : 두 집단의 분포 모양 일치 여부 검정
# 귀무가설 : 두 집단 간 분포의 모양이 동질적이다.
# 두 집단간 동질성 비교(분포모양 분석)
var.test(a1, b1) # p = 0.3002 >=0.05 (차이가 없다.)
# 동질성 분포: t.test()
# 비동질성 분포: wilcox.test()

# 4) 가설검정 - 두 집단 평균 차이검정
t.test(a1, b1) # p-value = 0.0411 < 0.05 (차이가 존재)

# 대립가설 : a1 > b1 (x)
t.test(a1, b1, alternative = "greater")
# p-value = 0.9794 >= 0.05 (H0 채택)

# 대립가설 : a1 < b1 (o)
t.test(a1, b1, alternative = "less")
# p-value = 0.02055 < 0.05 (HA 채택)


#############################
# 3. 분산분석
#############################
# 두 집단 이상 평균차이검정(집단 분산 차이 검정)
# 일원배치분산분석 : 독립변수(x), 종속변수(y)
# cf) 이원배치분산분석 : y ~ x1 + x2

# aov(y ~ x, data = dataset)

# 독립변수 : 집단변수(범주형 변수)
# 종속변수 : 연속형 변수(비율, 등간척도)
# ex) 쇼핑몰 고객의 연령대(20, 30, 40, 50) 별 구매금액(연속)
# 독립변수 : 연령대, 종속변수 : 구매금액

# 귀무가설 : 집단별 평균(분산)의 차이가 없다.
# 대립가설 : 적어도 한 집단에 평균 차이가 있다.

###################
# iris dataset
###################

# 귀무가설 : 꽃이 종별로 꽃받침의 길이 차이가 없다.(기각)
# 연구가설 : 꽃이 종별로 꽃받침의 길이 차이가 있다.(채택)
# 1. 변수 선택
str(iris)

x <- iris$Species # 집단변수 
y <- iris$Sepal.Width # 연속형

# 2. data 전처리

# 3. 동질성 검정
bartlett.test(y ~ x) # , data=iris는 생략
# bartlett.test(Sepal.Width ~ Species, data=iris)
# p-value = 0.3515 >= 0.05 -> H0 기각X, 모양에 차이가 없다.
# (분포모양이 동질적) aov( ) 사용

# 4. 분산분석 : aov(y ~ x, data)
model <- aov(Sepal.Width ~ Species, data=iris)
model

# 5. 분산분석
summary(model)
# F value Pr(>F)
# 49.16   <2e-16 *** (p-value가 < 0.05 현격하게 낮음)
# (분산의 차이의 정도에 따라 별의 개수가 달라짐, 3개가 제일 크다.)

# [해설] <2e-16 : 적어도 한 집단 이상에 평균 차이가 존재
TukeyHSD(model)
#   diff(집단간 분산(평균)차이)  lwr       
# versicolor-setosa    -0.658 -0.81885528 (-부호는 의미 없다.)
# virginica-setosa     -0.454 -0.61485528 (diff 절대값이 가장 큰값이 가장 큰 차이를 보임)
# virginica-versicolor  0.204  0.04314472  0.3648553
#                       p adj (< 0.05, 연구가설 채택, 유의미한 수준에서 집단간 차이를 보임)
# versicolor-setosa    0.0000000
# virginica-setosa     0.0000000
# virginica-versicolor 0.0087802

# A-B-C 세집단 간에 서로 일치하지 않는다.
# p-value : 집단 간 평균차이 존재유무를 해설
# diff : 평균차이 정도


# 신뢰구간 : 집단 간 평균차이 유무 해설
plot(TukeyHSD(model))
# 신뢰구간에 0.0을 걸치고 있으면 


# 통계검정 : 각 집단의 평균차이
library(dplyr) # dataset %>% function
iris %>% 
  group_by(Species) %>% 
  summarise(avg=mean(Sepal.Width))
# Species       avg
# 1 setosa      3.43
# 2 versicolor  2.77
# 3 virginica   2.97

2.77 - 3.43 # -0.66(위의 diff에서 -0.658)
# versicolor-setosa
2.97 -2.77 # 0.2
# virginica-versicolor


################
# 비모수 검정
################

# 1. 변수 선택 
names(iris)
x <- iris$Species
y <- iris$Sepal.Length

# 2. 동질성 검정
bartlett.test(Sepal.Length ~ Species, data=iris)
# p-value = 0.0003345 < 0.05 : 비모수검정


# 3. 분산분석(비모수 검정) : 평균 -> 중위수를 대푯값으로
model_k <- kruskal.test(Sepal.Length ~ Species, data = iris)
# Kruskal-Wallis chi-squared = 96.937, df = 2, p-value < 2.2e-16

# 4.사후검정 : 집단별 중위수 비교
library(dplyr)
iris %>% 
  group_by(Species) %>% 
  summarise(median(Sepal.Length))
# Species           median(Sepal.Length)            
# 1 setosa                        5  
# 2 versicolor                    5.9
# 3 virginica                     6.5


################
# quakes
################

# 1. 전처리
str(quakes)
# 'data.frame':	1000 obs. of  5 variables:
# $ lat (위도)    : num  -20.4 -20.6 -26 -18 -20.4 ...
# $ long(경도)    : num  182 181 184 182 182 ...
# $ depth(깊이)   : int  562 650 42 626 649 195 82 194 211 622 ...
# $ mag(규모)     : num  4.8 4.2 5.4 4.1 4 4 4.8 4.4 4.7 4.3 ...
# $ stations(관측소): int  41 15 43 19 11 12 43 15 35 19 ...


y <- quakes$mag # 연속변수 y
x <- quakes$depth # 집단변수(연속형인데 범주형으로 전환)
  
range(quakes$depth) # 40(최솟값) 680(최댓값)
# 680 - 40 = 640
div <- round(640 / 3) # 213

# 코딩변경(연속형 -> 범주형)
quakes$depth2[quakes$depth <= (40 + div)] <- "low"
quakes$depth2[quakes$depth > (40 + div) & quakes$depth <= 680-div] <- "mid"
quakes$depth2[quakes$depth > 680-div] <- "high"

y <- quakes$mag # 연속형(y)
x <- quakes$depth2 # 범주형(x)

# 2. 동질성 검정
bartlett.test(y ~ x)
# p-value = 0.1554 >= 0.05 (모수검정)

# 3. 분산분석(모수 검정)
result <-aov(y ~ x)
result
summary(result)
# Pr(>F) = 5.78e-14 *** (분산의 차이가 엄청 크다.)
# [해설] 매우 유의미한 수준에서 집단간 차이를 보인다.

# 4. 사후검정
TukeyHSD(result)
#               diff        lwr         upr     p adj
# low-high  0.17127705  0.1083477  0.23420643 0.0000000
# mid-high -0.07543586 -0.1702399  0.01936818 0.1486744 >= 0.05(차이가 없다.)
# mid-low  -0.24671291 -0.3380606 -0.15536522 0.0000000

plot(TukeyHSD(result))




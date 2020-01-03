#################################
## <제13장 연습문제>
################################# 

# 01. 중소기업에서 생산한 HDTV 판매율을 높이기 위해서 프로모션을 진행한 결과 
#  기존 구매비율  보다 15% 향상되었는지를 각 단계별로 분석을 수행하여 검정하시오.
#귀무가설(H0) : 기존 구매비율과 차이가 없다. (양측검정)
#연구가설(H1) : 기존 구매비율과 차이가 있다. (차이가 존재할시 단측검정해서 방향성있는 검정을 해야한다.)

#조건) 구매여부 변수 : buy (1: 구매하지 않음, 2: 구매)

# 단계1 : 데이터셋 가져오기
hdtv <- read.csv("hdtv.csv")

# 단계2 :  빈도수와 비율 계산
summary(hdtv) 
length(hdtv$buy) # 50개

table(hdtv$buy)
table(hdtv$buy, useNA="ifany") # NA 빈도수 표시


# 단계3 : 가설검정

binom.test(10, 50, p=0.15) # 양측검정
# p-value = 0.321 > 0.05 (H0 채택)
# 사실 위에서 H0채택이 되었기에 단측검정 할필요가 없음
# 단측검정 : 현재집단 > 기존집단
binom.test(10, 50, p=0.15, alternative = "greater")
# p-value = 0.2089 > 0.05

# 단측검정 : 현재집단 < 기존집단
binom.test(10, 50, p=0.15, alternative = "less")
# p-value = 0.8801 > 0.05


# 단계4 : 검정결과 해설 
# 기존 구매비율과 차이가 없다고 볼 수 있다.


# 02. 우리나라 전체 중학교 2학년 여학생 평균 키가 148.5cm로 알려져 있는 상태에서  
# A중학교 2학년 전체 500명을 대상으로 10%인 50명을 표본으로 선정하여 표본평균신장을 
# 계산하고 모집단의 평균과 차이가 있는지를 각 단계별로 분석을 수행하여 검정하시오.

# 단계1 : 데이터셋 가져오기
stheight<- read.csv("student_height.csv")
stheight
height <- stheight$height
head(height)

# 단계2 : 기술통계량/결측치 확인
length(height) #50
summary(height) # 149.4 

x1 <- na.omit(height)
x1 # 정제 데이터 
mean(x1) # 149.4 -> 평균신장

# 단계3 : 정규성 검정
shapiro.test(x1) # p-value = 0.0001853

# 단계4 : 가설검정 - 양측검정
# t.test(x, mu) 정규분포포
wilcox.test(x1, mu=148.5) # 비정규분포
# p-value = 0.067 >= 0.05


# 03. 대학에 진학한 남학생과 여학생을 대상으로 진학한 대학에 대해서
# 만족도에 차이가 있는가를 검정하시오.

# 힌트) 두 집단 비율 차이 검정
#  조건) 파일명 : two_sample.csv, 변수명 : gender(1,2), survey(0,1)
# gender : 남학생(1), 여학생(2)
# survey : 불만(0), 만족(1)
# prop.test('성공횟수', '시행횟수')

# 단계1 : 실습데이터 가져오기
getwd()
data <- read.csv("two_sample.csv")
data
head(data) # 변수명 확인

# 단계2 : 두 집단 subset 작성
x <- data$gender
y <- data$survey

table(x, y)
# y
# x   0   1
# 1  36 138
# 2  19 107
# 단계3 : 두집단 비율차이검증 : prop.test()
prop.test(c(138,107), c(174, 126))
# p-value = 0.2765 >= 0.05 (H0채택, 만족도에 차이가 없다.)



# 04. 교육방법에 따라 시험성적에 차이가 있는지 검정하시오.

#힌트) 두 집단 평균 차이 검정
#조건1) 파일 : twomethod.csv
#조건2) 변수 : method : 교육방법, score : 시험성적
#조건3) 모델 : 교육방법(명목)  ->  시험성적(비율)
#조건4) 전처리 : 결측치 제거 : 평균으로 대체 

#단계1. 실습파일 가져오기
Data <- read.csv("twomethod.csv", header=TRUE)
head(Data) #3개 변수 확인 -> id method score

#단계2. 두 집단 subset 작성
# subset 생성 
Data <- Data[c('method', 'score')] 
# score 결측치 처리 
Data$score <- ifelse(is.na(Data$score), mean(Data$score, na.rm=T), Data$score)
summary(Data)


#단계3. 데이터 분리
# 1) 집단(교육방법)으로 분리
a <- subset(Data, method == 1)
b <- subset(Data, method == 2)

# 2) 교육방법에서 시험성적 추출
a1 <- a$score
b1 <- b$score
#단계4 : 분포모양 검정
var.test(a1, b1) # p=0.7302 >0.05 (차이가 없다.) => 동질성 분포


#단계5: 가설검정
t.test(a1, b1)
# p-value = 1.859e-06 < 0.05 (차이가 존재)
t.test(a1, b1, alternative = "greater") # (X)
# p-value = 1 >= 0.05 (H0 채택)
t.test(a1, b1, alternative = "less") # (O)
# p-value = 9.295e-07 (HA 채택)
# a1 < b1

# 05.airquality를 대상으로 월별(Month)로 오존량(Ozone)에 차이가 있는지 검정하시오

airquality
str(airquality)
summary(airquality)
# $ Ozone -> y : 연속형변수
# $ Month -> x : 집단 변수

# 단계1. 전처리(결측치 제거)

air <- subset(airquality, !is.na(Ozone), c(Ozone, Month))
dataset <- na.omit(airquality)

# 단계2. 동질성 검정
bartlett.test(Ozone ~ Month, data=dataset)
# p-value = 0.007395 < 0.05 (비모수)

# 단계3 : 분산분석(모수 vs 비모수)
kruskal.test(Ozone ~ Month, data=dataset)
# p-value = 2.742e-05 : 집단별 분산 차이

# 단계4: 사후검정 : 집단별 중위수
dataset %>%
  group_by(Month) %>%
  summarise(med = median(Ozone))
# Month   med
#  5      18
#  6      23
#  7      60
#  8      45
#  9      23
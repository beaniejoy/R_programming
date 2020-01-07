# chap06_DataVisualization

# 1. 이산변수(discrete quantitative data) 시각화
# - 정수단위로 나누어 측정할 수 있는 변수(자녀수, 판매수)


# 차트 데이터 생성
chart_data <- c(305,450, 320, 460, 330, 480, 380, 520) 
names(chart_data) <- c("2016 1분기","2017 1분기","2016 2분기","2017 2분기","2016 3분기","2017 3분기","2016 4분기","2017 4분기")
str(chart_data)
chart_data


# 1) 막대차트 시각화
barplot(chart_data, 
        ylim = c(0, 600),
        col = rainbow(8),
        main = "2016년도 vs 2017년도 분기별 매출현황")

# 가로막대차트
barplot(chart_data, 
        xlim = c(0, 600),
        col = rainbow(8), horiz = TRUE,
        main = "2016년도 vs 2017년도 분기별 매출현황")

# 1행 2열 구조
par(mfrow=c(1,2)) # 1 행 2열 그래프 보기

barplot(VADeaths, 
        beside=T, 
        col=rainbow(5), 
        main="미국 버지니아주 하위계층 사망비율")

# 누적형 막대차트
barplot(VADeaths, 
        beside=F, 
        col=rainbow(5), 
        main="미국 버지니아주 하위계층 사망비율")

# 2) 점 차트 시각화
par(mfrow = c(1,1)) # 1행 1열
dotchart(chart_data,
         color = c("green", "red"), 
         labels = names(chart_data),
         xlab = "매출액",
         main = "분기별 판매현황")

# 3) 파이 차트 시각화
pie(chart_data, 
    labels = names(chart_data),
    col=rainbow(8), cex = 1.2)

# 2. 연속변수(Continuous quantitative data)
# - 시간, 길이 등과 같이 연속 

# 1) 상자 그래프 시각화
VADeaths
str(VADeaths)
# num[1:5, 1:4] -> matrix
summary(VADeaths)

# IQR 기준으로 outlier와 평균치범위를 보여준다.
boxplot(VADeaths, range=0)


# 2) 히스토그램 시각화 : 대칭성 확인
iris
head(iris)

#최대값 최소값을 보여주는 메소드
range(iris$Sepal.Length) # 4.3 7.9
mean(iris$Sepal.Length) # 5.843333

hist(iris$Sepal.Length, 
     xlab = "Sepal.Length",
     col = "magenta",
     main = "iris 꽃받침 길이", xlim = c(4, 8))


range(iris$Sepal.Width) # 2.0 4.4
mean(iris$Sepal.Width) # 3.057333

hist(iris$Sepal.Width, 
     xlab = "Sepal.Width",
     col = "green",
     main = "iris 꽃받침 넓이", xlim = c(2, 4.5))


# 정규분포 가설 : 정규분포와 차이가 없다. H0 (알파보다 유의수준이 더 높아야 한다.)
# 정규성 검정 (가설검정)

shapiro.test(iris$Sepal.Length) # p-value = 0.01018 < 알파 = 0.05 / H0 기각
shapiro.test(iris$Sepal.Width) # p-value = 0.1012 > 0.05 / H0 채택


# 3) 선점도 시각화
price <- runif(10, min=1, max=100)

plot(price) # y: price, x :index

plot(price, type="o") # circle
plot(price, type="l") # line
plot(price, type="h") # height
plot(price, type="s") # step


# 만능 차트
par(mfrow = c(1,1))
data()

# 시계열 데이터 시각화
AirPassengers # 시계열 데이터
plot(AirPassengers)

plot(WWWusage)


# 회귀모델 -> 회귀모델 시각화(regression model)
install.packages("HistData")
library(HistData)
library(help="HistData")

data(Galton)
str(Galton) # 'data.frame':	928 obs. of  2 variables:
# $ parent: num
# $ child : num

model <- lm(child ~ parent, data = Galton) #lm(y ~ x)
model # Coefficients
summary(model)

# 회귀모델 관련 시각화
plot(model) # Residuals 잔차: 예측치와 실측치의 차이

methods(plot)


# 3. 변수간의 비교 시각화
?pairs
pairs(iris[1:4])
str(iris)
# 꽃의 종별 변수 비교
unique(iris$Species)
# Levels: setosa versicolor virginica

pairs(iris[iris$Species=='setosa',1:4])
pairs(iris[iris$Species=='versicolor',1:4])
pairs(iris[iris$Species=='virginica',1:4])


# 4. 차트 파일 저장
install.packages("jpeg")
library(jpeg)
setwd("c:/dev/Rwork/data/output")
jpeg("iris.jpg", width = 720, height = 480)
plot(iris$Sepal.Length, iris$Petal.Length) # x축, y축
title("iris dataset 시각화")
dev.off()



#########################
### 3차원 산점도 
#########################
install.packages('scatterplot3d')
library(scatterplot3d)

# 꽃의 종류별 분류 
iris_setosa = iris[iris$Species == 'setosa',]
iris_versicolor = iris[iris$Species == 'versicolor',]
iris_virginica = iris[iris$Species == 'virginica',]

# scatterplot3d(밑변, 오른쪽변, 왼쪽변, type='n') # type='n' : 기본 산점도 제외 
d3 <- scatterplot3d(iris$Petal.Length, iris$Sepal.Length, iris$Sepal.Width, type='n')

d3$points3d(iris_setosa$Petal.Length, iris_setosa$Sepal.Length,
            iris_setosa$Sepal.Width, bg='orange', pch=21)

d3$points3d(iris_versicolor$Petal.Length, iris_versicolor$Sepal.Length,
            iris_versicolor$Sepal.Width, bg='blue', pch=23)

d3$points3d(iris_virginica$Petal.Length, iris_virginica$Sepal.Length,
            iris_virginica$Sepal.Width, bg='green', pch=21)




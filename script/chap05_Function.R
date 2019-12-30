# chap05_Function

# 함수 : 사용자정의함수, 내장함수


# 1. 사용자 정의함수

# 형식)
# 함수명 <- function(인수){
#   명령문1
#   명령문2
#   return(값)
#   
# }

# 1) 매개변수가 없는 함수
# 함수정의
user_fun1 <- function(){
  cat("user_fun1")
}

# 함수호출
user_fun1()

# 2) 매개변수가 있는 함수
user_fun2 <- function(x, y){
  z <- x + y
  cat('z=', z)
}
user_fun2(10,20)


# 3) 반환값이 있는 경우
user_fun3 <- function(x, y){
  z <- x + y
  return(z)
}

z = user_fun3(100, 200)
z


# 문) 다음과 같은 함수를 만드시오.
# 조건1> 함수명 : calc(x, y)
# 조건2> 인수 2개 : x, y
# 조건3> 처리문 : 사칙연산(+, -, *, /) 출력

calc <- function(x, y){
  cat(x + y, "\n")
  cat(x - y, "\n")
  cat(x * y, "\n")
  cat(x / y, "\n")
  add <- x + y
  sub <- x - y
  div <- x / y
  mul <- x * y
  # return(add, sub, div, mul)
  # 다중인자 반환은 허용되지 않는다.
  calc_re <- data.frame(add, sub, div, mul)
  return(calc_re)
}

result <- calc(100, 20)
class(result) # "data.frame"
result


# ex1) 결측치 자료 처리 함수
na <- function(data){
  # 1차 : NA 제거
  print(data)
  print(mean(data, na.rm = T))
  
  # 2차 : NA -> 0 대체
  tmp <- ifelse(is.na(data), 0, data)
  print(mean(tmp))
  # 3차 : NA -> 평균 대체
  tmp <- ifelse(is.na(data), mean(data,na.rm = T), data)
  print(mean(tmp))
}


data <- c(10,2,5,NA,60,NA,3)
na(data)

# ex2) 특수문자 처리 함수
install.packages("stringr")
library(stringr)
library(help = "stringr")

string <- "홍길동35이순신45유관순25"
names <- str_extract(string, "[가-힣]{3}")
names # "홍길동"
names <- str_extract_all(string, "[가-힣]{3}")
names # list
# [[1]] -> key
# [1] "홍길동" "이순신" "유관순" -> value
names <- unlist(names) # list -> vector
names
# [1] "홍길동" "이순신" "유관순"


string2 <- "$(123,456)%"
string2 * 2 # 에러
# - 특수문자 제거
tmp <- str_replace_all(string2, "\\$|\\(|\\,|\\)|\\%", "")
tmp # "123456"
# - string -> num 숫자형으로 변환
num <- as.numeric(tmp)
num * 2


# 특수문자 처리 함수 정의
data_pro <- function(data){
  library(stringr) # library를 in memory 먼저 시키고
  
  tmp <- str_replace_all(data, "\\$|\\(|\\,|\\)|\\%", "")
  tmp
  
  num <- as.numeric(tmp) 
  
  return(num)
}
tmp_num <- data_pro("$(123,456)%")
tmp_num



setwd("c:/dev/Rwork/data")
stock <- read.csv("stock.csv")
str(stock) # 'data.frame':	6706 obs. of  69 variables:

# subset : 1 ~ 15
stock_df <- stock[c(1:15)]
str(stock_df) # 'data.frame':	6706 obs. of  15 variables:
head(stock_df)

# 숫자(7~15) : 특수문자 제거
stock_num <- apply(stock_df[c(7:15)], 2, data_pro)
stock_num

# 문자열 칼럼 + 숫자 칼럼
new_stock <- cbind(stock_df[c(1:6)], stock_num)
head(new_stock)




# 2. 내장함수

# 1) 기본 내장 함수
data <- runif(20, min = 0, max = 100) # 0~100, 20개의 랜덤값 뽑기
data # 랜덤으로 발생(순서x)

min(data)
max(data)
range(data) # min값 ~ max값
mean(data)
median(data)
(data[10] + data[11]) / 2 # 이건 정렬이 되어있어야함

sdata <- sort(data) # 기본적으로 오름차순
(sdata[10] + sdata[11]) / 2 # median(data)값이 나옴
sdata_desc <- sort(data, decreasing = T)


# 요약통계량
summary(data)

sum(data)
var(data)
sd(data)

# 제곱/제곱근
4^2
sqrt(16)


# 정렬 : sort() / order()
data(iris) # 붓꽃 
str(iris)
# 'data.frame':	150 obs. of  5 variables:
#   $ Sepal.Length(꽃받침 길이): num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
# $ Sepal.Width(넓이) : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
# $ Petal.Length(꽃잎 길이): num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
# $ Petal.Width(넓이) : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
# $ Species(꽃 종)     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
# 1~4칼럼 : 연속형(숫자 연산)
# 5칼럼 : 범주형(문자형), Factor

head(iris)

# 칼럼 단위 정렬(칼럼하나만 정렬할 때)
sort(iris$Sepal.Length) # 오름차순(내용, value)
sort(iris$Sepal.Length, decreasing = T)

# 행 단위 정렬(전체 데이터셋을 정렬할 때)
dim(iris) # 150(row)  5(col)
idx <- order(iris$Sepal.Length) # 오름차순(index) 몇번째 행이 제일 작은것인가 나타냄
iris_df <- iris[idx, ] # 이런식으로 정렬가능
head(iris_df)

summary(iris)



# 2) 로그, 지수

# (1) 일반로그 : log10(x) -> x는 10(밑수)의 몇제곱?
log10(10) # 1 -> 10^1 = x
log10(100) # 2
log10(0.1) # -1

# (2) 자연로그 : log(x) -> x는 e(밑수)의 몇제곱?
log(10) # 2.302585 -> e^2.302585 = 10
e <- exp(1) # e의 값=2.718282
e^2.302585 # 9.999999

# (3) 지수 : exp(x) -> e^x
exp(2) # 7.389056
e^2
log(7.389056) # 2

# 로그 vs 지수
x <- c(0.12, 1, 12, 999, 99999) # 999, 99999는 Inf(Infinity, 양의무한대)
exp(x)
# 1.127497e+00, 2.718282e+00, 1.627548e+05, Inf, Inf
# 지수함수 생각 -> 뒤에갈수록 급증함
log(x) 
# -2.120264  0.000000  2.484907  6.906755 11.512915
range(log(x))

# 로그함수 : 정규화(편향제거) -> x가 증가할수록 y 완만하게 증가 
# 지수함수 : 활성함수(sigmoid, softmax) -> x가 증가할수록 y 급격하게 증가


# 3) 난수 생성과 확률분포
install.packages('dplyr')
# 1. 정규분포를 따르는 난수 생성
# 형식) rnorm(n, mean, sd)
?rnorm
n <- 1000
r <- rnorm(n, mean = 0, sd = 1)
# 대칭 확인
hist(r)

# 2. 균등분포를 따르는 난수 생성
r2 <- runif(n, min = 0, max = 1) # 0~1 사이의 n개의 난수 생성
#균등한 비율로 그래프가 나타남
hist(r2)

# 3. 이항분포를 따르는 정수 난수 생성
# rbinom(n, size, prob)
# size : sample size, prob : 나올 수 있는 확률
n <- 10
r3 <- rbinom(n, size =1, prob=0.5) # sample size가 나올 수 있는 확률 0.5
r3 # 1 0 1 1 1 0 0 0 0 1

r3 <- rbinom(n, size=1, prob=0.25)
r3

r3 <- rbinom(n, size=2, prob=0.5)
r3

# 4. 종자값(seed)
set.seed(123)
r <- rnorm(10)
r

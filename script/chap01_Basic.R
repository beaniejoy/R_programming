# chap01_Basic

# 수업내용
# 1. session 정보 확인
# 2. R 실행방법
# 3. package와 dataset
# 4. 변수와 자료형
# 5. 기본 함수 사용 및 작업공간


# 1. session 정보 확인
# session : R의 실행환경
# R은 명령어보다도 함수로 진행
# 모든 함수는 패키지에 의해 관리(라이브러리) / sessionInfo() {utils}
sessionInfo()
# R ver, 다국어(locale)정보 제공, base packages 기본적으로 설치된 7개의 패키지



# 2. R 실행방법

# 주요 단축키
# script 실행 : ctrl + Enter or ctrl + R
# 자동완성 : ctrl + space
# 저장 : ctrl + s
# 주석: #밖에 없음, 
# 블럭으로 주석처리 할 때 구간 드래그하고 ctrl + shift + c
# a <- 10
# b <- 20
# c <- a + b
# print(c) # 30

# 1) 줄 단위 실행
a <- rnorm(n = 20) # 20개의 표준정규분포를 따르는 변수 생성
# <- or =
a
hist(a) # 히스토그램으로 보여줌
mean(a) # dataset a에 대한 평균값

# 2) 블럭 단위 실행
getwd() # 현재 작업경로 "C:/dev/Rwork"
pdf("test.pdf") # file open
hist(a) # draw histogram
dev.off() # close device
# 위의 3줄은 하나의 블럭으로 실행됨


# 3. package와 dataset

# 1) 패키지 = function + dataset (하나의 바구니로 담겨져있음)
# 어떠한 패키지는 function만 담겨져있음

# 사용 가능한 패키지
dim(available.packages()) # 사용가능한 패키지를 dim(차원 형태로)제공

# 패키지 설치/사용
install.packages("stringr") # 자연어, 문자열 처리할 때 쓰임
# 패키지 in memory
library(stringr) 
# 패키지는 메모리에 올라와 있어야 사용가능
# library()가 메모리에 올려줌


# 사용가능한 패키지 확인
search()

# 설치위치(외부패키지가 저장된 경로)
# 지울 때에도 이용
.libPaths()
str <- "홍길동 35 이순신 45 유관순 25"
str

# 이름 추출
str_extract_all(str, "[가-힣]{3}") #모든 한글문자를 지칭할 때 쓰임
# 나이 추출
str_extract_all(str, "[0-9]{2}")

# 패키지 삭제
remove.packages("stringr")

# 2) 데이터셋
data()
data("Nile") # in memory
Nile
length(Nile) # 1차원의 원소로 100개를 가지고 있다.
mode(Nile) # 자료형을 알 수 있다.
plot(Nile)
mean(Nile)


# 4. 변수와 자료형

# 1) 변수(variable) : 메모리 주소를 저장하는 역할
# - R의 모든 변수는 객체(참조변수)
# - 변수 선언 시 type이 없다. 
a <- c(1:10) # 벡터
a

# 2) 변수 작성 규칙
# - 첫자는 영문자
# - 점(.)을 사용 가능(lr.model)
# - 예약어 사용 불가
# - 대소문자 구분: num or NUM (다르게 인식)

var1 <- 0 # var1 = 0
# java) int var1 = 0
var1 <- 1
var1

var2 <- 10
var3 <- 20
var2; var3 # 동시에 확인 가능

# 객체 맴버
mamber.id <- "hong"
member.name <- "홍길동"
member.pwd <- "1234"

num <- 10
NUM <- 100
num; NUM

# scala(1) vs vector(n)
name <- c("홍길동", "이순신", "유관순")
name # [1] "홍길동" "이순신" "유관순"

name[2] # R은 index가 1부터 시작한다.

# tensor : scala(0), vector(1), matrix(2)

ls() # 메모리에 올라온 변수 목록

# 3) 자료형
# - 숫자형, 문자형, 논리형
int <- 100 # 숫자형(연산, 차트)
string <- "대한민국" # '대한민국'
boolean <- TRUE # T, FALSE(F)
# 자료형 반환 함수
mode(int) # "numeric"
mode(string) # "character"
mode(boolean) # "logical"

# is.xxx() 자료형 반환
is.numeric(int) # TRUE
is.character(string) # TRUE
is.logical(boolean) # TRUE

# NA
x <- c(100, 90, NA, 65, 78) # NA : 결측치
is.na(x) # 결측면 TRUE 반환

# 4) 자료형변환(casting)
# - 문자열 -> 숫자형
num <- c(10, 20, 30, "40")
num
mode(num) # 한개라도 string으로 바뀌면 character로 바뀜
mean(num) # 문자열이 들어간 벡터에서 평균 X
num <- as.numeric(num) # 형변환
mode(num) # numeric
mean(num) # 25
plot(num)

# - 요인형(factor)
# -> 동일한 값을 범주로 갖는 집단 변수 생성
# ex) 성별) 남(0), 여(1) -> 더미변수(범위변수)
gender <- c("M", "F", "M", "F", "M")
mode(gender) # character
plot(gender) # 숫자타입이 아니기에 Error

# 요인형 변환 : 문자열 -> 요인형
fgender <- as.factor(gender)
mode(fgender) # numeric으로 바뀜
fgender
# [1] M F M F M
# Levels: F M (영문자 알파벳 순으로 level이 결정)
str(fgender) # Factor w/ 2 levels "F","M": 2 1 2 1 2 (numeric)
plot(fgender) # 숫자 2,1,2,1,2 

# level을 원하는 문자로 정해서 결정가능
x <- c("M", "F")
fgender2 <- factor(gender, levels = x)
str(fgender2) # Factor w/ 2 levels "M","F": 1 2 1 2 1


# mode vs class
# mode() : 자료형 반환
# class() : 자료구조 반환
mode(fgender) # numeric
class(fgender) # factor / 자료형의 출처


# Factor형 고려사항
num <- c(4, 2, 4, 2)
mode(num) # numeric

fnum <- as.factor(num)
fnum
# [1] 4 2 4 2
# Levels: 2(1) 4(2)
str(fnum) # Factor w/ 2 levels "2","4": 2 1 2 1


# 요인형 -> 숫자형
num2 <- as.numeric(fnum)
num2 # [1] 2 1 2 1 (factor에서 level의 형태로 나옴)

# 요인형 -> 문자형 -> 숫자형(원래 내용으로 복귀하는 방법)
snum <- as.character(fnum) # "4" "2" "4" "2"
num2 <- as.numeric(snum) # 4 2 4 2
num2


# 5. 기본 함수 사용 및 작업공간

# 1) 함수 도움말
mean(10, 20, 30, NA) # 평균 - 10 (잘못된 결과)
x <- c(10, 20, 30, NA)
mean(x, na.rm = TRUE) # 20

help("mean")
?mean

sum(x, na.rm = TRUE)

# 2) 작업공간
getwd() # "C:/dev/Rwork"
setwd("C:/dev/Rwork/data")
getwd() # "C:/dev/Rwork/data"

test <- read.csv("test.csv")
test

# structure
str(test)
# 'data.frame':	402 obs. of  5 variables:
# obs. : 관측치 402(행)
# variables : 변수, 변인 5(열/칼럼)

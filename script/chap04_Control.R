# chap04_Control

# 제어문 : 조건문과 반복문


# <실습> 산술연산자 
num1 <- 100 # 피연산자1
num2 <- 20  # 피연산자2
result <- num1 + num2 # 덧셈
result # 120
result <- num1 - num2 # 뺄셈
result # 80
result <- num1 * num2 # 곱셈
result # 2000
result <- num1 / num2 # 나눗셈
result # 5

result <- num1 %% num2 # 나머지 계산
result # 0

result <- num1^2 # 제곱 계산(num1 ** 2)
result # 10000
result <- num1^num2 # 100의 20승
result # 1e+40 -> 1 * 10의 40승과 동일한 결과


# <실습> 관계연산자 
# (1) 동등비교 
boolean <- num1 == num2 # 두 변수의 값이 같은지 비교
boolean # FALSE
boolean <- num1 != num2 # 두 변수의 값이 다른지 비교
boolean # TRUE

# (2) 크기비교 
boolean <- num1 > num2 # num1값이 큰지 비교
boolean # TRUE
boolean <- num1 >= num2 # num1값이 크거나 같은지 비교 
boolean # TRUE
boolean <- num1 < num2 # num2 이 큰지 비교
boolean # FALSE
boolean <- num1 <= num2 # num2 이 크거나 같은지 비교
boolean # FALSE

# <실습> 논리연산자(and, or, not, xor)
logical <- num1 >= 50 & num2 <=10 # 두 관계식이 같은지 판단 
logical # FALSE
logical <- num1 >= 50 | num2 <=10 # 두 관계식 중 하나라도 같은지 판단
logical # TRUE

logical <- num1 >= 50 # 관계식 판단
logical # TRUE
logical <- !(num1 >= 50) # 괄호 안의 관계식 판단 결과에 대한 부정
logical # FALSE

x <- TRUE; y <- FALSE
xor(x,y) # [1] TRUE
x <- TRUE; y <- TRUE
xor(x,y) # FALSE

# (1) if("조건식"){}

x <- 10
y <- 5
z <- x * y
z # 50

if(z >= 50){
  print("z는 50이상이다.")
} else{
  print("z는 50미만이다.")
}

# 학점 구하기
score <- scan() # 키보드 입력
score

grade <- "" # 등급 변수 선언
if(score >= 90){
  grade <- "A학점"
} else if(score >= 80){
  grade <- "B학점"
} else if(score >= 70){
  grade <- "C학점"
} else{
  grade <- "F학점"
}

cat("점수 :", score,"등급 :", grade )

# 배수 구하기
10 / 2 # 5
10 %% 2 # 0
10 %% 3 # 1

# 키보드 입력 숫자가 5의 배수인지 판별하시오.
num <- scan()

if(num %% 5 == 0){
  print("5의 배수입니다.")
} else{
  print("5의 배수가 아닙니다.")
}


# 2) ifelse() : if + else
# 형식) ifelse(조건식, 참, 거짓) - 3항 연산자
# vector(n) -> 처리 -> vector(n)

score <- c(90, 65, 70, NA, 59)

ifelse(score >= 70, "합격", "불합격")
# [1] "합격"   "불합격" "합격"   "합격"   "불합격"

# 결측치 처리 : NA -> 0
result2 <- ifelse(is.na(score), 0, score)
result2
sum(result2)


# 3) which() : 조건에 해당하는 위치(index) 반환
x <- seq(1, 10, 3)
y <- c(1,2,3,4,5,6,1,2)
x # [1]  1  4  7 10

which(x == 7) # 3
which(y == 1) # 1, 7

# 행렬구조 위치 반환
emp <- read.csv("c:/dev/Rwork/data/emp.csv")
emp
class(emp) # data.frame -> 행렬

idx <- which(emp$name == "유관순") # 4

# subset example
emp_sub <- emp[idx, ]
emp_sub

# 변수 선택 example
library("MASS")
data("Boston")
str(Boston)
# 'data.frame':	506 obs. of  14 variables:
# 1~13 : x변수(독립변수)
# medv : y변수(종속변수), 주택가격

# 칼럼 가져오기
cols <- names(Boston)
cols

idx <- which(cols == "medv")
idx # 14

y <- Boston[,idx]
x <- Boston[,-idx] # 14제외하고 나머지

y # vector
dim(x) # [1] 506  13 : data.frame


# 2. 반복문

# 1) for(변수 in 값){반복문}
x <- rnorm(n = 10, mean = 0, sd = 1)
x
length(x) # 10
y <- 0
idx <- 1 # index
for(v in x){
  cat("v=",v, "\n")
  y[idx] <- v^2 # vector 저장
  idx <- idx + 1
}
y

# for문안에 여러문장일 경우 {}brace로 묶는다.
i <- 1:10
for(v in i){
  # 한줄일 경우 brace없어도 된다.
  if(v %% 2 == 0)
    print(v)
}

# 키보드 입력 -> 홀수 출력하기
num <- scan()
num # vector(7)

for(var in num){
  if(var %% 2 != 0)
    print(var)
}

# 1~100까지 홀수의 합과 짝수의 합 출력하기
even <- 0
odd <- 0
num <- 1:100
num

for(v in num){
  if(v%%2 == 0){
    even <- even + v
  } else {
    odd <- odd + v
  }
}
cat("짝수 합 =", even, "홀수 합=", odd)

setwd("c:/dev/Rwork/data")
st <- read.table("student.txt")

colnames(st) <- c("sid", "name", "height", "weight")
st

height2 <- ifelse(st$height >= 180, "high", "low")
weight2 <- ifelse(st$weight >= 65, "fat", "not fat")
st$height2 <- height2
st$weight2 <- weight2
st


# (2) while(조건식){반복문}
i = 0 # initialization
while(i < 10){
  print(i)
  i <- i + 1
}

# while + index : x의 각 변량에 제곱
x <- c(2, 5, 8, 6, 9)
x

y <- 0 # y = x^2
i <- 0
while(i < length(x)){
  i <- i + 1
  y[i] <- x[i]^2 # y[1]부터 시작(r은 index 첫번째 값이 0이아니라 1) 
}
y

# chap03_FileIO

# 1. 파일 자료 읽기

setwd("C:/dev/Rwork/data")

# (1) read.table() : 칼럼 구분자(공백, 특수문자)

# - 칼럼명이 없는 경우
student <- read.table("student.txt") # header=FALSE, sep="" <= default
student
#  V1   V2  V3 V4 칼럼명이 없는 경우 이런식으로 자동으로 이름 매겨줌
# 기본 칼럼명

# - 칼럼명이 있는 경우
student1 <- read.table("student1.txt", header = TRUE)
# 칼럼명이 있는 경우 header =TRUE로 해줘야 한다.
student1
class(student1) # data.frame

# - 칼럼명이 있는데 컬럼 구분자가 특수문자인 경우
# 특수문자(:, ;, ::)
student2 <- read.table("student2.txt", header = TRUE, sep = ";") 
student2


# (2) read.csv() : 칼럼 구분자가 콤마(,) / comma separated value
bmi <- read.csv("bmi.csv") # 문자형 -> factor로 읽어온다.
bmi
str(bmi)
# 'data.frame':	20000 obs. of  3 variables:
# $ height: int  184 189 183 143 187 161 186 144 184 165 ...
# $ weight: int  61 56 79 40 66 52 54 57 55 76 ...
# $ label : Factor w/ 3 levels "fat","normal",..: 3 3 2 2 2 2 3 1 3 1 ...

h <- bmi$height # 숫자형이기에 계산이 가능
mean(h)
w <- bmi$weight
mean(w)
# 범주형 빈도를 볼 때
table(bmi$label)

# 문자형 -> 문자형 그대로 읽어올 때
bmi2 <- read.csv("bmi.csv", stringsAsFactors = FALSE)
str(bmi2) # Factor에서 chr로 바뀜
# $ label : chr  "thin" "thin" "normal" "normal" ...


# 파일 탐색기 이용
test <- read.csv(file.choose()) # test.csv
test


# (3) read.xlsx() : 별도의 패키지 설치해야 한다.
install.packages("xlsx")
library(xlsx)

kospi <- read.xlsx("../sam_kospi.xlsx", sheetIndex = 1) #
kospi
head(kospi)


# 한글 엑셀 파일 읽기 : encoding 방식
st_excel <- read.xlsx("studentexcel.xlsx", sheetIndex = 1, encoding = "UTF-8")
st_excel

# 데이터 셋 제공 사이트 
# http://www.public.iastate.edu/~hofmann/data_in_r_sortable.html - Datasets in R packages
# https://vincentarelbundock.github.io/Rdatasets/datasets.html
# https://r-dir.com/reference/datasets.html - Dataset site
# http://www.rdatamining.com/resources/data

# (4) 인터넷 파일 읽기
# 가끔 https가 안될 때도 있다.
titanic <- read.csv("http://vincentarelbundock.github.io/Rdatasets/csv/COUNT/titanic.csv")
str(titanic)
# 성별 빈도수
table(titanic$sex)
# man women 
# 869   447 

# 생존여부 빈도수
table(titanic$survived)
# no yes 
# 817 499 

# 교차분할표 : 2개 범주형(행, 열)
# 성별에 따른 생존여부
tab <- table(titanic$sex, titanic$survived)
tab

# 막대차트
barplot(tab, col = rainbow(2), main="생존여부")



# 2. 파일 자료 저장

# 1) 화면 출력
a <- 10
b <- 20
c <- a * b
c
cat('c=', c)

# 2) 파일 저장
# read.csv <-> write.csv
# read.xlsx <-> write.xlsx

getwd()
setwd("c:/dev/Rwork/data/output")

# (1) write.csv() : 콤마구분
str(titanic)
# 'data.frame':	1316 obs. of  5 variables:

# titanic[-1] : 1칼럼 제외
# 따옴표 제거, 행번호 제거
write.csv(titanic[-1], "titanic.csv", quote = F, row.names = F)

titan <- read.csv("titanic.csv")
head(titan)

# (2) write.xlsx() : 엑셀 파일 저장
library(xlsx)
write.xlsx(kospi, "kospi.xlsx", sheetName="sheet1", row.names = F)


#################################
## <제4장 연습문제>
#################################   
# 01. 다음 3개의 vector 데이터를 이용하여 데이터프레임을 만들고, 처리하시오.

# vector 준비 
name <-c("유관순","홍길동","이순신","신사임당")
gender <- c("F","M","M","F")
price <-c(50,65,45,75)

client <- data.frame(name, gender, price)

# 단계1) client의 price 칼럼값이 70만원 이상인 고객은 "Best" 
# 70만원 미만이면 "Normal" 문자열로 분류하여 client에 새로운 컬럼(result)으로 추가하기
result <- ifelse(client$price >= 70, "Best", ifelse(client$price >= 50, "Normal", "Worst"))
result

client$result <- result # 칼럼 추가

# 단계2) gender가 'M'이면 "Male", 'F'이면 "Female" 형식으로 client에 gender2 컬럼으로 추가하기
gender2 <- ifelse(client$gender == 'M', "Male", "Female")
client$gender2 <- gender2
client

# 단계3) 새로 추가한 result 칼럼의 빈도수 구하기
# 힌트) 빈도수 구하기 : table() 함수 이용 
table(client$result)

# 02. sam_kospi.csv 데이터셋을 대상으로 다음과 같은 단계로 처리하시오.

# dataset 가져오기 
kospi <- read.csv(file.choose()) # sam_kospi.csv
str(kospi)

# 단계1) 시가(Open)와 종가(Close)의 차(diff) 구하기 
# diff = Open - Close 
diff <- kospi$Open - kospi$Close
# 단계2) 차(diff)를 칼럼으로 추가하기 
kospi$diff <- diff


# 단계3) 차(diff) 칼럼이 0보다 크면 '▲', 아니면 '▽'으로 분류하여 Status 칼럼으로 추가하기 
kospi$status <- ifelse(diff > 0, '▲', ifelse(diff < 0, '▽', '-'))
kospi

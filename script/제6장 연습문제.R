#################################
## <제6장 연습문제>
################################# 

# 01.  iris 데이터 셋을 대상으로 다음 조건에 맞게 시각화 하시오.

# 조건1) 1번 컬럼 x축, 3번 컬럼 y축으로 차트 작성(힌트 : plot(x, y)
str(iris)
plot(iris$Sepal.Length, iris$Petal.Length)
# 조건2) 5번 컬럼으로 색상 지정(힌트 : plot(x, y, col=컬럼)
plot(iris$Sepal.Length, iris$Petal.Length, col=iris$Species)

# 조건3) "iris 데이터 테이블 산포도 차트" 제목 추가(힌트 : title("차트 제목")
plot(iris$Sepal.Length, 
     iris$Petal.Length, 
     col=iris$Species, 
     title("iris 데이터 테이블 산포도 차트"))

# 02. 다음과 같은 단계별로 히스토그램 시각화하시오.
#  단계1) 표준정규분포를 따르는 난수 1,000개 생성(힌트 : rnorm() 함수 이용) 
#  단계2) 히스토그램 시각화(각 계급의 밀도) 
#  단계3) 정규성 유무 확인 

random <- rnorm(1000, 0, 1)
hist(random, freq = F)
shapiro.test(random) # p-value = 0.4483 < a : H0기각(정규성X)
#################################
## <제3장 연습문제>
#################################   

# 01. R에서 제공하는 quakes 데이터셋을 대상으로 다음과 같이 파일로 저장하고 읽어오시오.

data("quakes")
quakes # 지진 진앙지 데이터 셋 
str(quakes)
# 'data.frame':	1000 obs. of  5 variables:
# $ lat(위도)  : num  -20.4 -20.6 -26 -18 -20.4 ...
# $ long(경도) : num  182 181 184 182 182 ...
# $ depth(수심): int  562 650 42 626 649 195 82 194 211 622 ...
# $ mag(리히터규모)  : num  4.8 4.2 5.4 4.1 4 4 4.8 4.4 4.7 4.3 ...
# $ stations(관측소) : int  41 15 43 19 11 12 43 15 35 19 ...

# 단계1) output 경로에 파일명("quakes_df.csv")으로 행번호와 quote 없이 저장하기  
write.csv(quakes, file = "quakes_df.csv", quote = F, row.names = F)

# 단계2) quakes_data 변수로 파일 읽어오기  


# 02. quakes 데이터셋의 mag 변수를 대상으로 평균을 계산하여 다음과 같이 출력하시오.
# <출력 결과> 
# mag 평균 =  4.6204


#.패키지 설치 및 구동
library(dplyr)
library(ggplot2)

install.packages("foreign")
library(foreign)

#.데이터 불러오기
mental <- read.spss("KIPA_DATA_2022.SAV")
class(mental)#.객체유형 확인: list
mental <- as.data.frame(mental)#.데이터프레임으로 변환
class(mental)#.객체유형 확인: data.frame

#.변수 추출 후 이름 변경
mental <-mental %>%
  select(q32_2,q1_4,q32_1,q34_1,q55,d17,d1,d2,ara)%>%
  rename(suicide=q32_2,
         satisfaction=q1_4,
         loneliness=q32_1,
         family_belief=q34_1,
         wealth=q55,
         health=d17,
         sex=d1,
         age=d2,
         area=ara)

#.변수 유형 및 빈도 확인
str(mental)

table(mental$suicide)
table(mental$health)
table(mental$wealth)
table(mental$satisfaction)

#.6개 변수간 관계분석을 위한 유형 변경
mental$suicide <-as.integer(mental$suicide)
mental$satisfaction <-as.integer(mental$satisfaction)
mental$loneliness <-as.integer(mental$loneliness)
mental$family_belief <-as.integer(mental$family_belief)
mental$wealth <-as.integer(mental$wealth)
mental$health <-as.integer(mental$health)

#.변수 빈도 확인
table(mental$suicide)
table(mental$health)
table(mental$wealth)
table(mental$satisfaction)

#.변수 정리
mental$satisfaction<-mental$satisfaction-1
mental$wealth<-mental$wealth-1

table(mental$wealth)
table(mental$satisfaction)

#.범주형변수를 문자형으로 변경:오류방지
mental$age<-as.character(mental$age)
mental$sex<-as.character(mental$sex)
mental$area<-as.character(mental$area)

table(mental$sex)
table(mental$age)
table(mental$area)

mental$age<-ifelse(mental$age=="19~29세","20대",mental$age)
table(mental$age)

#.결측치와 이상치 확인
summary(mental)

#.데이터 분석 1.빈도분석
#.성별빈도분석
mental%>%
  group_by(sex)%>%
  summarise(n=n())%>% #sex변수의 범주별 빈도 계산
  mutate(total=sum(n), #sex변수의 빈도 총계
         pct=round(n/total*100,1)) #sex변수의 범주별 비율

#.연령대별빈도분석
mental%>%
  group_by(age)%>%
  summarise(n=n())%>% #age변수의 범주별 빈도 계산
  mutate(total=sum(n), #age변수의 빈도 총계
         pct=round(n/total*100,1)) #age변수의 범주별 비율

#.교차분석
table(mental$sex, mental$age)
round(prop.table(table(mental$sex, mental$age),1)*100,1)#교차백분율계산
chisq.test(mental$sex, mental$age)

#.평균분석
mental%>%
  summarise(m1=mean(suicide),m2=mean(satisfaction),
            m3=mean(loneliness),m4=mean(family_belief),
            m5=mean(wealth),m6=mean(health))

#.회귀분석:삶의 만족도와 외로움이 자살충동에 미치는 영향
RA <-lm(data=mental, suicide~satisfaction+loneliness)
summary(RA)

#.상관분석:삶의 만족도와 외로움의 상관관계
cor.test(mental$satisfaction,mental$loneliness)

#.회귀분석:가족신뢰도, 경제안정도, 건강상태가 삶의 만족도에 미치는 영향
install.packages("ztable")
library(ztable)
RA <-lm(data=mental, satisfaction~family_belief+wealth+health)
summary(RA)
options(ztable.type="viewer")
ztable(RA)

#.회귀분석:가족신뢰도, 경제안정도, 건강상태가 외로움에 미치는 영향
RA <-lm(data=mental, loneliness~family_belief+wealth+health)
summary(RA)
options(ztable.type="viewer")
ztable(RA)

#.독립표본t검정:성별 삶의 만족도 차이
t.test(data=mental, satisfaction~sex)

#.연령대별 삶의 만족도 차이
mental%>%
  group_by(age)%>%
  summarise(m=mean(satisfaction))%>%
  arrange(desc(m))

install.packages("ggplot2")
#.지역별 삶의 만족도 분석과 그래프 작성
area_satisfaction <-mental%>%
  group_by(area) %>%
  summarise(m=mean(satisfaction)) %>%
  arrange(desc(m))

ggplot(data=area_satisfaction, aes(x=reorder(area,m),y=m))+
  geom_col()+
  ggtitle("지역별 만족도")+
  xlab("지역")+
  ylab("만족도")+
  coord_flip()
#실습에 필요한 packages를 라이브러리에 등록
library(dplyr)
library(ggplot2)

#CSV형식의 파일 불러와서 subway객체에 입력하고 구조 확인
str(congestion)

#변수의이상치와결측치확인하고처리
summary(congestion)

#결측치개수확인
is.na(congestion)
sum(is.na(congestion))
colSums(is.na(congestion))

#결측치가있는행을제거한새로운데이터프레임생성
#6시출발기차의결측치를제거
congestion1 <-congestion[!is.na(congestion$s0600),]
colSums(is.na(congestion1))

#23시30분출발기차의결측치를제거
congestion1 <-congestion1[!is.na(congestion1$s2330),]
colSums(is.na(congestion1))

#남은결측치를0으로대체
congestion1[is.na(congestion1)] <-0
colSums(is.na(congestion1))

#이상치확인
ggplot(congestion1, aes(y=s0530))+  
  geom_boxplot()

summary(congestion1$s0530)

#수도권 지하철 혼잡도를분석
#1.지하철역의 하루 평균 혼잡도
congestion1$day_mean <-
  rowMeans(congestion1[,c('s0530','s0600','s0630','s0700','s0730','s0800','s0830','s0900','s0930','s1000','s1030','s1100','s1130','s1200','s1230','s1300','s1330','s1400','s1430','s1500','s1530','s1600','s1630','s1700','s1730','s1800','s1830','s1900','s1930','s2000','s2030','s2100','s2130','s2200','s2230','s2300','s2330')])

mean(congestion1$day_mean)

#2.지하철 호선별 하루 평균 혼잡도
passenger10 <-congestion1 %>%
  group_by(line)%>%
  summarise(m=mean(day_mean))%>%
  arrange(desc(m))%>%
  head(10)

head(passenger10,10)

#3.지하철 호선별 출근시간(07:00~09:00)대의 평균혼잡도
#3-1.지하철 호선별 7시의 평균혼잡도
passenger10 <-congestion1 %>%
  group_by(line)%>%
  summarise(m=mean(s0700))%>%
  arrange(desc(m))%>%
  head(8)

head(passenger10, 8)

ggplot(data=passenger10, aes(x=reorder(line, m), y=m))+
  geom_col()+
  coord_flip()

#3-2.지하철 호선별 7시30의 평균혼잡도
passenger10 <-congestion1 %>%
  group_by(line)%>%
  summarise(m=mean(s0730))%>%
  arrange(desc(m))%>%
  head(8)
head(passenger10, 8)

ggplot(data=passenger10, aes(x=reorder(line, m), y=m))+
  geom_col()+
  coord_flip()

#3-3.지하철 호선별 8시의 평균혼잡도
passenger10 <-congestion1 %>%
  group_by(line)%>%
  summarise(m=mean(s0800))%>%
  arrange(desc(m))%>%
  head(8)
head(passenger10, 8)

ggplot(data=passenger10, aes(x=reorder(line, m), y=m))+
  geom_col()+
  coord_flip()

#3-4.지하철 호선별 8시30의 평균혼잡도
passenger10 <-congestion1 %>%
  group_by(line)%>%
  summarise(m=mean(s0830))%>%
  arrange(desc(m))%>%
  head(8)
head(passenger10, 8)

ggplot(data=passenger10, aes(x=reorder(line, m), y=m))+
  geom_col()+
  coord_flip()

#3-5.상위 4개 호선의 역별 기여도
congestion1%>%
  group_by(line) %>%  
  summarise(total=sum(s0700, s0730, s0800, s0830)) %>%
  arrange(desc(total)) %>%
  head(4)

#4.출발시간 08시의 지하철 혼잡도 범주화/범주별 빈도분석
#4-1.08시 지하철 혼잡도 범주화/범주별 빈도분석
congestion1 %>%  
mutate(s80_grade=ifelse(s0800<=80, "good", ifelse(s0800<=130, "normal", ifelse(s0800<=150, "caution", "bad"))))%>%
  group_by(s80_grade) %>% 
  summarise(n=n())%>%  
  mutate(total=sum(n), pct=round(n/total*100,1))%>%  
  select(s80_grade,n,pct)%>%  
  arrange(desc(n))

#4-2.호선별로 08시 지하철 혼잡도 범주화
congestion1 %>%  
  mutate(s80_grade=ifelse(s0800<=80, "good", ifelse(s0800<=130, "normal", ifelse(s0800<=150, "caution", "bad"))))%>%
  group_by(line, s80_grade) %>% 
  summarise(n=n())%>%  
  mutate(total=sum(n), pct=round(n/total*100,1))%>%  
  filter(s80_grade=="caution")%>%  
  select(line, s80_grade,n,pct)%>%  
  arrange(desc(pct))%>%  
  head(5)

#5.지하철 호선별 퇴근시간(18:00~20:00)대의 평균혼잡도
#5-1.지하철 호선별 18시의 평균혼잡도
passenger10 <-congestion1 %>%
  group_by(line)%>%
  summarise(m=mean(s1800))%>%
  arrange(desc(m))%>%
  head(8)
head(passenger10, 8)

ggplot(data=passenger10, aes(x=reorder(line, m), y=m))+
  geom_col()+
  coord_flip()

#5-2.지하철 호선별 18시30의 평균혼잡도
passenger10 <-congestion1 %>%
  group_by(line)%>%
  summarise(m=mean(s1830))%>%
  arrange(desc(m))%>%
  head(8)
head(passenger10, 8)

ggplot(data=passenger10, aes(x=reorder(line, m), y=m))+
  geom_col()+
  coord_flip()

#5-3.지하철 호선별 19시의 평균혼잡도
passenger10 <-congestion1 %>%
  group_by(line)%>%
  summarise(m=mean(s1900))%>%
  arrange(desc(m))%>%
  head(8)
head(passenger10, 8)

ggplot(data=passenger10, aes(x=reorder(line, m), y=m))+
  geom_col()+
  coord_flip()

#5-4.지하철 호선별 19시30의 평균혼잡도
passenger10 <-congestion1 %>%
  group_by(line)%>%
  summarise(m=mean(s1930))%>%
  arrange(desc(m))%>%
  head(8)
head(passenger10, 8)

ggplot(data=passenger10, aes(x=reorder(line, m), y=m))+
  geom_col()+
  coord_flip()

#5-5평균혼잡도 상위 4개 호선의 역별 기여도
congestion1%>%
  group_by(line) %>%  
  summarise(total=sum(s1800, s1830, s1900, s1930)) %>%
  arrange(desc(total)) %>%
  head(4)

#6.출발시간 18시의 지하철 혼잡도 범주화/범주별 빈도분석
#6-1.18시 지하철 혼잡도 범주화/범주별 빈도분석
congestion1 %>%  
  mutate(s80_grade=ifelse(s1800<=80, "good", ifelse(s1800<=130, "normal", ifelse(s1800<=150, "caution", "bad"))))%>%
  group_by(s80_grade) %>% 
  summarise(n=n())%>%  
  mutate(total=sum(n), pct=round(n/total*100,1))%>%  
  select(s80_grade,n,pct)%>%  
  arrange(desc(n))

#6-2.호선별로 18시 지하철 혼잡도 범주화
congestion1 %>% 
  mutate(s80_grade=ifelse(s1800<=80, "good", ifelse(s1800<=130, "normal", ifelse(s1800<=150, "caution", "bad"))))%>% 
  group_by(line, s80_grade) %>% 
  summarise(n=n())%>% 
  mutate(total=sum(n), pct=round(n/total*100,1))%>% 
  filter(s80_grade=="bad")%>% 
  select(line, s80_grade,n,pct)%>% 
  arrange(desc(pct))%>% 
  head(5)
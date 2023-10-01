#table()함수/구분 1개의 인자를 가지고 도수분포표 작성
table(X2023_STB_survey $성별)

#상대도수 계산
ECN <- table(X2023_STB_survey $성별)
prop.table(ECN)

#table()함수/2개의 인자를 가지고 교차표를 작성
table(X2023_STB_survey $성별, X2023_STB_survey $학년)

#막대그래프
barplot(table(X2023_STB_survey $국적))

barplot(table(X2023_STB_survey $주택가),horiz=TRUE)

entry <- table(X2023_STB_survey $성별, X2023_STB_survey $학년)
barplot(entry, legend = TRUE)

#파이차트
pie(table(X2023_STB_survey $학년))

#히스토그램
hist(X2023_STB_survey$`연세`, main="2023년 경영통계분석2를 수강하는 수강생들의 연세",col=terrain.colors(12))

#박스 플롯
boxplot(X2023_STB_survey$`학년`, X2023_STB_survey$`연세`,main="학년별 연세에 대한 기술통계분석", col="yellow", names =c("학년","연세"))

#삱점도
plot(x=X2023_STB_survey$`학년`,  y=X2023_STB_survey$`연세`,  xlab="학년", ylab="연세", main="학년와 연세의 변화")

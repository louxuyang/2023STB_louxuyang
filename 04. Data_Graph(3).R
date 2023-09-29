#table()함수/구분 1개의 인자를 가지고 도수분포표 작성
table(X2023_STB_survey $Gender)

#상대도수 계산
ECN <- table(X2023_STB_survey $Gender)
prop.table(ECN)

#table()함수/2개의 인자를 가지고 교차표를 작성
table(X2023_STB_survey $Gender, X2023_STB_survey $Grade)

#막대그래프
barplot(table(X2023_STB_survey $Nationality))

barplot(table(X2023_STB_survey $주택가),horiz=TRUE)

entry <- table(X2023_STB_survey $Gender, X2023_STB_survey $Grade)
barplot(entry, legend = TRUE)

#파이차트
pie(table(X2023_STB_survey $Grade))

#히스토그램
hist(X2023_STB_survey$`Age`, main="2023년 경영통계분석2를 수강하는 수강생들의 나이",col=terrain.colors(12))

#박스 플롯
boxplot(X2023_STB_survey$`Grade`, X2023_STB_survey$`Age`,main="Grade별 Age에 대한 기술통계분석", col="yellow", names =c("Grade","Age"))

#삱점도
plot(x=X2023_STB_survey$`Grade`,  y=X2023_STB_survey$`Age`,  xlab="Grade", ylab="Age", main="Gread와 Age의 변화")

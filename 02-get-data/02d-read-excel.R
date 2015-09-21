
install.packages("xlsx")
library(xlsx)

dt<-read.xlsx(file = "../00-fitbit-demo/fitbit-data.xlsx",sheetIndex = 1)

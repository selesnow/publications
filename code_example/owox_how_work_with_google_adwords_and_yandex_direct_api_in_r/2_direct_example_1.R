#Подключаем пакет
library("ryandexdirect")

#Получаем токен разработчика
tok <- yadirGetToken()

#Вводим переменную содержащую логин пользователя. Замените MYLOGIN на ваш логин в Яндексе
my_login <- “MYLOGIN”

#Запрашиваем статистику
data <- yadirGetReport(ReportType = "CAMPAIGN_PERFORMANCE_REPORT", 
                       DateRangeType = "LAST_30_DAYS", 
                       FieldNames = c("Date",
                                      "CampaignName",
                                      "CampaignId",
                                      "Impressions",
                                      "Clicks",
                                      "Cost"), 
                       Login = my_login, 
                       Token = tok )

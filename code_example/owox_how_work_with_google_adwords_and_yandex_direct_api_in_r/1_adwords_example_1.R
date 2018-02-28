#Подключение пакета
library(RAdwords)

#Аутентификация
adwords_auth <- doAuth()
account_id   <- "000-000-0000" #ID вашего рекламного аккаунта AdWords

#Подготовка запроса
#Берём данные за предыдущие 30 дней
#Функция format.Date преобзаует дату из стандартного формата 2017-01-01 в 20170101
body <- statement(select=c('Date',
                           'CampaignName',
                           'CampaignId',
                           'AccountCurrencyCode',
                           'Impressions',
                           'VideoViews',
                           'Clicks',
                           'Interactions',
                           'AllConversions',
                           'Cost'),
                  report="CAMPAIGN_PERFORMANCE_REPORT",
                  start=format.Date(Sys.Date() - 31, "%Y%m%d"),
                  end=format.Date(Sys.Date() - 1, "%Y%m%d"))

#Запрашиваем данные
AdwData <- getData(clientCustomerId = account_id,
                   google_auth = adwords_auth,
                   statement = body,
                   transformation = T)

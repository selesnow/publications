# ###############################################
# RAdwords
# ###############################################
devtools::install_github("jburkhardt/RAdwords" ) # Установка пакета
library(RAdwords)                                # Подключаем пакет
setwd("C:/matemarketing")                        # устанавливаем новую рабочую директорию

# Выбор отчёта
reports()

# Выбор полей
metrics(report = "ACCOUNT_PERFORMANCE_REPORT")

# авторизация
browseURL("https://console.cloud.google.com") # настройка Google Cloud Console
browseURL("https://ads.google.com/")           # управляющий аккаунт Google Ads
adw_auth <- doAuth(save = TRUE)               # авторизация

# формирование простого отчёта
simple_body <- statement(report = "CAMPAIGN_PERFORMANCE_REPORT", 
                         select = c("CampaignId",
                                    "CampaignStatus", 
                                    "StartDate",
                                    "Date",
                                    "Clicks",
                                    "Cost"),
                         start  = "2018-09-01",
                         end    = "2018-09-30")

# отправка запроса
simple_data <- getData(clientCustomerId = "957-328-7481",
                       google_auth      = adw_auth,
                       statement        = simple_body)

# получить полный список объектов, даже если по ним не было показов
kw_body <- simple_body <- statement(report = "CRITERIA_PERFORMANCE_REPORT", 
                                    select = c("Id",
                                               "Criteria", 
                                               "CriteriaType",
                                               "DisplayName",
                                               "CpcBid",
                                               "QualityScore"))

# отправка запроса
keywords <- getData(clientCustomerId = "957-328-7481",
                    google_auth      = adw_auth,
                    statement        = kw_body,
                    includeZeroImpressions = TRUE)

# исправляем проблему с кодировкой
keywords$`Keyword/Placement` <- iconv(keywords$`Keyword/Placement`, from = "UTF-8", to = "1251") 
keywords$`Keyword/Placement` <- iconv(keywords$`Keyword/Placement`, from = "UTF-8", to = "1251") 
keywords$CriteriaDisplayName <- iconv(keywords$CriteriaDisplayName, from = "UTF-8", to = "1251") 
keywords$CriteriaDisplayName <- iconv(keywords$CriteriaDisplayName, from = "UTF-8", to = "1251") 

# ###############################################
# adwordsR
# ###############################################
install.packages("adwordsR") # установка
library(adwordsR)            # подключение

# авторизация
my_adw_token <- generateAdwordsToken(addGitignore = FALSE) # авторизация
my_adw_token <- loadAdwordsToken()                         # загрузка токена

# простой запрос
simple_data2 <- getReportData(reportType        = "CAMPAIGN_PERFORMANCE_REPORT",
                              attributes        = c("CampaignId",
                                                    "CampaignStatus", 
                                                    "StartDate"),
                              segment           = c("Date"),
                              metrics           = c("Clicks",
                                                    "Cost"),
                              startDate         = "2018-09-01",
                              endDate           = "2018-09-30",
                              clientCustomerId  = "957-328-7481",
                              credentials       = my_adw_token)

# преобразуем денежные данные
simple_data2$Cost <- simple_data2$Cost / 1000000

# список ключевых слов
keywords2 <- getReportData(reportType        = "CRITERIA_PERFORMANCE_REPORT",
                           attributes        = c("Id",
                                                 "Criteria", 
                                                 "CriteriaType",
                                                 "DisplayName",
                                                 "CpcBid",
                                                 "QualityScore"),
                           startDate         = "2018-09-01",
                           endDate           = "2018-09-30",
                           clientCustomerId  = "957-328-7481",
                           includeZeroImpressions = TRUE,
                           credentials       = my_adw_token)

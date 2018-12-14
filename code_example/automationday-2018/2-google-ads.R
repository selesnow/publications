# ###############################################
# RAdwords
# ###############################################

devtools::install_github("jburkhardt/RAdwords" ) # Установка пакета
library(RAdwords)                                # Подключаем пакет
setwd("C:\\webinars\\automationday-2018")        # устанавливаем новую рабочую директорию

# Выбор отчёта
reports()

# Выбор полей
metrics(report = "ACCOUNT_PERFORMANCE_REPORT")

# авторизация
browseURL("https://console.cloud.google.com") # настройка Google Cloud Console
browseURL("https://ads.google.com/")          # управляющий аккаунт Google Ads
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

# Установка пакетов
install.packages("devtools")
devtools::install_github("selesnow/ryandexdirect")

# Подключение пакета
library(ryandexdirect)

# Переходим в рабочую директорию
getwd()                   # текущая директория
setwd("C:/matemarketing") # устанавливаем новую рабочую директорию
getwd()                   # текущая директория

# Авторизация 
invisible(
    # ===============================================
    yadirAuth(Login     = "netpeak.vyacheslav", 
              TokenPath = "C:/matemarketing/tokens")
    # ===============================================
)

# просмотр списка приложений которым вы предоставили доступ
browseURL("https://passport.yandex.ru/profile/access")

# ###################################################
# Загрузка различных объектов из рекламного аккаунта
# ###################################################

# Список рекламных кампаний
camp <- yadirGetCampaignList(Logins = "netpeak.vyacheslav",
                             TokenPath = "C:/matemarketing/tokens",
                             States = "ON",
                             Types  = "TEXT_CAMPAIGN")

# Список ключевых слов
kw <- yadirGetKeyWords(Login       = "netpeak.vyacheslav",
                       TokenPath   = "C:/matemarketing/tokens",
                       CampaignIds = camp$Id[c(1,2)],
                       States      = "ON")

# Список групп объявлений
adgroups <- yadirGetAdGroups(Login       = "netpeak.vyacheslav",
                             TokenPath   = "C:/matemarketing/tokens",
                             CampaignIds = camp$Id[c(1,2)],
                             Types       = "TEXT_AD_GROUP",
                             Statuses    = c("ACCEPTED", "MODERATION"))

# Список объявлений
ads <- yadirGetAds(Login       = "netpeak.vyacheslav",
                   TokenPath   = "C:/matemarketing/tokens",
                   CampaignIds = camp$Id[c(1,2)])

# Список быстрых ссылок 
links <- yadirGetSiteLinks(Login       = "netpeak.vyacheslav",
                           TokenPath   = "C:/matemarketing/tokens")

# ###################################################
# Загрузка справочной информации
# ###################################################

# Курсы валют
currency <- yadirGetDictionary(DictionaryName = "Currencies",
                               Language       = "en",
                               Login          = "netpeak.vyacheslav",
                               TokenPath      = "C:/matemarketing/tokens")

# Георгафический справочник
regions <- yadirGetDictionary(DictionaryName = "GeoRegions",
                              Language       = "ru",
                              Login          = "netpeak.vyacheslav",
                              TokenPath      = "C:/matemarketing/tokens")

# ###################################################
# Загрузка статистики
# ###################################################

# простейший отчёт за прошлый месяц
simple_report <- yadirGetReport(DateRangeType = "LAST_MONTH",
                                FieldNames    = c("Date", "Clicks", "Impressions"),
                                Login         = "netpeak.vyacheslav",
                                TokenPath     = "C:/matemarketing/tokens")

# отчёт по конверсиям с моделью аттрибуции за статичный период
attribution_report <- yadirGetReport(DateFrom          = "2018-10-15",
                                     DateTo            = "2018-10-20",
                                     FieldNames        = c("Date", 
                                                           "Conversions"),
                                     Goals             = c(182453, 182452, 23458860),
                                     AttributionModels = c("LC", "FC"),
                                     Login             = "netpeak.vyacheslav",
                                     TokenPath         = "C:/matemarketing/tokens")

# отчёт с применением фильтрации
filtring_report <- yadirGetReport(DateRangeType = "LAST_30_DAYS",
                                  FieldNames    = c("Date", "Clicks", "Impressions"),
                                  FilterList    = c("Conversions LESS_THAN 300", 
                                                    "Impressions GREATER_THAN 15000"),
                                  Login         = "netpeak.vyacheslav",
                                  TokenPath     = "C:/matemarketing/tokens")

# ###################################################
# Управление показами
# ###################################################

on_ads <- ads[ads$State == "ON", ] # выбираем включенные объявления
ads_to_off <- on_ads[1:3, ]        # оставляем 3 которые надо выключить

# остановка покажов
yadirStopAds(Ids        = ads_to_off$Id,
             Login      = "netpeak.vyacheslav",
             TokenPath  = "C:/matemarketing/tokens")

# проверка что объявления выключены
cheking_ads_1 <- yadirGetAds(Ids        = ads_to_off$Id,
                             Login      = "netpeak.vyacheslav",
                             TokenPath  = "C:/matemarketing/tokens")

# Выводим текущий статус объявлений
message(unique(cheking_ads_1$State))

# запуск показов
yadirStartAds(Ids        = ads_to_off$Id,
              Login      = "netpeak.vyacheslav",
              TokenPath  = "C:/matemarketing/tokens")

# проверка что объявления включились
cheking_ads_2 <- yadirGetAds(Ids        = ads_to_off$Id,
                             Login      = "netpeak.vyacheslav",
                             TokenPath  = "C:/matemarketing/tokens")

# Выводим текущий статус объявлений
message(unique(cheking_ads_2$State))

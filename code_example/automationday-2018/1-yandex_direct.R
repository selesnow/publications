# ###############################################
# ryandexdirect
# ###############################################

# Установка пакетов
install.packages("devtools")
devtools::install_github("selesnow/ryandexdirect", upgrade = "never")

# Подключение пакета
library(ryandexdirect)

# Переходим в рабочую директорию
getwd()                   # текущая директория
setwd("C:/webinars/automationday-2018") # устанавливаем новую рабочую директорию
getwd()                   # текущая директория

# Авторизация 
invisible(
    # ===============================================
    yadirAuth(Login     = "irina.netpeak", 
              TokenPath = "C:/webinars/automationday-2018/tokens")
    # ===============================================
)

# просмотр списка приложений которым вы предоставили доступ
browseURL("https://passport.yandex.ru/profile/access")

# ###################################################
# Загрузка различных объектов из рекламного аккаунта
# ###################################################

# Список рекламных кампаний
camp <- yadirGetCampaignList(Logins    = "irina.netpeak",
                             TokenPath = "C:/webinars/automationday-2018/tokens",
                             States    = "ON",
                             Types     = "TEXT_CAMPAIGN")

# Список ключевых слов
kw <- yadirGetKeyWords(Login       = "irina.netpeak",
                       TokenPath   = "C:/webinars/automationday-2018/tokens",
                       CampaignIds = camp$Id[1:5],
                       States      = "ON")

# Список групп объявлений
adgroups <- yadirGetAdGroups(Login       = "irina.netpeak",
                             TokenPath   = "C:/webinars/automationday-2018/tokens",
                             CampaignIds = camp$Id[c(1,2)],
                             Types       = "TEXT_AD_GROUP",
                             Statuses    = c("ACCEPTED", "MODERATION"))

# Список объявлений
ads <- yadirGetAds(Login       = "irina.netpeak",
                   TokenPath   = "C:/webinars/automationday-2018/tokens",
                   CampaignIds = camp$Id[c(1,2)])

# Список быстрых ссылок 
links <- yadirGetSiteLinks(Login       = "irina.netpeak",
                           TokenPath   = "C:/webinars/automationday-2018/tokens")

# ###################################################
# Загрузка справочной информации
# ###################################################

# Курсы валют
currency <- yadirGetDictionary(DictionaryName = "Currencies",
                               Language       = "en",
                               Login          = "irina.netpeak",
                               TokenPath      = "C:/webinars/automationday-2018/tokens")

# Георгафический справочник
regions <- yadirGetDictionary(DictionaryName = "GeoRegions",
                              Language       = "ru",
                              Login          = "irina.netpeak",
                              TokenPath      = "C:/webinars/automationday-2018/tokens")
# получить справку по функции
?yadirGetDictionary

# ###################################################
# Загрузка статистики
# ###################################################

# простейший отчёт за прошлый месяц
simple_report <- yadirGetReport(DateRangeType = "LAST_MONTH",
                                FieldNames    = c("Date", "Clicks", "Impressions"),
                                Login         = "irina.netpeak",
                                TokenPath     = "C:/webinars/automationday-2018/tokens")

# отчёт по конверсиям с моделью аттрибуции за статичный период
attribution_report <- yadirGetReport(DateFrom          = "2018-11-15",
                                     DateTo            = "2018-11-20",
                                     FieldNames        = c("Date", 
                                                           "Conversions"),
                                     Goals             = c(27475434, 38234732),
                                     AttributionModels = c("LC", "FC"),
                                     Login             = "irina.netpeak",
                                     TokenPath         = "C:/webinars/automationday-2018/tokens")

# отчёт с применением фильтрации
filtring_report <- yadirGetReport(DateRangeType = "LAST_30_DAYS",
                                  FieldNames    = c("Date", "Clicks", "Impressions"),
                                  FilterList    = c("Conversions GREATER_THAN 1", 
                                                    "Impressions LESS_THAN 3500"),
                                  Login         = "irina.netpeak",
                                  TokenPath     = "C:/webinars/automationday-2018/tokens")


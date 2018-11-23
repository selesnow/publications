# ###############################################
# ryandexdirect
# ###############################################

# ”становка пакетов
install.packages("devtools")
devtools::install_github("selesnow/ryandexdirect", upgrade = "never")

# ѕодключение пакета
library(ryandexdirect)

# ѕереходим в рабочую директорию
getwd()                   # текуща¤ директори¤
setwd("C:/webpromo_now_2018") # устанавливаем новую рабочую директорию
getwd()                   # текуща¤ директори¤

# јвторизаци¤ 
invisible(
    # ===============================================
    yadirAuth(Login     = "irina.netpeak", 
              TokenPath = "C:/webpromo_now_2018/tokens")
    # ===============================================
)

# просмотр списка приложений которым вы предоставили доступ
browseURL("https://passport.yandex.ru/profile/access")

# ###################################################
# «агрузка различных объектов из рекламного аккаунта
# ###################################################

# —писок рекламных кампаний
camp <- yadirGetCampaignList(Logins    = "irina.netpeak",
                             TokenPath = "C:/webpromo_now_2018/tokens",
                             States    = "ON",
                             Types     = "TEXT_CAMPAIGN")

# —писок ключевых слов
kw <- yadirGetKeyWords(Login       = "irina.netpeak",
                       TokenPath   = "C:/webpromo_now_2018/tokens",
                       CampaignIds = camp$Id[1:5],
                       States      = "ON")

# —писок групп объ¤влений
adgroups <- yadirGetAdGroups(Login       = "irina.netpeak",
                             TokenPath   = "C:/webpromo_now_2018/tokens",
                             CampaignIds = camp$Id[c(1,2)],
                             Types       = "TEXT_AD_GROUP",
                             Statuses    = c("ACCEPTED", "MODERATION"))

# —писок объ¤влений
ads <- yadirGetAds(Login       = "irina.netpeak",
                   TokenPath   = "C:/webpromo_now_2018/tokens",
                   CampaignIds = camp$Id[c(1,2)])

# —писок быстрых ссылок 
links <- yadirGetSiteLinks(Login       = "irina.netpeak",
                           TokenPath   = "C:/webpromo_now_2018/tokens")

# ###################################################
# «агрузка справочной информации
# ###################################################

#  урсы валют
currency <- yadirGetDictionary(DictionaryName = "Currencies",
                               Language       = "en",
                               Login          = "irina.netpeak",
                               TokenPath      = "C:/webpromo_now_2018/tokens")

# √еоргафический справочник
regions <- yadirGetDictionary(DictionaryName = "GeoRegions",
                              Language       = "ru",
                              Login          = "irina.netpeak",
                              TokenPath      = "C:/webpromo_now_2018/tokens")
# получить справку по функции
?yadirGetDictionary

# ###################################################
# «агрузка статистики
# ###################################################

# простейший отчЄт за прошлый мес¤ц
simple_report <- yadirGetReport(DateRangeType = "LAST_MONTH",
                                FieldNames    = c("Date", "Clicks", "Impressions"),
                                Login         = "irina.netpeak",
                                TokenPath     = "C:/webpromo_now_2018/tokens")

# отчЄт по конверси¤м с моделью аттрибуции за статичный период
attribution_report <- yadirGetReport(DateFrom          = "2018-10-15",
                                     DateTo            = "2018-11-20",
                                     FieldNames        = c("Date", 
                                                           "Conversions"),
                                     Goals             = c(32211309, 30416434, 2731103, 9898),
                                     AttributionModels = c("LC", "FC"),
                                     Login             = "irina.netpeak",
                                     TokenPath         = "C:/webpromo_now_2018/tokens")

# отчЄт с применением фильтрации
filtring_report <- yadirGetReport(DateRangeType = "LAST_30_DAYS",
                                  FieldNames    = c("Date", "Clicks", "Impressions"),
                                  FilterList    = c("Conversions GREATER_THAN 1", 
                                                    "Impressions LESS_THAN 3500"),
                                  Login         = "irina.netpeak",
                                  TokenPath     = "C:/webpromo_now_2018/tokens")


# ###############################################
# RGA
# ###############################################

# Установка RGA
devtools::install_github("artemklevtsov/RGA", upgrade = "never")
library(RGA)

# Авторизация
setwd("C:\\webinars\\automationday-2018") 
r.for.marketing <- authorize(username = "r.for.marketing")
alsey.netpeak   <- authorize(username = "alsey.netpeak")

# Metadata API
fields_dictionary <- RGA::list_dimsmets()    # загрузка списка доступных полей

# Menegment API
my_ga_accounts <- RGA::list_accounts(token = r.for.marketing)       # загрузка списка аккаунтов
my_ga_profiles <- RGA::list_profiles(token = alsey.netpeak)         # загрузка списка ресурсов
my_ga_views    <- RGA::list_webproperties(token = alsey.netpeak)    # загрузка списка представлений
my_goals       <- RGA::list_goals(token = r.for.marketing)          # загрузка списка целей
my_filters     <- RGA::list_filters(accountId = 44472206, token =  r.for.marketing)   # список фильтров
my_segments    <- RGA::list_segments(token = alsey.netpeak)

# Core API
my_core_data <- RGA::get_ga(profileId     = "ga:170507937",
                            start.date    = "14daysAgo",
                            end.date      = "yesterday",
                            metrics       = "ga:users,ga:sessions,ga:bounces",
                            dimensions    = "ga:date,ga:source,ga:medium",
                            sort          = "-ga:date",
                            filters       = "ga:medium!=cpc,ga:source=@g", # "," - ИЛИ, ";" - И
                            segment       = "sessions::condition::ga:bounces>0",
                            samplingLevel = "HIGHER_PRECISION",
                            token         = r.for.marketing,
                            fetch.by      = "day") #При ga:users и ga:NdayUsers могут быть некорректными;

# операторы при фильтрации
# == - точное соответсвие
# != - Не соответствует
# =@ - содержит подстроку
# !@ - не содержит подстроку
# =~ - соответсвуе регулярному выражени
# !~ - не соответвует регулярному выражению

# Multi-Channel Funnels API
my_mcf_data <- RGA::get_mcf(profileId     = "ga:170507937",
                            start.date    = "14daysAgo",
                            end.date      = "yesterday",
                            dimensions    = "mcf:conversionDate, mcf:mediumPath",
                            metrics       = "mcf:assistedConversions",
                            token         = r.for.marketing,
                            samplingLevel =  "HIGHER_PRECISION")

# Real time reporting API
my_real_time_API <- RGA::get_realtime(profileId     = "ga:6056790",
                                      dimensions    = "rt:source, rt:medium, rt:country",
                                      metrics       = "rt:activeUsers",
                                      sort          = "-rt:activeUsers",
                                      token         = alsey.netpeak)

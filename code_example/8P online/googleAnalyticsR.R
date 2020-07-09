# googleAnalyticsR
devtools::install_github('MarkEdmondson1234/googleAnalyticsR')
library(googleAnalyticsR)

# авторизация
## создаём учётные данные в google cloud
## включаем Google Analytics API
googleAuthR::gar_set_client(json = "C:/ga_auth/app.json")

## создаём сервисный аккаунт
## авторизуемся через сервисный аккаунт
ga_auth(json_file = "C:/ga_auth/service.json")

# ###################################
# запрашиваем список представлений
accounts <- ga_account_list()

# выбираем представление 
acc_id <- 44472206
wp_id  <- 'UA-44472206-1'
ga_id  <- 77219967

# ###################################
# статистика 
## параметры и показатели
browseURL('https://ga-dev-tools.appspot.com/dimensions-metrics-explorer/')
meta <- ga_meta()

## Простой отчёт
report_1 <- google_analytics(ga_id, 
                             date_range = c("2020-01-01", "2020-01-10"), 
                             metrics    = c("sessions" , "bounces"), 
                             dimensions = c("date", "source"))

# сравнение данных за период
report_2 <- google_analytics(ga_id, 
                 date_range = c("16daysAgo", "9daysAgo", "8daysAgo", "yesterday"), 
                 dimensions = "source",
                 metrics    = "sessions")

# фильтрация данных
mf  <- met_filter("bounces", "GREATER_THAN", 0)
mf2 <- met_filter("sessions", "GREATER", 2)

df  <- dim_filter("source","BEGINS_WITH","1",not = TRUE)
df2 <- dim_filter("source","BEGINS_WITH","a",not = TRUE)

fc2 <- filter_clause_ga4(list(df, df2), operator = "AND")
fc  <- filter_clause_ga4(list(mf, mf2), operator = "AND")

report_3 <- google_analytics(
  ga_id, 
  date_range  = c("2020-04-30","2020-05-10"),
  dimensions  = c('source','medium'), 
  metrics     = c('sessions','bounces'), 
  met_filters = fc, 
  dim_filters = fc2)

# вычисляемые показатели
my_custom_metric <- c(visitPerVisitor = "ga:visits/ga:visitors")

report_4 <- google_analytics(ga_id,
                             date_range = c("2019-07-30",
                                            "2019-10-01"),
                             dimensions = c('medium'), 
                             metrics    = c(my_custom_metric,
                                           'bounces'), 
                             metricFormat = c("FLOAT","INTEGER"))


# Когортный анализ
cohort <- make_cohort_group(list("Oct2019" = c("2019-10-01", "2019-10-31"), 
                                 "Now2019" = c("2019-11-01", "2019-11-30"),
                                 "Dec2019" = c("2019-12-01", "2019-12-31")))

c_report <- 
google_analytics(ga_id, 
                 dimensions = c('cohort','ga:cohortNthMonth'), 
                 metrics    = c('cohortTotalUsers','ga:cohortActiveUsers'),
                 cohort     = cohort
)

# User Activity API, сырые данные 
cids <- google_analytics(ga_id, 
                         date_range = c("16DaysAgo","yesterday"), 
                         metrics    = "sessions", 
                         dimensions = "clientId")

users <- ga_clientid_activity(head(cids$clientId, 15),
                              ga_id, 
                              date_range = c("16DaysAgo","yesterday"))

# сырые данные
sessions <- users$sessions # сеансы
hits     <- users$hits     # хиты

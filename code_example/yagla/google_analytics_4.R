# установка пакета
install.packages('googleAnalyticsR', 'dplyr', 'tidyr', 'ggplot2')

# подключение пакета
library(googleAnalyticsR) # GA4 API
library(dplyr)            # манипуляция данными
library(tidyr)            # очистка данных
library(ggplot2)          # визуализация данных

# авторизация
googleAuthR::gar_auth_configure(path = "C:/ga_auth/oauth_app.json")
ga_auth(email = 'selesnow@gmail.com')

# запросим список ресурсов GA4
ga4_accounts <- ga_account_list("ga4")

# получить набор 
metadata <- ga_meta("data", propertyId = 282495698)
browseURL('https://developers.google.com/analytics/devguides/reporting/data/v1/api-schema')

# запрос отчётов из GA4
my_property_id <- 282495698

# простейший отчёт
basic <- ga_data(
  my_property_id,
  metrics = c("activeUsers","sessions"),
  dimensions = c("date"),
  date_range = c("2021-09-01", "yesterday")
)

# строим график
qplot(
  x      = date, 
  y      = sessions, 
  data   = basic, 
  geom   = c('line', 'point'), 
  colour = I("red"), 
  main   = "Количетсов сеансов по дням", 
  xlab   = "Дата", 
  ylab   = "Количество сеансов"
)

# отчёт по событиям
events <- ga_data(
  my_property_id,
  metrics    = c("eventCount"),
  dimensions = c("date", "eventName", "defaultChannelGrouping"),
  date_range = c("2021-09-01", "yesterday")
)

# преобразуем данные
events <- pivot_wider(
  events, 
  id_cols     = c(date, defaultChannelGrouping),
  names_from  = eventName, 
  values_from = eventCount
) %>% 
  mutate(across(where(is.numeric), replace_na, 0))

# визуализация данных
qplot(
  x      = defaultChannelGrouping, 
  y      = session_start, 
  data   = events, 
  geom   = "col", 
  main   = "Количетсов сеансов по источникам", 
  xlab   = "Группа каналов", 
  ylab   = "Количество сеансов",
  fill   = defaultChannelGrouping
)


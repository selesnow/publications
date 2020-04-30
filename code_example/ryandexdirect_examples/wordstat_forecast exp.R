#devtools::install_github('selesnow/ryandexdirect')
library(ryandexdirect)
library(dplyr)
# авторизация
#yadirAuth('selesnow')

# простой запрос
## запрашиваем простой отчёт из wordstat
s_ws_rep <- yadirGetWordStatReport(c('купить смартфон',
                                     'купить сотовый телефон',
                                     'купить мобильный'),
                                   Login = "selesnow")

## что искали со словом купить смартфон
s_ws_rep$SearchedWith

## запросы похожие на купить смартфон
s_ws_rep$SearchedAlso

# #########################################
# запрос с минус словами
minus_ws_rep <- yadirGetWordStatReport(c('купить смартфон -xiaomi', 'самсунг -(серого цвета)'),
                                       Login = "selesnow")

## что искали со словом купить смартфон
minus_ws_rep$SearchedWith

## запросы похожие на купить смартфон
minus_ws_rep$SearchedAlso

# #########################################
# запрос с минус словами
minus_ws_rep <- yadirGetWordStatReport('пух -винни',
                                       Login = "selesnow")

## что искали со словом купить смартфон
minus_ws_rep$SearchedWith

## запросы похожие на купить смартфон
minus_ws_rep$SearchedAlso

# #########################################
# Запрос с указанием регионов
regions <- yadirGetDictionary(Login = "selesnow")


plus_regions <- regions %>%
  filter(GeoRegionName %in% c("Россия"))

minus_regions <- regions %>%
                  filter(GeoRegionName %in% c("Москва",
                                              "Санкт-Петербург",
                                              "Екатеринбург",
                                              "Владивосток")) %>%
                  mutate(GeoRegionId = paste0("-", GeoRegionId))



reg_ws <- yadirGetWordStatReport(Phrases = c('купить смартфон -xiaomi', 
                                             'купить xiaomi'),
                                 GeoID   = c(plus_regions$GeoRegionId, minus_regions$GeoRegionId),
                                 Login   = "selesnow")
# посмотреть отчёты
reg_ws$SearchedWith
reg_ws$SearchedAlso

# #########################################                  
regions <- yadirGetDictionary(Login = "selesnow")


plus_regions <- regions %>%
  filter(GeoRegionName %in% c("Россия"))

minus_regions <- regions %>%
  filter(GeoRegionName %in% c("Москва",
                              "Санкт-Петербург",
                              "Екатеринбург",
                              "Владивосток")) %>%
  mutate(GeoRegionId = paste0("-", GeoRegionId))

forecast <- yadirGetForecast(Phrases = c('купить смартфон -xiaomi', 
                                         'купить xiaomi',
                                         'самсунг -(серого цвета)'),
                             GeoID   = c(plus_regions$GeoRegionId, minus_regions$GeoRegionId),
                             AuctionBids = 'Yes',
                             Login   = "selesnow")

# прогноз в разрезе ключевых фраз
forecast$PhrasesForecast

# общий прогноз
forecast$CommonForecast

# подробная виньетка
vignette('yandex-direct-keyword-bids', 'ryandexdirect')

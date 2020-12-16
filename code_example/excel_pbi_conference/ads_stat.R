# установка пакета
install.packages('rvkstat')

# подключение пакетов
library(rvkstat)
library(dplyr)
library(tidyr)

# регистрируем приложение
browseURL('https://vk.com/apps?act=manage')

# проходим авторизацию
vkauth <- vkAuth() 

# сохраняем полученные данные в файл
saveRDS(object = vkauth, "C:/vkauth/vkauth.rds")

# ####################################
# список доступных аккаунтов
accounts <- vkGetAdAccounts(vkauth$access_token)

## Получаем список рекламных кампаний
camp <- vkGetAdCampaigns(account_id   = 1600134264,
                         access_token = vkauth$access_token)

vk_stat_by_campaign <- vkGetAdStatistics(
    account_id   = 1600134264,
    ids_type     = "campaign",
    ids          = camp$id ,
    period       = "day",
    date_from    = "2010-01-01",
    date_to      = Sys.Date(),
    access_token = vkauth$access_token)


## Получаем список рекламных кампаний
ads <- vkGetAds(account_id = 1600134264, 
                access_token = vkauth$access_token) %>%
       mutate(id = as.integer(id))

## Получаем статистику по объявлениям
vk_stat_by_ads <- vkGetAdStatistics(account_id   = 1600134264,
                                    ids_type     = "ad",
                                    ids          = ads$id ,
                                    period       = "day",
                                    date_from    = "2010-01-01",
                                    date_to      = Sys.Date(),
                                    access_token = vkauth$access_token)

# объединяем данные в одну таблицу
vkdata <- left_join(vk_stat_by_ads, ads, by = 'id', suffix = c("", "_ads")) %>%
          left_join(camp, by = c('campaign_id' = 'id'), suffix = c("", "_camp")) 

# заменяем NA на нули
vkdata <- mutate(vkdata, 
                 across(where(~ is.numeric(.x) || is.integer(.x)), replace_na, 0), 
                 day = as.Date(day))

# ############################# #
# ############################# #
# Работа с агентским кабинетом  #
# ############################# #
# ############################# #

# загрузка авторизационны данных 
vkauth <- readRDS("C:/vkauth/vkauth.rds")

# получить все рекламные кабинеты
ad_accounts <- vkGetAdAccounts(vkauth$access_token)

# получить клиентов из рекламного кабинета
vkclients   <- vkGetAdClients(account_id = 1900002395, 
                              access_token = vkauth$access_token, 
                              api_version = "5.73")  

# запрашиваем данные по объявлениям
ag_ads <- vkGetAds(
                account_id   = 1900002395,
                client_id    = 1604857373,
                access_token = vkauth$access_token) %>%
       mutate(id = as.integer(id))

# запрашиваем статистику по объявлениям
ag_vk_data <- vkGetAdStatistics(account_id   = 1900002395,
                  ids_type     = "ad",
                  ids          = ag_ads$id ,
                  period       = "day",
                  date_from    = "2020-11-01",
                  date_to      = Sys.Date(),
                  access_token = vkauth$access_token)

# запрашиваем список кампаний
ag_camps <- vkGetAdCampaigns(account_id   = 1900002395,
                             client_id    = 1604857373,
                             access_token = vkauth$access_token)

# объединяем данные
# объединяем данные в одну таблицу
vkdata <- left_join(ag_vk_data, ag_ads, by = 'id', suffix = c("", "_ads")) %>%
          left_join(ag_camps, by = c('campaign_id' = 'id'), suffix = c("", "_camp")) 

# заменяем NA на нули
vkdata <- mutate(vkdata, 
                 across(where(~ is.numeric(.x) || is.integer(.x)), replace_na, 0), 
                 day = as.Date(day))

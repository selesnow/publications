# подключение пакета
library(rvkstat)
library(dplyr)
library(tidyr)

# загрузка авторизационны данных 
vkauth <- readRDS("C:/vkauth/vkauth.rds")

# получить список групп
mygroups <- vkGetUserGroups(access_token = vkauth$access_token)

# общая статистика сообщества
gr_data <- vkGetGroupStat(date_from = '2020-11-01', 
                          date_to   = Sys.Date(),
                          group_id = 119709976, 
                          access_token = vkauth$access_token ) %>%
           mutate( across( where(~ is.numeric(.x) | is.integer(.x) ), replace_na, 0 ) )

# по странам
gr_countries <- vkGetGroupStatCountries(date_from = '2020-11-01', 
                                        date_to   = Sys.Date(),
                                        group_id = 119709976, 
                                        access_token = vkauth$access_token )

# по полу и возрасту
gr_age_gender <- vkGetGroupStatGenderAge(date_from = '2020-11-01', 
                                         date_to   = Sys.Date(),
                                         group_id = 119709976, 
                                         access_token = vkauth$access_token )

# получить список постов группы и статистику по ним
posts <- vkGetUserWall(user_id = -119709976,
                       access_token = vkauth$access_token )


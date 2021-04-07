library(rvkstat)

# установка переменных
vkSetTokenPath('C:/my_develop_workshop/vk_auth')
vkSetUsername('rk_cabinet')

# авторизаци€
vk_accounts <- vkGetAdAccounts()
vkSetAccountId('1606703200')

# #################################
# ќбычный рекламный аккаунт
# #################################

# запрашиваем кампании и объ€влени€
vk_camps <- vkGetAdCampaigns()
vk_ads   <- vkGetAds()

# запрашиваем статистику по объ€влени€м
# по дн€и
stat_by_ads_daily <- vkGetAdStatistics(
  ids_type = 'ad',
  ids = vk_ads$id,
  period = 'day', 
  date_from = '2021-03-01',
  date_to = '2021-03-31'
)

# по недел€м
stat_by_ads_weekly <- vkGetAdStatistics(
  ids_type = 'ad',
  ids = vk_ads$id,
  period = 'week', 
  date_from = '2021-03-01',
  date_to = '2021-03-31'
)

# запрашиваем статистику по кампани€м
# по мес€цам
stat_by_camps_monthly <- vkGetAdStatistics(
  ids_type = 'campaign',
  ids = vk_camps$id,
  period = 'month', 
  date_from = '2021-01-01',
  date_to = '2021-03-31'
)

# #################################
# јгентский аккаунт
# #################################
vkSetUsername('selesnow_agency')

# список аккаунтов
vk_acoounts <- vkGetAdAccounts()

# какой агентский аккаунт нас интересует
vkSetAgencyId('1900002395')

# запрашиваем список клиентов
vk_clients <- vkGetAdClients()

# какой подчинЄнный аккаунт нас интересует
vkSetAccountId('1604857373')

# запрашиваем объекты рекламного кабинета
vk_camps <- vkGetAdCampaigns()
vk_ads   <- vkGetAds()

# запрашиваем статистику
# обща€ по мес€цам
camp_stat <- vkGetAdStatistics(
    ids_type = 'campaign',
    ids = vk_camps$id,
    period = 'month', 
    date_from = '2019-01-01',
    date_to = '2019-12-31'
)

# в разреще городов
camp_city_stat <- vkGetAdCityStats(
  ids_type = 'campaign',
  ids = vk_camps$id,
  period = 'month', 
  date_from = '2019-01-01',
  date_to = '2019-12-31'
)

# в разрезе пола
camp_gender_stat <- vkGetAdGenderStats(
  ids_type = 'campaign',
  ids = vk_camps$id,
  period = 'month', 
  date_from = '2019-01-01',
  date_to = '2019-12-31'
)

# визуализаци€
library(dplyr)
library(ggplot2)

# предобработка и визуализаци€
camp_stat %>%
  select(id, month, clicks) %>%
  left_join(camp_gender_stat) %>%
  filter(!is.na(impressions_rate)) %>%
  mutate(clicks = round(clicks * clicks_rate, 0)) %>%
  group_by(month, sex) %>%
  summarise(clicks = sum(clicks)) %>%
  ggplot(aes(y = clicks, x = month, group = sex)) +
  geom_line(aes(color = sex))
  

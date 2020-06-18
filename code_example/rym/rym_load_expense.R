library(rym)
library(rfacebookstat)
library(dplyr)

# options
options(rym.user = 'selesnow',
        rym.token_path =  'D:/packlab/rym',
        rfacebookstat.username = 'selesnow',
        rfacebookstat.accounts_id = 292115261475723)

# rym auth
rym_auth()
fbAuth()

# Запрос данных из Facebook
data <- fbGetMarketingStat(	date_start = Sys.Date() - 10,
                            date_stop = Sys.Date() - 1,
                            level = 'ad',
                            fields = "account_currency,
                                      campaign_name,
                                      ad_name,
                                      clicks,
                                      spend")

# преобразуем данные
data <- select(data, -date_stop) %>%
        rename(Date = date_start,
               UTMCampaign = campaign_name,
               UTMContent = ad_name,
               Currency = account_currency,
               Clicks = clicks,
               Expenses = spend) %>%
        mutate(UTMSource = 'facebook',
               UTMMedium = 'cpc')

# отправка данных в Яндекс Метрику
rym_upload_expense(
  22584910, 
  data
)

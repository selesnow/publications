library(ryandexdirect)
library(googleAnalyticsR)

# options
options(ryandexdirect.user = 'yandex_login',
        ryandexdirect.token_path = 'E:/direct_auth')

# load cost data
cost_data <- yadirGetCostData(DateFrom = Sys.Date() - 31,
                              DateTo = Sys.Date() - 1,
                              Source = 'yandex',
                              Medium = 'cpc',
                              IncludeVAT        = "YES",
                              IncludeDiscount   = "NO")

ga_auth(email = 'email@gmail.com')

# upload into GA source
ga_custom_upload_file(accountId          = 11111, 
                      webPropertyId      = "UA-11111-1", 
                      customDataSourceId = 'abcde', 
                      cost_data)

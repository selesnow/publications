library(ryandexdirect)
library(googleAnalyticsR)

# options
options(ryandexdirect.user = 'irina.netpeak',
        ryandexdirect.token_path = 'E:/direct_auth')

# load cost data
cost_data <- yadirGetCostData(DateFrom = Sys.Date() - 31,
                              DateTo = Sys.Date() - 1,
                              Source = 'yandex',
                              Medium = 'cpc',
                              IncludeVAT        = "YES",
                              IncludeDiscount   = "NO")

ga_auth(email = 'selesnow@gmail.com')

# upload into GA source
ga_custom_upload_file(accountId          = 44472206, 
                      webPropertyId      = "UA-44472206-1", 
                      customDataSourceId = 'AOs_pir7QNe4hTXiDdjE6Q', 
                      cost_data)

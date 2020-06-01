library(rfacebookstat)
library(googleAnalyticsR)

# options
options(rfacebookstat.username = 'testuser',
        rfacebookstat.accounts_id = "496441634619287")

# load cost data
cost_data <- fbGetCostData(date_start   = "2020-05-10", 
                           date_stop    = "2020-05-14")

# upload into GA source
ga_custom_upload_file(accountId          = 1111, 
                      webPropertyId      = "UA-1111-1", 
                      customDataSourceId = 'abcde', 
                      cost_data)

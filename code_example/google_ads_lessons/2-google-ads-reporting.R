library(rgoogleads)

# ####################################
# авторизация
gads_auth('alsey.netpeak@gmail.com')

# ####################################
# установка клиентского и упраляющего аккаунта
gads_set_login_customer_id("175-410-7253")
gads_set_customer_id("896-697-8643")

# ####################################
# запрос данных используя текст GAQL запроса
## Текст запроса
campaign_query <- "
SELECT 
  campaign.id, 
  campaign.name, 
  segments.date, 
  metrics.clicks, 
  metrics.impressions 
FROM campaign 
WHERE 
  segments.date DURING THIS_MONTH AND metrics.clicks > 0
"

## Запрос данных
campaign_data <- gads_get_report(gaql_query = campaign_query) 

# ####################################
# метаданные и информация о ресурсах
resources <- gads_get_metadata("RESOURCE")
metadata  <- gads_get_metadata("ALL")

fields    <- gads_get_fields("campaign")

# ####################################
# Задаём параметры запроса внутри gads_get_report()
## Повторяем используемый ранее запрос, но через параметры функции
campaign_data_2 <- gads_get_report(
  resource = "campaign", 
  fields   = c("campaign.id", 
               "campaign.name",
               "segments.date", 
               "metrics.clicks",
               "metrics.impressions"), 
  during = "THIS_MONTH",
  where  = "metrics.clicks > 0") 

# Включаем отображение GAQL запроса
options(gads.show_gaql_query = TRUE)

# Статичные даты
campaign_data_3 <- gads_get_report(
  resource = "campaign", 
  fields   = c("campaign.id", 
    "campaign.name",
    "segments.date", 
    "metrics.clicks",
    "metrics.impressions"), 
  date_from = "2022-04-01", date_to = "2022-04-19",
  where  = "metrics.clicks > 0") 

# ####################################
# Использование многопоточности
## задаём список клиентских аккаунтов
client_ids <- c(
  "896-697-8643", 
  "201-949-5809", 
  "263-160-7978", 
  "793-293-9250", 
  "927-254-7535")

gads_set_login_customer_id("175-410-7253")
gads_set_customer_id(client_ids)

## создаём кластер
cl <- parallel::makeCluster(4)

## выполняем запрос в многопоточном режиме
tictoc::tic("Loading in parallel")

multi_account_data <- gads_get_report(
  resource = "campaign", 
  fields   = c("campaign.id", 
    "campaign.name",
    "segments.date", 
    "metrics.clicks",
    "metrics.impressions"), 
  during = "THIS_MONTH",
  where  = "metrics.clicks > 0", 
  cl     = cl) 

tictoc::toc()

## останавливаем кластер
parallel::stopCluster(cl)

## запускаем тот же запрос в последовательном режиме
tictoc::tic("Loading in sequences")

multi_account_data <- gads_get_report(
  resource = "campaign", 
  fields   = c("campaign.id", 
    "campaign.name",
    "segments.date", 
    "metrics.clicks",
    "metrics.impressions"), 
  during = "THIS_MONTH",
  where  = "metrics.clicks > 0") 

tictoc::toc()

# ####################################
## Забираем списки объектов
gads_set_customer_id("927-254-7535")

campaigns <- gads_get_campaigns()
ad_groups <- gads_get_ad_groups()
ads       <- gads_get_ads()
keywords  <- gads_get_keywords(limit = 100)

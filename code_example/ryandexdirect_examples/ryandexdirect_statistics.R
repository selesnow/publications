library(ryandexdirect)

# заходим в аккаунт
yadirSetLogin("irina.netpeak")

# запрашиваем базовую статистику за предыдущие 7 дней
base_data <- yadirGetReport(
  DateRangeType = 'LAST_7_DAYS',
  FieldNames    = c('Date', 
                    'Clicks',
                    'Impressions',
                    'Cost')
)

# базовая статистика за произвольный период
base_data <- yadirGetReport(
  DateFrom = '2020-09-01',
  DateTo   = Sys.Date() - 1,
  FieldNames  = c('Date', 
                  'Clicks',
                  'Impressions',
                  'Cost')
)

# Учитывать ли НДС и скидки
base_data_vat <- yadirGetReport(
  DateFrom = '2020-09-01',
  DateTo   = Sys.Date() - 1,
  FieldNames  = c('Date', 
                  'Clicks',
                  'Impressions',
                  'Cost'), 
  IncludeVAT = 'NO', 
  IncludeDiscount = 'YES'
)

# конверсии и модели атрибуции
base_data_attributions <- 
  yadirGetReport(
    DateFrom = '2020-09-01',
    DateTo   = Sys.Date() - 1,
    FieldNames  = c('Date', 
                    'Conversions'), 
    Goals = c(13384610, 27475434),
    AttributionModels = c('FC', 'LC', 'LSC', 'LYDC')
)

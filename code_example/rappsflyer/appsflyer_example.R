# install.packages('rappsflyer')
devtools::install_github('selesnow/rappsflyer')

library(rappsflyer)

# устанавливаем токен
af_set_api_token("abcd-eeee-123h-khfkjkhds-kk")

# запрашиваем агрегированные данные
agr_data <- af_get_aggregate_data(
  date_from   = "2021-03-01", 
  date_to     = "2021-03-10", 
  report_type = "daily_report",
  additional_fields = c("keyword_id",
                        "store_reinstall",
                        "deeplink_url",
                        "oaid",
                        "install_app_store",
                        "contributor1_match_type",
                        "contributor2_match_type",
                        "contributor3_match_type",
                        "match_type"),
  app_id = "id894649641"
 )

# запрашиваем сырые данные
raw_organic_data <- af_get_raw_data(
  date_from   = "2021-02-01", 
  date_to     = "2021-02-10", 
  report_type = "installs_report",
  is_organic  = TRUE, 
  additional_fields = c("device_model",
                        "keyword_id",
                        "store_reinstall",
                        "deeplink_url",
                        "oaid",
                        "install_app_store",
                        "contributor1_match_type",
                        "contributor2_match_type",
                        "contributor3_match_type",
                        "match_type",
                        "device_category",
                        "gp_referrer",
                        "gp_click_time",
                        "gp_install_begin",
                        "amazon_aid",
                        "keyword_match_type",
                        "att",
                        "conversion_type",
                        "campaign_type",
                        "is_lat"),
  retargeting = FALSE,
  app_id = "id894649641"
)

# данные о рекламной прибыли
ad_revenue_data <- af_get_ad_revenue_raw_data(
  date_from   = "2021-02-01", 
  date_to     = "2021-02-10",
  report_type = "ad_revenue_raw",
  is_organic = FALSE,
  additional_fields = c("device_model",
                        "keyword_id",
                        "store_reinstall",
                        "deeplink_url",
                        "oaid",
                        "ad_unit",
                        "segment",
                        "placement",
                        "monetization_network",
                        "impressions",
                        "mediation_network",
                        "is_lat"),
  timezone = "Europe/Moscow",
  retargeting = FALSE,
  maximum_rows = 1000000,
  app_id = "id894649641"
)

# данные по правилам проверки
validation_rules_data <- af_get_targeting_validation_rules(
  date_from   = "2021-02-01", 
  date_to     = "2021-02-10",
  report_type = "invalid_installs_report",
  additional_fields      = c("device_model",
                             "keyword_id",
                             "store_reinstall",
                             "deeplink_url",
                             "oaid",
                             "rejected_reason",
                             "rejected_reason_value",
                             "contributor1_match_type",
                             "contributor2_match_type",
                             "contributor3_match_type",
                             "match_type",
                             "device_category",
                             "gp_referrer",
                             "gp_click_time",
                             "gp_install_begin",
                             "amazon_aid",
                             "keyword_match_type",
                             "att",
                             "conversion_type",
                             "campaign_type",
                             "is_lat"),
  app_id = "id894649641"
)

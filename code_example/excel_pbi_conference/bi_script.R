# BI Script
# ����������� �������
library(rvkstat)
library(dplyr)
library(tidyr)


# �������� �������������� ������ 
vkauth <- readRDS("C:/vkauth/vkauth.rds")

# ����������� ������ �� �����������
Sys.sleep(1)
ag_ads <- vkGetAds(
  account_id   = 1900002395,
  client_id    = 1604857373,
  access_token = vkauth$access_token) %>%
  mutate(id = as.integer(id))

# ����������� ���������� �� �����������
Sys.sleep(3)
ag_vk_data <- vkGetAdStatistics(account_id   = 1900002395,
                                ids_type     = "ad",
                                ids          = ag_ads$id ,
                                period       = "day",
                                date_from    = "2020-11-01",
                                date_to      = Sys.Date(),
                                access_token = vkauth$access_token)

# ����������� ������ ��������
Sys.sleep(10)
ag_camps <- vkGetAdCampaigns(account_id   = 1900002395,
                             client_id    = 1604857373,
                             access_token = vkauth$access_token)

# ���������� ������
# ���������� ������ � ���� �������
vkdata <- left_join(ag_vk_data, ag_ads, by = 'id', suffix = c("", "_ads")) %>%
  left_join(ag_camps, by = c('campaign_id' = 'id'), suffix = c("", "_camp")) 

# �������� NA �� ����
vkdata <- mutate(vkdata, 
                 across(where(~ is.numeric(.x) || is.integer(.x)), replace_na, 0), 
                 day = as.Date(day))


# ����� ���������� ����������
Sys.sleep(17)
gr_data <- vkGetGroupStat(date_from = '2020-11-01', 
                          date_to   = Sys.Date(),
                          group_id = 119709976, 
                          access_token = vkauth$access_token ) %>%
  mutate( across( where(~ is.numeric(.x) | is.integer(.x) ), replace_na, 0 ) )

# �� �������
Sys.sleep(25)
gr_countries <- vkGetGroupStatCountries(date_from = '2020-11-01', 
                                        date_to   = Sys.Date(),
                                        group_id = 119709976, 
                                        access_token = vkauth$access_token )

# �� ���� � ��������
Sys.sleep(32)
gr_age_gender <- vkGetGroupStatGenderAge(date_from = '2020-11-01', 
                                         date_to   = Sys.Date(),
                                         group_id = 119709976, 
                                         access_token = vkauth$access_token )

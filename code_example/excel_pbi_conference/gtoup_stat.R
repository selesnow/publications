# ����������� ������
library(rvkstat)
library(dplyr)
library(tidyr)

# �������� �������������� ������ 
vkauth <- readRDS("C:/vkauth/vkauth.rds")

# �������� ������ �����
mygroups <- vkGetUserGroups(access_token = vkauth$access_token)

# ����� ���������� ����������
gr_data <- vkGetGroupStat(date_from = '2020-11-01', 
                          date_to   = Sys.Date(),
                          group_id = 119709976, 
                          access_token = vkauth$access_token ) %>%
           mutate( across( where(~ is.numeric(.x) | is.integer(.x) ), replace_na, 0 ) )

# �� �������
gr_countries <- vkGetGroupStatCountries(date_from = '2020-11-01', 
                                        date_to   = Sys.Date(),
                                        group_id = 119709976, 
                                        access_token = vkauth$access_token )

# �� ���� � ��������
gr_age_gender <- vkGetGroupStatGenderAge(date_from = '2020-11-01', 
                                         date_to   = Sys.Date(),
                                         group_id = 119709976, 
                                         access_token = vkauth$access_token )

# �������� ������ ������ ������ � ���������� �� ���
posts <- vkGetUserWall(user_id = -119709976,
                       access_token = vkauth$access_token )


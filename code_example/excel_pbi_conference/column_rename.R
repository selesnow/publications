# 'dataset' holds the input data for this script

library(dplyr)

# ���������� ������ �������� ��������
cnames <- unique(dataset$name_camp)

# ������� �����
new_names <- paste0("camp_", 1:length(cnames))

# ������ ���������� ��������
cdict <- data.frame(old_names = cnames,
                    new_names = new_names)

# ��������� ��������
out <- left_join(dataset, cdict, by = c('name_camp' = 'old_names')) %>%
  mutate(name_camp = new_names) %>%
  select(-new_names) %>%
  mutate(day = as.Date(day, format = '%m/%d/%Y'))

# ������� ����������
rm(cdict)


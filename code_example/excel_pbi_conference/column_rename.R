# 'dataset' holds the input data for this script

library(dplyr)

# уникальный список названий кампаний
cnames <- unique(dataset$name_camp)

# шифруем имена
new_names <- paste0("camp_", 1:length(cnames))

# создаём справочник кампаний
cdict <- data.frame(old_names = cnames,
                    new_names = new_names)

# подменяем название
out <- left_join(dataset, cdict, by = c('name_camp' = 'old_names')) %>%
  mutate(name_camp = new_names) %>%
  select(-new_names) %>%
  mutate(day = as.Date(day, format = '%m/%d/%Y'))

# удаляем справочник
rm(cdict)


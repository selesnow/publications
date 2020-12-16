library(ggplot2)
library(dplyr)
library(forcats)

# убираем дубликаты
dataset <- data.frame(day = vkdata$day, 
                      id = vkdata$id, 
                      clicks = vkdata$clicks, 
                      name_camp = vkdata$name_camp)

dataset <- unique(dataset)

# визуализация
dataset %>%
  group_by(day, name_camp) %>%
  summarise(clicks = sum(clicks)) %>%
  ggplot( aes(x = fct_reorder(.f = name_camp,
                              .x = -clicks, 
                              .fun = median), 
              y = clicks, 
              fill = name_camp) ) +
  geom_boxplot() +
  coord_flip() +
  theme(legend.position = 'none', axis.text.y = element_text(size = 14), axis.text.x = element_text(size = 14)) +
  xlab('Кампании') + ylab('К-во кликов')

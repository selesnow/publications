# подключение пакетов
library(vroom)
library(dplyr)

# загрузка данных
ga_data <- vroom("https://raw.githubusercontent.com/selesnow/publications/master/code_example/from_excel_to_r/lesson_3/ga_nowember.csv")

# сгруппировать данные по дням
ga_data %>%
  group_by(date) %>%
  summarise(sessions = sum(sessions),
            bounces  = sum(bounces))

# другой вариант
ga_data %>%
  group_by(date) %>%
  summarise_at(c("sessions", "bounces"), 
               sum)

# группировка по двум полям
ga_data %>%
  group_by(date, medium) %>%
  summarise_at(c("sessions", "bounces"), 
               sum)

ga_data %>%
  group_by(date, medium) %>%
  summarise(ses = sum(sessions),
            bounc = sum(bounces))

# сумма по всем числовым столбцам
ga_data %>%
  group_by(medium) %>%
  summarise_if(is.numeric, mean)

# среднесуточное количество сеансов по каналам
ndays <- unique( ga_data$date ) %>% length

ga_data %>%
  group_by(medium) %>%
  summarise(daily_sessions = sum(sessions) / ndays)

# применяем сразу несколько агрегирующий функций
# сумма по всем числовым столбцам
result <-
ga_data %>%
  group_by(medium) %>%
  summarise_if(is.numeric, 
               list( avg   = mean,
                     med   = median,
                     sum   = sum,
                     count = length,
                     min   = min,
                     max   = max))

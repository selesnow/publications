# dtplyr
library(data.table)
library(dtplyr)
library(dplyr, warn.conflicts = FALSE)

# dtplyr использует ленивые вычисления
mtcars2 <- lazy_dt(mtcars)

# проверка результата
mtcars2 %>% 
  filter(wt < 5) %>% 
  mutate(l100k = 235.21 / mpg) %>% # liters / 100 km
  group_by(cyl) %>% 
  summarise(l100k = mean(l100k))

# но для выполнения вычислений следует использовать
#  as.data.table(), as.data.frame() или as_tibble()
mtcars2 %>% 
  filter(wt < 5) %>% 
  mutate(l100k = 235.21 / mpg) %>% # liters / 100 km
  group_by(cyl) %>% 
  summarise(l100k = mean(l100k)) %>% 
  as_tibble()

# более подробно о том, как осуществляется перевод кода
df <- data.frame(a = 1:5, b = 1:5, c = 1:5, d = 1:5)
dt <- lazy_dt(df)

# посмотрим предварительную оценку перевода
dt
# если мы хотим посмотреть в какое выражение data.table
# будет преобразован код dplyr используем show_query()
dt %>% show_query()

# простые глаголы 
## filter() / arrange() - i
dt %>% arrange(a, b, c) %>% show_query()
dt %>% filter(b == c) %>% show_query()
dt %>% filter(b == c, c == d) %>% show_query()

## select(), summarise(),transmute() - j
dt %>% select(a:b) %>% show_query()
dt %>% summarise(a = mean(a)) %>% show_query()
dt %>% transmute(a2 = a * 2) %>% show_query()

## mutate - j + :=
dt %>% mutate(a2 = a * 2, b2 = b * 2) %>% show_query()

# Другие глаголы dplyr
## rename - setnames
dt %>% rename(x = a, y = b) %>% show_query()
## distinct - unique
dt %>% distinct() %>% show_query()
dt %>% distinct(a, b) %>% show_query()
dt %>% distinct(a, b, .keep_all = TRUE) %>% show_query()

# Операции объединения
dt2 <- lazy_dt(data.frame(a = 1))

## [.data.table
dt %>% inner_join(dt2, by = "a") %>% show_query()
dt %>% right_join(dt2, by = "a") %>% show_query()
dt %>% left_join(dt2, by = "a") %>% show_query()
dt %>% anti_join(dt2, by = "a") %>% show_query()

## merge()
dt %>% full_join(dt2, by = "a") %>% show_query()

# Группировка keyby
dt %>% group_by(a) %>% summarise(b = mean(b)) %>% show_query()

# Комбинации вызовов
dt %>% 
  filter(a == 1) %>% 
  select(-a) %>% 
  show_query()

dt %>% 
  group_by(a) %>% 
  filter(b < mean(b)) %>% 
  summarise(c = max(c)) %>% 
  show_query()


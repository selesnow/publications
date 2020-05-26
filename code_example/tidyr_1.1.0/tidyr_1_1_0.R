# Что нового в tidyr 1.1.0
# ##############
library(tidyr)

# Переименование столбцов на лету с помощью аргумента names_transform
df <- tibble(id = 1, wk1 = 0, wk2 = 4, wk3 = 9, wk4 = 25)

df %>% pivot_longer(
  cols = starts_with("wk"),
  names_to = "week"
)

df %>% pivot_longer(
  cols = starts_with("wk"),
  names_to = "week",
  names_transform = list(week = readr::parse_number),
)

# Теперь вы можете отбросить имена столбцов если они вам не нужны
df <- tibble(id = 1:2, fruitful_panda = 3:4, angry_aardvark = 5:6)  

df %>% pivot_longer(-id)

df %>% pivot_longer(-id, names_to = character())

# pivot_longer теперь корректно работает даже если имена столбцов дублируются
df <- tibble(id = 1:3, x = 1:3, x = 4:6, .name_repair = "minimal")  

df %>% pivot_longer(-id)

# вы можете убрать ненужню часть имён столбцов используя аргументы 
# names_pattern или names_sep и names_to
df <- tibble(id = 1:3, x_1 = 1:3, y_2 = 4:6, y_3 = 9:11)

df %>% pivot_longer(-id)

df %>% pivot_longer(-id, names_pattern = "(.)_.")

df %>% pivot_longer(-id, names_pattern = "._(.)")

df %>% pivot_longer(-id, names_sep = "_", names_to = c("name", NA))

df %>% pivot_longer(-id, names_sep = "_", names_to = c(".value", NA))

# сортировка новых столбцов pivot_wider()
# с помощью аргумента names_sort
df <- tibble(
  day_int = c(3, 4, 5, 1, 2),
  day_fac = factor(day_int, labels = c("Mon", "Tue", "Wed", "Thu", "Fri"))
)

df %>% pivot_wider(
  names_from = day_fac, 
  values_from = day_int
)

df %>% pivot_wider(
  names_from = day_fac,
  names_sort = TRUE,
  values_from = day_int
)

# Новый аргумент names_glue позволяет соединять имена столбцов
# в тех случаях когда аргумент names_from принимает сразу несколько столбцов
df <- tibble(
  first  = c("a", "b", "c"),
  second = c("1", "2", "3"),
  third  = c("X", "Y", "Z"),
  val    = c(1, 2, 3)
)

df %>% pivot_wider(
  names_from = c(first, second, third), 
  values_from = val,
  names_glue = "{first}.{second}_{third}"
)

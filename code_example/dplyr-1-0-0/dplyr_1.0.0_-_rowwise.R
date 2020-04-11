#devtools::install_github("tidyverse/dplyr")
library(dplyr)

# test data
df <- tibble(
  student_id = 1:4, 
  test1 = 10:13, 
  test2 = 20:23, 
  test3 = 30:33, 
  test4 = 40:43
)

df

# попытка посчитать среднюю оценку по студету
df %>% mutate(avg = mean(c(test1, test2, test3, test4)))

# используем rowwise для преобразования фрейма
rf <- rowwise(df, student_id)
rf

rf %>% mutate(avg = mean(c(test1, test2, test3, test4)))

# тоже самое с использованием c_across
rf %>% mutate(avg = mean(c_across(starts_with("test"))))

# ###########################
# некоторые арифметические операции векторизированы по умолчанию
df %>% mutate(total = test1 + test2 + test3 + test4)

# этот подход можно использовать для вычисления среднего
df %>% mutate(avg = (test1 + test2 + test3 + test4) / 4)

# так же вы можете использовать некоторые специальные функции
# для вычисления некоторых статистик
df %>% mutate(
  min = pmin(test1, test2, test3, test4), 
  max = pmax(test1, test2, test3, test4), 
  string = paste(test1, test2, test3, test4, sep = "-")
)
# все векторизированные функции будут работать быстрее чем rowwise
# но rowwise позволяет векторизировать любую функцию

# ##################################
# работа со столбцами списками
df <- tibble(
  x = list(1, 2:3, 4:6),
  y = list(TRUE, 1, "a"),
  z = list(sum, mean, sd)
)

# мы можем перебором обработать каждый список
df %>% 
  rowwise() %>% 
  summarise(
    x_length = length(x),
    y_type = typeof(y),
    z_call = z(1:5)
  )

# ##################################
# симуляция случайных данных
df <- tribble(
  ~id, ~ n, ~ min, ~ max,
  1,   3,     0,     1,
  2,   2,    10,   100,
  3,   2,   100,  1000,
)

# используем rowwise для симуляции данных
df %>%
  rowwise(id) %>%
  mutate(data = list(runif(n, min, max)))

df %>%
  rowwise(id) %>%
  summarise(x = runif(n, min, max))

# ##################################
# функция nest_by позволяет создавать столбцы списки
by_cyl <- mtcars %>% nest_by(cyl)
by_cyl

# такой подход удобно использовать при построении линейной модели
# используем mutate для подгонки моели под каждую группа данных
by_cyl <- by_cyl %>% mutate(model = list(lm(mpg ~ wt, data = data)))
by_cyl
# теперь с помощью summarise 
# можно извлекать сводки или коэфициенты построенной модели
by_cyl %>% summarise(broom::glance(model))
by_cyl %>% summarise(broom::tidy(model))

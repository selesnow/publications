# devtools::install_github("tidyverse/dplyr")
library(dplyr, warn.conflicts = FALSE)

# тестовый дата фрейм
df <- tibble(g1 = letters[1:10],
             g2 = LETTERS[1:10],
             a  = runif(10, 1, 10),
             b  = runif(10, 10, 20),
             c  = runif(10, 15, 30),
             d  = runif(10, 1, 50))

# о чём пойдёт речь
## копирование кода, когда требуется 
## произвести одну и туже операцию с разными функциями
df %>% 
  group_by(g1, g2) %>% 
  summarise(a = mean(a), b = mean(b), c = mean(c), d = mean(c))

# новый способ
## теперь для таких преобразований можно
## использовать тот же синтаксис что и в select()
### посчитать среднее по столбцам от a до d
df %>% 
  group_by(g1, g2) %>% 
  summarise(across(a:d, mean))

### или посчитать среднее выбрав все числовые столбцы 
df %>% 
  group_by(g1, g2) %>% 
  summarise(across(is.numeric, mean))

# ##############################
# Простой пример
# аргументы функции accros

## .cols - выбор столбцов по позиции, имени, функцией, типу данных, или комбинируя любые перечисленные способы
## .fns - функция, или список функций которые необходимо применить к каждому столбцу

## считаем количество униклаьных значений в текстовых полях
starwars %>% 
  summarise(across(is.character, n_distinct))

## пример с фильтрацией данных
starwars %>% 
  group_by(species) %>% 
  filter(n() > 1) %>% 
  summarise(across(c(sex, gender, homeworld), n_distinct))

## комбинируем accross с другими вычислениями
starwars %>% 
  group_by(homeworld) %>% 
  filter(n() > 1) %>% 
  summarise(across(is.numeric, mean, na.rm = TRUE), 
            n = n())

# ##############################
# Чем accross лучше предыдущих функций с суфиксами _at, _if, _all

## 1. accross позволяет комбинировать различные вычисления внутри одной summarise 
## пример из статьи
df %>%
  group_by(g1, g2) %>% 
  summarise(
    across(is.numeric, mean), 
    across(is.factor, nlevels),
    n = n(), 
  )

## рабочий пример
starwars %>% 
  group_by(species) %>% 
  summarise(across(is.character, n_distinct), 
            across(is.numeric, mean), 
            n = n()
  )

## 2. уменьшает количество необходимых функций в dplyr, что облегчает их запоминание
## 3. объединяет возможности функций с суфиксами if_, at_, и даёт возможность объединять их возможности
## 4. accross не требует от вас использования функции vars для указания нужных столбцлв, как это было раньше

# ##############################
# перевод старого кода на accross

## для перевода функций с суфиксами _at, _if, _all используйте следующие правила
### в accross первым агрументом будет:
### Для *_if() старый второй аргумент.
### Для *_at() старый второй аргумент с удаленным вызовом vars().
### Для *_all(), в качестве первого аргумента передайте функцию everything()

## примеры
df <- tibble(y_a  = runif(10, 1, 10),
             y_b  = runif(10, 10, 20),
             x    = runif(10, 15, 30),
             d    = runif(10, 1, 50))

### из _if в accross
df %>% mutate_if(is.numeric, mean, na.rm = TRUE)
# ->
df %>% mutate(across(is.numeric, mean, na.rm = TRUE))

### из _at в accross
df %>% mutate_at(vars(c(x, starts_with("y"))), mean, na.rm = TRUE)
# ->
df %>% mutate(across(c(x, starts_with("y")), mean, na.rm = TRUE))

### из _all в accroos
df %>% mutate_all(mean, na.rm = TRUE)
# ->
df %>% mutate(across(everything(), mean, na.rm = TRUE))

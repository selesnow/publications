#devtools::install_github("tidyverse/dplyr")
library(dplyr)

# #######################################################
# summarise #############################################
# #######################################################

# Основные изменения
## теперь summarise может вернуть
### вектор любой длинны
### дата фрейм любой размерности

# тестовые данные
df <- tibble(
  grp = rep(1:2, each = 5), 
  x = c(rnorm(5, -0.25, 1), rnorm(5, 0, 1.5)),
  y = c(rnorm(5, 0.25, 1), rnorm(5, 0, 0.5)),
)

df

# получим минимальные и максимальные значения для каждой группы
# и поместим эти значения в строки
df %>% 
  group_by(grp) %>% 
  summarise(rng = range(x))

## функция range возвращает вектор длинны 2
range(df$x)
## но функция summarise разворачивает его, 
## приводя каждое из возвращаемых значений в новую строку

# тоже самое, но для столбцов
df %>% 
  group_by(grp) %>% 
  summarise(tibble(min = min(x), mean = mean(x)))

# что бы названия столбца подтягивались из аргумена
quibble2 <- function(x, q = c(0.25, 0.5, 0.75)) {
  tibble("{{ x }}" := quantile(x, q), "{{ x }}_q" := q)
}

# расчёт квантилей
df %>% 
  group_by(grp) %>% 
  summarise(quibble2(y, c(0.25, 0.5, 0.75)))

# Предыдущие подходы
df %>% 
  group_by(grp) %>% 
  summarise(y = list(quibble2(y, c(0.25, 0.75)))) %>% 
  tidyr::unnest(y)

df %>% 
  group_by(grp) %>% 
  do(quibble2(.$y, c(0.25, 0.75)))

# #######################################################
# select rename_with relocate ###########################
# #######################################################

# rename
## Переименовать столбцы для устранение дублирования их имён
df1 <- tibble(a = 1:5, a = 5:1, .name_repair = "minimal")
df1

df1 %>% rename(b = 2)

# select
## обращение к столбцам по типу
df2 <- tibble(x1 = 1, x2 = "a", x3 = 2, y1 = "b", y2 = 3, y3 = "c", y4 = 4)

## числовые столбцы
df2 %>% select(is.numeric)
## НЕ текстовые столбцы
df2 %>% select(!is.character)

## смешанный тип обращения
## числовые стобцы, название которых начинается на X
df2 %>% select(starts_with("x") & is.numeric)

# rename_with
df2 %>% rename_with(toupper)
df2 %>% rename_with(toupper, starts_with("x"))
df2 %>% rename_with(toupper, is.numeric)

# relocate для изменения порядка стобцов
df3 <- tibble(w = 0, x = 1, y = "a", z = "b")
## переместить столбцы y, z в начало
df3 %>% relocate(y, z)
## переместить текстовые столбцы вначало
df3 %>% relocate(is.character)

## поместить столбец w после y
df3 %>% relocate(w, .after = y)
## поместить столбец w перед y
df3 %>% relocate(w, .before = y)
## переместить w в конец
df3 %>% relocate(w, .after = last_col())


# #######################################################
# across ################################################
# #######################################################
# тестовый дата фрейм
df <- tibble(g1 = as.factor(sample(letters[1:4],size = 10, replace = T )),
             g2 = as.factor(sample(LETTERS[1:3],size = 10, replace = T )),
             a  = runif(10, 1, 10),
             b  = runif(10, 10, 20),
             c  = runif(10, 15, 30),
             d  = runif(10, 1, 50))

## произвести одну и туже операцию с разными функциями
## предыдущий подход
df %>% 
  group_by(g1, g2) %>% 
  summarise(a = mean(a), b = mean(b), c = mean(c), d = mean(c))

## новый способ
## теперь для таких преобразований можно
## использовать тот же синтаксис что и в select()
### посчитать среднее по столбцам от a до d
df %>% 
  group_by(g1, g2) %>% 
  summarise(across(a:d, mean))

## или посчитать среднее выбрав все числовые столбцы 
df %>% 
  group_by(g1, g2) %>% 
  summarise(across(is.numeric, mean))


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

# Чем accross лучше предыдущих функций с суфиксами _at, _if, _all
## 1. accross позволяет комбинировать различные вычисления внутри одной summarise 
df %>%
  group_by(g1, g2) %>% 
  summarise(
    across(is.numeric, mean), 
    across(is.factor, nlevels),
    n = n(), 
  )

## 2. уменьшает количество необходимых функций в dplyr, что облегчает их запоминание
## 3. объединяет возможности функций с суфиксами if_, at_, и даёт возможность объединять их возможности
## 4. accross не требует от вас использования функции vars для указания нужных столбцлв, как это было раньше


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

# #######################################################
# rowwise ################################################
# #######################################################

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
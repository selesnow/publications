# install.packages('clock')
# https://cran.r-project.org/web/packages/clock/vignettes/clock.html

# подключаем библиотеки
library(clock)
library(magrittr)


# Конструктор дат
date_build(2019, 2, 1:5)

## Ошибка при указании несуществующей даты
date_build(2019, 1:12, 31)
## Используем аргумент invalid
date_build(2019, 1:12, 31, invalid = "previous")
date_build(2019, 1:12, 31, invalid = "next")
date_build(2019, 1:12, 31, invalid = "previous-day")
## либо можно указать вместо дня месяца last
date_build(2019, 1:12, "last")


# Конструктор даты и времени
date_time_build(2019, 1:5, 1, 2, 30, zone = "Europe/Moscow")
date_time_build(2019, 1:5, 1, 2, 30, zone = "Europe/Moscow")

## если указать на несуществующее время, 
## которое может возникнуть при переходе с летнего на зимнее 
## или наоборо, мы получим ошибку
## например при переходе с зимнего на летнее время 8 марта выпало 2 часа
date_time_build(2019:2021, 3, 8, 2, 30, zone = "America/New_York")
## решить проблему можно перейдя к ближайшему существующему времени вперёд, 
## или назад
date_time_build(
  2019:2021, 3, 8, 2, 30, 
  zone = "America/New_York", 
  nonexistent = "roll-forward"
  )

date_time_build(
  2019:2021, 3, 8, 2, 30, 
  zone = "America/New_York", 
  nonexistent = "roll-backward")


# Парсинг даты
date_parse("2019-01-05")
## указываем при необходимости формат
date_parse("January 5, 2020", format = "%B %d, %Y")
## Так же можем указать локаль
date_parse(
  "10 января, 2021", 
  format = "%d %B, %Y", 
  locale = clock_locale("ru")
)
## Указываем несколько разных форматов
x <- c("2020/1/5", "10-03-05", "2020/2/2")
formats <- c("%Y/%m/%d", "%y-%m-%d")

date_parse(x, format = formats)


# Парсинг даты и времени
## простой парсер, данные указаны без часового пояса
date_time_parse("2020-01-01 01:02:03", "America/New_York")
## Если указано и название часового пояса, и смещение
date_time_parse_complete("2020-01-01 01:02:03-05:00[America/New_York]")
## Если указана лишь абревиатура часового пояса
date_time_parse_abbrev("2020-01-01 01:02:03 EST", "America/New_York")


# Группировка
x <- seq(date_build(2019, 1, 20), date_build(2019, 2, 5), by = 1)
## группируем по 5 дней
## В таком случае при старте нового месяца группы перезапускаются
date_group(x, "day", n = 5)
## Так же можно группировать данные по месяцвм или годам
date_group(x, "month")
## Так же вы можете группировать дату и время 
x <- seq(
  date_time_build(2019, 1, 1, 1, 55, zone = "UTC"),
  date_time_build(2019, 1, 1, 2, 15, zone = "UTC"),
  by = 120
)
## группироуем в 5ти минутные отрезки
date_group(x, "minute", n = 5)

## практический пример применения группировки
library(dplyr)

set.seed(400)

## тестовый набор данных
df <- tibble(
  date = sample(seq(date_build(2019, 1, 1), 
                    date_build(2019, 12, 31), 
                    by = 1), 
                size = 50, replace = TRUE),
  val  = runif(50, 1, 100)
)
## группируем данные по месяцу
df %>%
  mutate(month = date_group(date, 'month')) %>%
  group_by(month) %>%
  summarise(val = sum(val))


# Округление
x <- seq(date_build(1970, 01, 01), date_build(1970, 05, 10), by = 20)
## Округляем вниз по 60 дней
date_floor(x, "day", n = 60)
## Округляем вверх по 60 дней
date_ceiling(x, "day", n = 60)
## Округление по дням недели
date_floor(x, "week", n = 14)
## В данном случае началом недели считается четверг
as_weekday(date_floor(x, "week", n = 14))
## Мы можем задать любой другой день, указав дату в origin
sunday <- date_build(1970, 01, 04)
date_floor(x, "week", n = 14, origin = sunday)
as_weekday(date_floor(x, "week", n = 14, origin = sunday))

## Практический пример
## Например нам надо оценить выполнение двух недельных спринтов 
library(tidyr)

df <- tibble(
  date = sample(seq(date_build(2019, 1, 1), 
                    date_build(2019, 12, 31), 
                    by = 1), 
                size = 150, replace = TRUE),
  proger_id = sample(1:5, size = 150, replace = TRUE),
  score  = runif(150, 10, 15)
)

df %>%
  mutate(sprints = date_floor(date, "week", n = 2, origin = date_build(2019, 1, 3))) %>%
  group_by(sprints, proger_id) %>%
  summarise(score = sum(score)) %>%
  pivot_wider(names_from = proger_id, values_from = score)

# Смещение
## например нам надо получить ближайший вторник от заданной даты
x <- date_build(2020, 1, 1:4)
as_weekday(x)
## вспомогательный объект
clock_weekdays$tuesday

tuesday <- weekday(clock_weekdays$tuesday)
tuesday
## сдвигаем даты на ближайший вторник вперёд
date_shift(x, target = tuesday)
## сдвиг на ближайший вторник назад
date_shift(x, target = tuesday, which = "previous")
## аргумент boundary
## позволяет сохранить или пеерйти к следующему дню
## если текущий день и является запрашиваемым
x <- date_build(2020, 1, 1:4)
as_weekday(x)

thursday <- weekday(clock_weekdays$thursday)

# оставить текущий
date_shift(
  x, 
  target = thursday, 
  which = "next", 
  boundary = 'keep'
  )

# передвинуть к следующему даже если текущий день целевой
date_shift(
  x, 
  target = thursday, 
  which = "next", 
  boundary = 'advance'
  )


# Арифметические операции с датами
x <- date_build(2020, 1, 1)
add_years(x, 1:5)
add_months(x, 1:11)
add_days(x, 10:15)
## обработка ошибок
x <- date_build(2020, 1, 31)

add_months(x, 1)
## брать предыдущий
add_months(x, 1, invalid = "previous")
## брать следующий
add_months(x, 1, invalid = "next")
## дополнять, например в феврале было 29 дней, значит надо дополнить 2мя днями
add_months(x, 1, invalid = "overflow")
## оставить пустыми NA
add_months(x, 1, invalid = "NA")


# Геттеры и Сеттеры
x <- date_build(2019, 5, 6)
get_year(as.Date('2020-01-17'))
get_year(x)
get_month(x)
get_day(x)

x %>%
  set_day(22) %>%
  set_month(10) %>%
  set_year(2020)

## Обработка не существующих дат
x %>%
  set_day(31) %>%
  set_month(4)

x %>%
  set_day(31) %>%
  set_month(4, invalid = "next")

## Так же можно работать и с датой и временм
x <- date_time_build(2020, 1, 2, 3, zone = "America/New_York")
x

x %>%
  set_minute(5) %>%
  set_second(10)

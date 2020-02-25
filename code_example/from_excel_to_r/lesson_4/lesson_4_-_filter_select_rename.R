# установка пакетов
install.packages("dplyr")

# подключение пакетов
library(vroom)
library(dplyr)

# загрузка данных
ga_data <- vroom("https://raw.githubusercontent.com/selesnow/publications/master/code_example/from_excel_to_r/lesson_3/ga_nowember.csv")

# ######################################################
# фильтраци¤ строк
## простейший фильтр с одним условием
ga_data_organic <- filter(ga_data, medium == "organic")

## несколько условий
ga_data_organic_10 <- filter(ga_data, medium == "organic" & sessions > 10 )

## провер¤ем на соответвию значению из списка
google_yandex <- filter(ga_data, source %in% c("google", "yandex", "bing"))

## создаЄм вектор дл¤ фильтрации
search_eng <- c("google", "yandex", "bing")
## используем вектор дл¤ фильтрации
not_searcj_eng <- filter(ga_data, ! source %in% search_eng)

# ######################################################
# выбор столбцов
## простой выбор столбцов по названи¤м
ga_data_с1 <- select(ga_data, date, sessions)

## срез по столбцам
ga_data_с2 <- select(ga_data, source:sessions)

## получить столбцы по названию использу¤ регул¤рные выражени¤
match_s  <- select_at(ga_data, vars(matches("s")))     # содержит s
match_s2 <- select_at(ga_data, vars(contains("s")))    # содержит s
last_s1  <- select_at(ga_data, vars(matches("s$")))    # заканчиваетс¤ на s
last_s2  <- select_at(ga_data, vars(ends_with("s")))   # заканчиваетс¤ на s
start_s1 <- select_at(ga_data, vars(matches("^s")))    # начинаетс¤ на s
start_s2 <- select_at(ga_data, vars(starts_with("s"))) # начинаетс¤ на s

## выбрать только числовые столбцы
ga_num_column <- select_if(ga_data, is.numeric)
ga_str_column <- select_if(ga_data, is.character)

## шпаргалка
# select - выбор столбцов по названию
# select_at - выбор по названию с попощью доп операторов и регул¤рных выражений
# select_if - выбор по типу пол¤, например все строковые или все числовые пол¤

# ######################################################
# переименовываем столбцы
new_ga_data <- rename(ga_data,
                      channel  = medium,
                      refferer = source)

# мен¤ем стиль имЄн столбцов
rename_if(ga_data, is.numeric, paste0, "_n")
rename_at(ga_data, vars(matches("^s")), paste0, "_s")
rename_all(ga_data, toupper)         

# ######################################################
# пайплайны
## вложенные функции (как в Excel)
rename_all(select_if(filter(ga_data, source %in% search_eng), is.numeric), toupper)

## тоже самое но через пайплайн %>%
result <- ga_data %>%
            filter(source %in% search_eng) %>%
            select_if(is.numeric) %>%
            rename_all(toupper)

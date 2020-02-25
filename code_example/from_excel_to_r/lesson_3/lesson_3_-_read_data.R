# Загрузка данных в R
# Установка пакетов
install.packages("vroom")
install.packages("readxl")
install.packages("devtools")
devtools::install_github("tidyverse/googlesheets4")

# ###########################################
# подключение пакетов
library("vroom")


# ###########################################
# Чтение CSV, TSV и прочих текстовых файлов

## чтение локальных файлов
ga_data <- vroom(file = "D:/materials/lesson_3/ga_nowember.csv", delim = "/t")
## чтение файлов опубликованных в интернете
ga_data_i <- vroom("https://raw.githubusercontent.com/selesnow/publications/master/data_example/russian_text_in_r/ga_nowember.csv")

## чтение нескольких файлов в одну таблицу
files   <- dir(pattern = "\\.csv$")
ga_full <- vroom(files) 


# ###########################################
# Чтение Excel файлов
library(readxl)

## получить список листов из Excel файла
excel_sheets("D:/materials/lesson_3/ga_examples.xlsx")

## считать данные с листа
xl_dec <- read_excel("D:/materials/lesson_3/ga_examples.xlsx", sheet = "dec")

# ###########################################
# Чтение Google Таблиц
library(googlesheets4)

## Авторихация
sheets_auth(email = "selesnow@gmail.com")
sheets_find()
## Подклбчение к доксу
ss_id <- as_sheets_id("1xu_beKZVpJJTHTvAab_vN3ZiMB03BytKArGjJUO8cck")

## открыть докс в браузере
sheets_browse(ss)

## посмотреть список листов
sheets_sheet_names(ss)

## получить данные из листа
gs_ga_data <- sheets_read(ss = ss_id, 
                          sheet = "dec")

## получить данные из диапазона на листе
gs_ga_data <- sheets_read(ss = ss, 
                          sheet = "dec", 
                          range = "A1:C10")

# install
# install.packages("devtools")
devtools::install_github("tidyverse/googlesheets4")

# lib
library(googlesheets4)

# авторизация
sheets_auth(email = "selesnow@gmail.com")

# данные для теста
my_iris   <- iris
my_mtcars <- mtcars

# создаём докс
ss <- sheets_create("demo_dox", 
                    sheets = list(iris   = head(my_iris), 
                                  mtcars = my_mtcars))
# открыть созданный Google Dox
sheets_browse(ss)

# создать новый лист
sheets_sheet_add(ss, 
                 sheet = "mtcars_new", 
                 .after = "mtcars")

# запись данных на новый лист
sheets_write(data = my_iris,
             ss = ss, 
             sheet = "iris_new")

# дописать значиения
sheets_append(data  = tail(my_iris, 20),
              ss    = ss, 
              sheet = "iris")

# получить список листок google таблицы
sheets_sheet_names(ss)

# чтение листа из гугл таблиц
ss2 <- as_sheets_id("17dRz4AYgfQvpTI6J6p9AYjrVuC-gTRj7BM4MzgAxIKY")

data <- sheets_read(ss2, 
                    sheet = "iris_new")

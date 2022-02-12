library(dplyr)
library(dbplyr)
library(dplyr, warn.conflicts = FALSE)

con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
copy_to(con, mtcars)

# обращаемся к таблице
mtcars2 <- tbl(con, "mtcars")
# пока что это всего лишь оценка вычисления
mtcars2

# dbplyr в действии
## генерация SQL запроса
summary <- mtcars2 %>% 
  group_by(cyl) %>% 
  summarise(mpg = mean(mpg, na.rm = TRUE)) %>% 
  arrange(desc(mpg))

## просмотр запроса
summary %>% show_query()

## выполнение запроса, и извлечение результата
summary %>% collect()


# автоматическая генерация подзапросов ------------------------------------
mf <- memdb_frame(x = 1, y = 2)

mf %>% 
  mutate(
    a = y * x, 
    b = a ^ 2,
  ) %>% 
  show_query()


# неизвестные dplyr функции -----------------------------------------------
# любая неизветсная dplyr функция в запрос будет прокинута как есть
mf %>% 
  mutate(z = foofify(x, y)) %>% 
  show_query()

mf %>% 
  mutate(z = FOOFIFY(x, y)) %>% 
  show_query()

# так же dbplyr умеет переводить инфиксные функции
mf %>% 
  filter(x %LIKE% "%foo%") %>% 
  show_query()


# использовать самописный SQL ---------------------------------------------
## для вставки SQL кода используйте sql()
mf %>% 
  transmute(factorial = sql("CAST(x AS FLOAT)")) %>% 
  show_query()

mf %>% 
  filter(x == sql("ANY VALUES(1, 2, 3)")) %>% 
  show_query()


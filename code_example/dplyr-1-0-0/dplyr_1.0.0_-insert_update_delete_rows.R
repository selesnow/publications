library(dplyr)

# rows_*()
## rows_update(x, y) обновляет строки в таблице x найденные в таблице y
## rows_patch(x, y) работает аналогично rows_update() но заменяет только пропущенные значение, т.е. NA
## rows_insert(x, y) добавляет строки в таблицу x из таблицы y
## rows_upsert(x, y) обновляет найденные строки в таблице x и добавляет не найденные из таблицы y
## rows_delete(x, y) удаляет строки из x найденные в таблице y.

# Создаём тестовые данные
df <- tibble(a = 1:3, b = letters[c(1:2, NA)], c = 0.5 + 0:2)
df
new <- tibble(a = c(4, 5), b = c("d", "e"), c = c(3.5, 4.5))
new

# БАзовые примеры
## добавляем новые строки
df %>% rows_insert(new)

## row_insert вернёт ошибку если мы попытаемся добавить уже существующую строку
df %>% rows_insert(tibble(a = 3, b = "c"))

## если вы хотите обновить существующее значение необходимо использовать row_update
df %>% rows_update(tibble(a = 3, b = "c"))

## но rows_update вернёт ошибку если вы попытаетесь обновить несуществующее значание
df %>% rows_update(tibble(a = 4, b = "d"))

## rows_patch заполнит только пропущенные значения по ключу
df %>% 
  rows_patch(tibble(a = 2:3, b = "B"))

## rows_upsert также вы можете добавлять новые и заменять существуюие значения функцией rows_upsert
df %>% 
  rows_upsert(tibble(a = 3, b = "c")) %>% 
  rows_upsert(tibble(a = 4, b = "d"))

# РАЗБЕРЁМ Аргументы немного более подробно
set.seed(333)

# менеджеры
managers <- c("Paul", "Alex", "Tim", "Bill", "John")
# товары
products <- tibble(name  = paste0("product_", LETTERS), 
                   price = round(runif(n = length(LETTERS), 100, 400), 0))

# функция генерации купленных товаров
prod_list <- function(prod_list, size_min, size_max) {
  
  prod <- tibble(product = sample(prod_list, size = round(runif(1, size_min, size_max), 0) ,replace = F))
  
  return(prod)
}


# генерируем продажи
sales <- tibble(id         = 1:200,
                manager_id = sample(managers, size = 200, replace = T),
                refund     = FALSE,
                refund_sum = 0)

# генерируем списки купленных товаров
sale_proucts <-
    sales %>%
      rowwise(id) %>%
      summarise(prod_list(products$name, 1, 6)) %>%
      left_join(products, by = c("product" = "name"))
  
# объединяем продажи с товарами
sales <- left_join(sales, sale_proucts, by = "id")

# возвраты
refund <- sample_n(sales, 25) %>%
          mutate( refund = TRUE,
                  refund_sum = price * 0.9) %>%
          select(-price, -manager_id) 

# отмечаем возвраты в таблице продаж
sales %>%
  rows_update(refund)

# аргумент by
result <-
  sales %>%
    rows_update(refund, by = c("id", "product"))


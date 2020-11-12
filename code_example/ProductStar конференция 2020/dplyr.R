library(RSQLite)
library(DBI)
library(sqldf)
library(dplyr)

# подключаемся к базе
con <- dbConnect(SQLite(), 'D:/Google Диск/Отчётность/Netpeak/Выступления/ProductStar конференция 2020/product.db')

# считываем данные
products <- dbReadTable(con, 'products')
sales    <- dbReadTable(con, 'sales')

# ###########################################
# Используем SQL запросы внутри R
# ###########################################
sqldf('SELECT date, country 
       FROM sales')

# ###########################################
# Манипуляция данными в R
# ###########################################

# простая выборка 
select(sales, date, country)

# объединение таблиц
result <- left_join(sales, products, by = 'product_id')

# вычисляемы столбцы
left_join(sales, products, by = 'product_id') %>%
  mutate(sale_sum     = price * count,
         discount_sum = sale_sum * discount,
         final_sum    = sale_sum - discount_sum)

# группировка и агрегация
left_join(sales, products, by = 'product_id') %>%
  mutate(sale_sum     = price * count,
         discount_sum = sale_sum * discount,
         final_sum    = sale_sum - discount_sum) %>%
  group_by(product_name) %>%
  summarise(final_sum = sum(final_sum))

# сортировка
left_join(sales, products, by = 'product_id') %>%
  mutate(sale_sum     = price * count,
         discount_sum = sale_sum * discount,
         final_sum    = sale_sum - discount_sum) %>%
  group_by(product_name) %>%
  summarise(final_sum = sum(final_sum)) %>%
  arrange(desc(final_sum))
  
# фильтрация
left_join(sales, products, by = 'product_id') %>%
  filter(between(as.Date(date), as.Date('2020-06-01'), as.Date('2020-08-31'))) %>%
  mutate(sale_sum     = price * count,
         discount_sum = sale_sum * discount,
         final_sum    = sale_sum - discount_sum) %>%
  group_by(product_name) %>%
  summarise(final_sum = sum(final_sum)) %>%
  arrange(desc(final_sum))

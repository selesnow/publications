# install.packages('purrr')
library(purrr)
library(dplyr)

# функции map_*------------------------------------------------------------
## Генерируем случайные выборки с нормальным распределением
v_sizes <- c(5, 12, 20, 30)
map(v_sizes, rnorm)

# используем доп аргументы
rnd_list <- map(v_sizes, runif, min = 10, max = 25)
# получаем вектора
map_dbl(rnd_list, mean)
# аналог в цикле
for ( i in rnd_list ) cat(mean(i), " ")

# пример с таблицами
products <- tibble(
  product_id = 1:10,
  name = c('Notebook',
           'Smarthphone',
           'Smart watch',
           'PC',
           'Playstation',
           'TV',
           'XBox',
           'Wifi router',
           'Air conditioning',
           'Tablet'),
  price = c(1000, 850, 380, 1500, 1000, 700, 870, 80, 500, 150)
)

managers <- c("Svetlana", "Andrey", "Ivan")
clients  <- paste0('client ', 1:30)

create_transaction <- function(
  transaction_id,
  products_number = 3,
  product_dict,
  counts = c(1, 3),
  dates = c(Sys.Date() - 30, Sys.Date()),
  managers,
  clients
) {

  transaction <- sample_n(product_dict, size = products_number, replace = F) %>%
                  mutate(date = sample( seq(dates[1], dates[2], by = 'day'), size = 1 ),
                         manager  = sample(managers, 1),
                         clients  = sample(clients, 1),
                         count    = sample(seq(counts[1], counts[2]), products_number, replace = T),
                         sale_sum = price * count,
                         transaction_id)

  return(transaction)

}

# генерируем 5 транзакций
map_dfr(1:5,
        create_transaction,
            products_number = sample(1:10, 1),
            product_dict = products,
            counts = c(1, 3),
            dates = c(Sys.Date() - 30, Sys.Date()),
            managers = managers,
            clients = clients,
        .id = 'transaction_id')

# функции pmap_* ----------------------------------------------------------
# для итерации по двум объектам можно использовтаь функции map2_*
x <- list(1, 1, 1)
y <- list(10, 20, 30)

map2(x, y, ~ .x + .y)

# если необходимо итерировать более чем по двум объектам используйте pmap_*
params <- tibble(
  transaction_id  = 1:3,
  products_number = c(4, 2, 6),
  product_dict    = list(products, products, products),
  counts          = list(c(1, 3), c(7, 10), c(2, 7)),
  dates           = list(c(as.Date('2021-11-01'), as.Date('2021-11-04')),
                         c(as.Date('2021-11-05'), as.Date('2021-11-08')),
                         c(as.Date('2021-11-09'), as.Date('2021-11-14'))),
  managers        = list(managers, managers, managers),
  clients         = list(clients, clients, clients)
)

tranaction_df <- pmap_df(params, create_transaction)

# функции walk ------------------------------------------------------------
# генерируем 7 транзакций
transactions <- map(1:7,
                    create_transaction,
                    products_number = sample(1:10, 1),
                    product_dict = products,
                    counts = c(1, 3),
                    dates = c(Sys.Date() - 30, Sys.Date()),
                    managers = managers,
                    clients = clients)

file_names <- paste0('transaction_', 1:7, ".csv")

walk2(
  .x = transactions,
  .y = file_names,
  write.csv
)

# функции keep и discard --------------------------------------------------
# смотрим количество товаров в транзакциях
map_dbl(transactions, ~ sum(.x$sale_sum))
# оставить транзакции с суммой более 3000
transactions %>%
  keep(~ sum(.x$sale_sum) >= 3000)
# исключить транзакции с суммой более 4000
transactions %>%
  discard(~ sum(.x$sale_sum) >= 4000)

# теперь используем в конвейере функции keep и walk
transactions %>%
  keep(~ sum(.x$sale_sum) >= 3000) %>%
  walk2(
    .x = .,
    .y = paste0('transaction_3k_', seq_along(.), ".csv"),
    write.csv
  )


# применяем несколько функций к объекту invoke ----------------------------
fun <- c('mean', 'sum', 'length')
params <- list(
  list(x   = tranaction_df$sale_sum),
  list(... = tranaction_df$sale_sum),
  list(x   = tranaction_df$sale_sum)
)

invoke_map_dbl(fun, params)


df <- tibble::tibble(
  f = c("runif", "rpois", "rnorm"),
  params = list(
    list(n = 10),
    list(n = 5, lambda = 10),
    list(n = 10, mean = -3, sd = 10)
  )
)

df

invoke_map(df$f, df$params)


# функции reduce и accumulate ---------------------------------------------
# допустим что у нас каждый менеджер имеет индивидуальный процент от продаж
# А каждый клиент персональную скидку по договору
managers_dict <- tibble(
  manager = managers,
  department = c('Sale', 'Sale', 'Marketing'),
  salary_percent = c(0.1, 0.12, 0.2)
)

clients_dict <- tibble(
  clients = clients,
  discount = runif(length(clients), min = 0, max = 0.4)
)

data_model <- list(tranaction_df, managers_dict, clients_dict)

reduce(transaction_data, left_join) %>%
  mutate(manager_bonus = sale_sum * salary_percent,
         total_sum = sale_sum - (sale_sum * discount),
         cumulate_minuses = accumulate(sale_sum - total_sum + manager_bonus, sum))

# эквивалент на чистом dplyr
tranaction_df %>%
  left_join(managers_dict) %>%
  left_join(clients_dict) %>%
  mutate(manager_bonus = sale_sum * salary_percent,
         total_sum = sale_sum - (sale_sum * discount),
         cumulate_minuses = cumsum(sale_sum - total_sum + manager_bonus))

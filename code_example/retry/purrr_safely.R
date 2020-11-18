library(purrr)

# тестовая функция
div <- function(x, y) {
  
  if ( is.na(x) ) warning("X is NA")
  return(x / y)

}

# пробуем обработку через lapply
val <- list(1, 6, 3, NA, 'k', 3)
# тест
lapply(val, div, y = 2)

# ######### #
# safely    #
# ######### #
# разделит успешные результаты и ошибки
res <- lapply(val, safely(div), y = 2)

# разбить ошибкии корректные результаты по векторам
res <- res %>% transpose()

res$result # успешные результаты
res$error  # ошибки

# ######### #
# possibly  #
# ######### #
# данная функция заменит ошибки заданным значением
res <- lapply(val, possibly(div, 0), y = 2) 

# ######### #
# quietly   #
# ######### #
# перехватыет выводимые результаты, сообщения и предупреждения
val <- list(1, 6, 3, NA, 3)
res <- map(val, quietly(div), y = 2) %>% str

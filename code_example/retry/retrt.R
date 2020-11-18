library(retry)

# тестовая функция 
fun <- function(p = 0) {
  
  x <- runif(1)
  
  if (runif(1) < 0.9) {
    
    print(paste0('X = ', x, ' is Error!'))
    
    Sys.sleep(p)
          
    stop("random error")
  }
  "Excellent"
}

# повторяем функци до тех пор пока она не выполнится
retry(fun(), when = "random error")

# добавим временной интервал между попытками
retry(fun(), when = "random error", interval = 2)

# ограничим количество попыток выполнения функции
retry(fun(), when = "random error", max_tries = 3)

# ограничим время выполнения функции
retry(fun(4), when = "random error", timeout = 2)

# проверяем результат выполнения выражения
# val это выражение которое мы проверяем
# cnd результат вычисления val
retry(fun(), until = function(val, cnd) val == "Excellent")


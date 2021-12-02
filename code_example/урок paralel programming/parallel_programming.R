# многопоточные циклы -----------------------------------------------------
# install.packages("doSNOW")
# library(doSNOW)
# library(doParallel)
library(doFuture)

# функция длительного выполнения
pause <- function(min = 1, max = 3) {
  ptime <- runif(1, min, max)

  Sys.sleep(ptime)

  out <- list(
    pid = Sys.getpid(),
    pause_sec = ptime
  )
}

test <- pause()

# используем foreach 
# итерируемся сразу по двум объектам
system.time (
  {test2 <- foreach(min = 1:3, max = 2:4) %do% pause(min, max)}
)

# сумма длительностей пауз
sum(sapply(test2, '[[', i = 'pause_sec'))

# меняем функцию собирающую результаты каждой итерации
test3 <- foreach(min = 1:3, max = 2:4, .combine = dplyr::bind_rows) %do% pause(min, max)

# параллельный режим выполнения
# создаём кластер из четырёх ядер
#cl <- makeCluster(4)
#registerDoSNOW(cl)

options(future.rng.onMisuse = "ignore")
registerDoFuture()
plan('multisession', workers = 3)

# выполняем тот же код но в параллельном режиме
system.time (
  {
    par_test1 <- 
      foreach(min = 1:3, max = 2:4, .combine = dplyr::bind_rows) %dopar% {
      pause(min, max)
    }
  }
)

# останавливаем кластер
plan('sequential')

par_test1


# многопоточный вариант функций apply -------------------------------------

library(pbapply)
library(parallel)

# создаём кластер из четырёх ядер
cl <- makeCluster(3)

# пример с pbapply
par_test2 <- pblapply(rep(1, 3), FUN = pause, max = 3, cl = cl)
# пример с parallel
par_test3 <- parLapply(rep(1, 3), fun = pause, max = 3, cl = cl)

# останавливаем кластер
stopCluster(cl)

# многопоточный purrr -----------------------------------------------------
library(furrr)

plan('multisession', workers = 3)

par_test4 <- future_map2(1:3, 2:4, pause)

# останавливаем кластер
plan('sequential')

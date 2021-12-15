library(future)
library(dplyr)

# явное и неявное объявление фьючерсов ------------------------------------
# обычное выражение
v <- {
  cat("Hello world!\n")
  3.14
}

# неявное объявление фьчерса
v %<-% {
  cat("Hello world!\n")
  3.14
}

# явное объявления фьючерса
f <- future({
  cat("Hello world!\n")
  3.14
})
v <- value(f)
resolved(f)
# фьючерс выполняет все вычисления в собственном окружении -----------------
a <- 1

x %<-% {
  a <- 2
  2 * a
}

x

a

# изменяем план выполнения фьючерса ---------------------------------------
## последовательное выполнение
plan(sequential)
pid <- Sys.getpid()
pid

a %<-% {
  pid <- Sys.getpid()
  cat("Future 'a' ...\n")
  3.14
  }
b %<-% {
  cat("Future 'b' ...\n")
  Sys.getpid()
  }
c %<-% {
  cat("Future 'c' ...\n")
  2 * a
  }

b
c
a
pid

## ассинхронное выполнение
### режим параллельно запущенных сеансов R
plan(multisession)
pid <- Sys.getpid()
pid

a %<-% {
  pid <- Sys.getpid()
  cat("Future 'a' ...\n")
  cat('pid: ', pid)
  3.14
  }
b %<-% {
  cat("Future 'b' ...\n")
  Sys.getpid()
  }
c %<-% {
  cat("Future 'c' ...\n")
  2 * a
}

b

c

a

pid

plan(sequential)

# просмотрт доступного количества потоков
availableCores()

### кластерное развёртывание
library(parallel)
cl <- parallel::makeCluster(3)
plan(cluster, workers = cl)

pid <- Sys.getpid()
pid

a %<-% {
  pid <- Sys.getpid()
  cat("Future 'a' ...\n")
  cat('pid: ', pid)
  3.14
}
b %<-% {
  cat("Future 'b' ...\n")
  Sys.getpid()
}
c %<-% {
  cat("Future 'c' ...\n")
  2 * a
}

b

c

a

pid

parallel::stopCluster(cl)


# вложенные фьчерсы -------------------------------------------------------
plan(list(multisession, sequential))
# plan(list(sequential, multisession))

# указываем количество ядер для каждого процесса
# plan(list(tweak(multisession, workers = 2), tweak(multisession, workers = 2)))
pid <- Sys.getpid()
a %<-% {
  cat("Future 'a' ...\n")
  Sys.getpid()
  }
b %<-% {
  cat("Future 'b' ...\n")
  b1 %<-% {
    cat("Future 'b1' ...\n")
    Sys.getpid()
    }
  b2 %<-% {
    cat("Future 'b2' ...\n")
    Sys.getpid()
    }
  c(b.pid = Sys.getpid(), b1.pid = b1, b2.pid = b2)
  }

pid

a
b

plan(sequential)


# обработка ошибок в фьючерсах --------------------------------------------
plan(sequential)
b <- "hello"
a %<-% {
  cat("Future 'a' ...\n")
  log(b)
  } %lazy% TRUE

a

# смотрим где именно была ошибка
backtrace(a)

# используем итерирование в параллельныъ процессах ------------------------
# тестовая функция
manual_pause <- function(x) {
  Sys.sleep(x)
  out <- list(pid = Sys.getpid(), pause = x)
  return(out)
} 

# паузы
pauses <- c(0.5, 2, 3, 2.5) 

# тест
manual_pause(2)

# активируем параллельные вычисления
plan("multisession", workers = 4)
# итерируемся
futs <- lapply(pauses, function(i) future({ manual_pause(i) }))
# проверяем статус выполнения фьючерсов
sapply(futs, resolved) 
# собираем результаты
res <- lapply(futs, value)    

dplyr::bind_rows(res)


# используем future совместно с promises ----------------------------------
library(cli)
options(cli.progress_show_after = 0, 
        cli.spinner = "dots")

# паузы
pauses.1 <- sample(1:5, 4, replace = T)
pauses.2 <- sample(2:3, 4, replace = T)
pauses.3 <- sample(3:6, 4, replace = T)

# первое длительное вычисление
plan(list(
  tweak(multisession, workers = 3), 
  tweak(multisession, workers = 4)
  )
)

val1 <- future(
  {
    futs <- lapply(pauses.1, function(i) future({ manual_pause(i) }))
    res  <- lapply(futs, value) 
    res  <- dplyr::bind_rows(res)
  }
) 

val2 <- future(
  {
    futs <- lapply(pauses.2, function(i) future({ manual_pause(i) }))
    res  <- lapply(futs, value) 
    res  <- dplyr::bind_rows(res)
  }
) 

val3 <- future(
  {
    futs <- lapply(pauses.3, function(i) future({ manual_pause(i) }))
    res  <- lapply(futs, value) 
    res  <- dplyr::bind_rows(res)
  }
) 

# ждём выполнения всех фьючерсов
cli_progress_bar("Waiting")
while ( ! (resolved(val1) | resolved(val2) | resolved(val3)) ) {
  cli_progress_update()
}

cli_progress_update(force = TRUE)

# result table
lapply(list(val1, val2, val3), value) %>% 
  bind_rows() %>%  
  mutate(main_pid = Sys.getpid()) %>% 
  print() %>%
  pull(pause) %>% 
  sum()  %>% 
  cat("\n", "Sum of all pauses: ", ., "\n")

plan(sequential)

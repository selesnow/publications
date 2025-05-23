# ������������� ����� -----------------------------------------------------
# install.packages("doSNOW")
# library(doSNOW)
# library(doParallel)
library(doFuture)

# ������� ����������� ����������
pause <- function(min = 1, max = 3) {
  ptime <- runif(1, min, max)

  Sys.sleep(ptime)

  out <- list(
    pid = Sys.getpid(),
    pause_sec = ptime
  )
}

test <- pause()

# ���������� foreach 
# ����������� ����� �� ���� ��������
system.time (
  {test2 <- foreach(min = 1:3, max = 2:4) %do% pause(min, max)}
)

# ����� ������������� ����
sum(sapply(test2, '[[', i = 'pause_sec'))

# ������ ������� ���������� ���������� ������ ��������
test3 <- foreach(min = 1:3, max = 2:4, .combine = dplyr::bind_rows) %do% pause(min, max)

# ������������ ����� ����������
# ������ ������� �� ������ ����
#cl <- makeCluster(4)
#registerDoSNOW(cl)

options(future.rng.onMisuse = "ignore")
registerDoFuture()
plan('multisession', workers = 3)

# ��������� ��� �� ��� �� � ������������ ������
system.time (
  {
    par_test1 <- 
      foreach(min = 1:3, max = 2:4, .combine = dplyr::bind_rows) %dopar% {
      pause(min, max)
    }
  }
)

# ������������� �������
plan('sequential')

par_test1


# ������������� ������� ������� apply -------------------------------------

library(pbapply)
library(parallel)

# ������ ������� �� ������ ����
cl <- makeCluster(3)

# ������ � pbapply
par_test2 <- pblapply(rep(1, 3), FUN = pause, max = 3, cl = cl)
# ������ � parallel
par_test3 <- parLapply(rep(1, 3), fun = pause, max = 3, cl = cl)

# ������������� �������
stopCluster(cl)

# ������������� purrr -----------------------------------------------------
library(furrr)

plan('multisession', workers = 3)

par_test4 <- future_map2(1:3, 2:4, pause)

# ������������� �������
plan('sequential')

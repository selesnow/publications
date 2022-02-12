library(multidplyr)

# создаЄм кластер
cluster <- new_cluster(4)
cluster

# разбиение фрейма на кластера --------------------------------------------
library(nycflights13)

flights1 <- flights %>% group_by(dest) %>% partition(cluster)
flights1

# выполн¤ем вычислени¤ в многопоточном режиме
flight_dest %>% 
  summarise(delay = mean(dep_delay, na.rm = TRUE), n = n()) %>% 
  collect()

# чтение файлов разными кластерами ----------------------------------------
# создаЄм временную папку
path <- tempfile()
dir.create(path)
# разбиваем файл по мес¤цам, 
# сохран¤¤ данные каждого мес¤ца в отдельный файл
flights %>% 
  group_by(month) %>% 
  group_walk(~ vroom::vroom_write(.x, sprintf("%s/month-%02i.csv", path, .y$month)))

# находим все файлы в директории, 
# и делим их так, чтобы каждому воркеру досталось (примерно) одинаковое количество файлов
files <- dir(path, full.names = TRUE)
cluster_assign_partition(cluster, files = files)

# считываем файлы на каждом воркере 
# и используем party_df() дл¤ создани¤ секционированного фрейма данных
cluster_send(cluster, flights2 <- vroom::vroom(files))
flights2 <- party_df(cluster, "flights2")
flights2


# глаголы dplyr -----------------------------------------------------------
flights1 %>% 
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>% 
  collect()


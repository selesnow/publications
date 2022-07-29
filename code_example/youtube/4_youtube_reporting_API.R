library(rytstat)
library(DBI)
library(RSQLite)
library(dplyr)
library(lubridate)
library(purrr)
library(forcats)
library(ggplot2)

# Авторизация
ryt_auth('r4marketing-6832@pages.plusgoogle.com')

# Доступные типы отчётоы
browseURL('https://developers.google.com/youtube/reporting/v1/reports/channel_reports')
report_types <- ryt_get_report_types()

# Создаём заданием
ryt_create_job('channel_basic_a2')

## запрашиваем список заданий
jobs <- ryt_get_job_list()

## Получить список отчётов по заданию
report_list <- ryt_get_report_list(
  job_id = '51edf40c-1c12-40e1-81dc-b402ed093c0f'
)

# Скачать данные отчёта
report_data <- ryt_get_report("https://youtubereporting.googleapis.com/v1/media/CHANNEL/yHC6R3mCCP8bhD9tPbjnzQ/jobs/51edf40c-1c12-40e1-81dc-b402ed093c0f/reports/6548226099?alt=media")

# Лучшие практики сбора данных из Reporting API
con <- dbConnect(SQLite(), 'youtube_data.db')

# Если у вас два отчёта имеют если два новых отчета имеют одинаковые значения 
# свойств startTime и endTime, импортируйте отчет с более поздним значением createTime
report_list %>% 
  group_by(startTime, endTime) %>% 
  count(sort = T)

report_list <- report_list %>% 
                group_by(startTime, endTime) %>% 
                mutate(last_create_at = max(createTime)) %>% 
                filter(createTime == last_create_at) %>% 
                select(-last_create_at) %>% 
                ungroup()

# Запишем данные первых 10ти отчётов в базу
walk(
  seq_len(nrow(report_list)) %>% tail(10),
  function(.x) {
    report <- slice(report_list, .x)
    dbWriteTable(con, name = 'reports', value = report, append = TRUE)
    report_data <- ryt_get_report(report$downloadUrl)
    report_data <- mutate(report_data, rep_id = report$id)
    dbWriteTable(con, name = 'yt_data', value = report_data, append = TRUE)
  }
)

# смотрим результат
dbListTables(con)
reports <- dbReadTable(con, "reports") 
yt_data <- dbReadTable(con, "yt_data") 


# пост обработка данных ---------------------------------------------------
# преобразуем дату
str(yt_data)
yt_data <- mutate(yt_data, date = ymd(date))
str(yt_data)

# Добавляем название видео и плейлиста
## Запрашиваем id и название видео
videos <- ryt_get_videos() %>% 
  select(id_videoId, title)
## Запрашиваем id и название плейлиста
playlists <- ryt_get_playlists(part = 'snippet', fields = 'items(id,snippet/title)')
## Объединяем данные
yt_data <- yt_data %>% 
  left_join(videos, by = c("video_id" = "id_videoId"), suffix = c("", "_video")) %>% 
  left_join(playlists, by = c("playlist_id" = "id"), suffix = c("", "_playlist"))

# Визуализация
yt_data %>% 
  group_by(title_playlist, subscribed_status) %>% 
  summarise(views = sum(views)) %>% 
  ggplot(aes(y = fct_reorder(title_playlist, views, sum), x = views, fill = subscribed_status)) +
  geom_col() +
  theme(legend.position = 'bottom')

yt_data %>% 
  group_by(date) %>% 
  summarise(watch_time_minutes = sum(watch_time_minutes)) %>% 
  ggplot(aes(y = watch_time_minutes, x = date, group = T)) +
  geom_line() + geom_point()

dbDisconnect(con)

# Дальнейший сбор данных --------------------------------------------------
con <- dbConnect(SQLite(), 'youtube_data.db')
reports <- dbReadTable(con, "reports") 

last_loading_create_date <- max(reports$createTime)
new_report_list <- ryt_get_report_list(
  job_id = '51edf40c-1c12-40e1-81dc-b402ed093c0f',
  created_after = last_loading_create_date
)

if ( !is.null(new_report_list) ) {
  
  # берём только наиболее свежие данные за каждую отчётную дату
  new_report_list <- new_report_list %>% 
    group_by(startTime, endTime) %>% 
    mutate(last_create_at = max(createTime)) %>% 
    filter(createTime == last_create_at) %>% 
    select(-last_create_at) %>% 
    ungroup()
  
  # Дописываем новые данные
  for ( i in seq_len(nrow(new_report_list)) ) {
    
    report <- slice(new_report_list, i)
    
    # проверяем не был ли ранее загружен этот отчёт
    if ( report$id %in% reports$id ) next
    
    # если ранее отчёт не был загружен, записываем его метаданные
    dbWriteTable(con, name = 'reports', value = report, append = TRUE)
    # запрашиваем данные отчёта
    report_data <- ryt_get_report(report$downloadUrl)
    # добавляем к данным пометку о том из какого отчёта они загружены
    report_data <- mutate(report_data, rep_id = report$id)
    # дописываем данные отчёта за новый период
    dbWriteTable(con, name = 'yt_data', value = report_data, append = TRUE)
    
  }
}

dbDisconnect(con)

library(rytstat)
library(dplyr)
library(ggplot2)
library(forcats)

# Авторизация
ryt_auth('r4marketing-6832@pages.plusgoogle.com')

# Базовая статистика
browseURL('https://developers.google.com/youtube/analytics/channel_reports#basic-stats-reports')

basis_stat <- ryt_get_analytics(
  start_date = '2022-06-01', end_date = '2022-06-30', 
  metrics    = c('views', 'likes', 'dislikes'), 
  dimensions = NULL
  )

# Добавим разбивку по дням
browseURL('https://developers.google.com/youtube/analytics/channel_reports#time-based-reports')
basis_by_day <- ryt_get_analytics(
  start_date = '2022-06-01', end_date = '2022-06-30', 
  metrics    = c('views', 'likes', 'dislikes'), 
  dimensions = "day"
)

## как вывести данные по видео
### запрашиваем список видео
videos <- ryt_get_videos() %>% 
          select(id_video_id, title)
### cписок id видео
video_id_list <- paste0(head(videos$id_video_id, 500), collapse = ',')
### запрос статистики с разбивкой по дням и видео
basis_by_videos <- ryt_get_analytics(
  start_date = '2022-06-01', end_date = '2022-06-30',
  dimensions = c('day', 'video'),
  metrics    = c('views', 'likes', 'dislikes'), 
  filters    = paste0('video==', video_id_list)
)
### смотрим результат
basis_by_videos

### добавляем к статистике идентификаторы видео
basis_by_videos <- left_join(basis_by_videos, videos, by = c("video" = "id_video_id"))

### Top видео по разным показателям
basis_by_videos %>% 
  group_by(title) %>% 
  summarise(views = sum(views)) %>% 
  arrange(desc(views)) %>% 
  slice_head(n = 5) 

basis_by_videos %>% 
  group_by(day) %>% 
  summarise(views = sum(views)) %>% 
  arrange(desc(views)) %>% 
  slice_head(n = 5) 

### визуализация
### топ по просмотрам
basis_by_videos %>% 
  group_by(title) %>% 
  summarise(views = sum(views)) %>% 
  arrange(desc(views)) %>% 
  slice_head(n = 10) %>% 
  ggplot(aes(x = views, y = fct_reorder(title, views, median), fill = views)) +
  geom_col()
### топ по лайкаам
basis_by_videos %>% 
  group_by(title) %>% 
  summarise(likes = sum(likes)) %>% 
  arrange(desc(likes)) %>% 
  slice_head(n = 10) %>% 
  ggplot(aes(x = likes, y = fct_reorder(title, likes, median), fill = likes)) +
  geom_col()

### динамика по дням
basis_by_videos %>% 
  group_by(day) %>% 
  summarise(views = sum(views)) %>% 
  ggplot(aes(x = day, y = views, group = T)) +
  geom_point() + geom_line() +
  theme(axis.text.x = element_text(angle = 90, size = 7))

# --------------------------------------
# Пороговые значения
basis_stat_video <- ryt_get_analytics(
  start_date = '2022-06-01', end_date = '2022-06-30', 
  metrics    = c('views', 'likes', 'dislikes'), 
  dimensions = NULL, 
  filters = 'video==nUd_NVqIzag'
)
basis_stat_video

basis_stat_video_country <- ryt_get_analytics(
  start_date = '2022-06-01', end_date = '2022-06-30', 
  metrics    = c('views', 'likes', 'dislikes'), 
  dimensions = 'country', 
  filters = 'video==nUd_NVqIzag'
)
basis_stat_video_country

basis_stat_video_ru <- ryt_get_analytics(
  start_date = '2022-06-01', end_date = '2022-06-30', 
  metrics    = c('views', 'likes', 'dislikes'), 
  dimensions = NULL, 
  filters = 'video==nUd_NVqIzag;country==ru'
)

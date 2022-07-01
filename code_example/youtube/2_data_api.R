library(rytstat)

# авторзация
ryt_auth()

# Загрузка объектов
## канал
channel <- ryt_get_channels()
## Последние действия на вашем канале
channel_activies <- ryt_get_channel_activities()
## Список видео
videos <- ryt_get_videos()
## Детальная информация по вашим видео
videos_details <- ryt_get_video_details(video_id = videos$id_video_id)
## Общая статистика по видео (части)
videos_stats_1 <- ryt_get_video_details(
  video_id = videos$id_video_id, 
  part = c("snippet", "statistics")
  )
## Тоже самое но без  kind etag
videos_stats_2 <- ryt_get_video_details(
  video_id = videos$id_video_id,
  part = c("snippet", "statistics"),
  fields = "items(id,snippet,statistics)"
)
## берём только id, название и к-во просмотров
videos_stats_3 <- ryt_get_video_details(
  video_id = videos$id_video_id,
  part = c("snippet", "statistics"),
  fields = "items(id,snippet/channelId,snippet/title,statistics/viewCount)"
)
## берём только id, название и к-во просмотров
videos_stats_4 <- ryt_get_video_details(
  video_id = videos$id_video_id,
  part = c("snippet", "statistics"),
  fields = "items(id,snippet(channelId,title),statistics(viewCount))"
)

## поиск
# поиск видео по запросу
search_res_videos <- ryt_search(
  type            = 'video',
  q               = 'r language tutorial',
  published_after = '2022-03-01T00:00:00Z',
  published_before = '2022-06-01T00:00:00Z',
  max_results     = 10
)

# поиск плейлистов по запросу
search_res_playlists <- ryt_search(
  type             = 'playlist',
  q                = 'r language tutorial',
  published_after  = '2022-03-01T00:00:00Z',
  published_before = '2022-06-01T00:00:00Z',
  max_results      = 50
)

# поиск каналов по запросу
search_chn <-  ryt_search(
  type   = 'channel',
  q      = 'R4marketing',
  fields = 'items(snippet(title,channelId))'
)

# поиск видео определённого канала
search_chn <-  ryt_search(
  type   = 'channel',
  q      = 'R4marketing',
  fields = 'items(snippet(title,channelId))'
)

# поиск по своим видео
search_own_dplyr_videos <- ryt_search(
  type             = 'video',
  for_mine         = TRUE,
  q                = 'dplyr'
)

# Search videos in the channel by query and channel id
search_channel_dplyr_videos <- ryt_search(
  type       = 'video',
  q          = 'dplyr',
  channel_id = "UCyHC6R3mCCP8bhD9tPbjnzQ"
)

## Загрузка в параллельном режиме
library(parallel)
cl = makeCluster(4)
videos_details <- ryt_get_video_details(video_id = videos$id_video_id, cl = cl)
stopCluster(cl)

## получить список плейлистов
playlists <- ryt_get_playlists()
## Получить ветки комментариев к видео
comments <- ryt_get_comments(video_id = 'vVFFtgcBp-w')

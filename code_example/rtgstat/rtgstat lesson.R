# install.packages('rtgstat')
library(rtgstat)
library(ggplot2)
library(forcats)

# авторизация
tg_auth('ВАШ TGStat API токен')

# Замените на ID вашего канала
tg_set_channel_id('R4marketing')

# Статистика канала
stat          <- tg_channel_stat()
subscribers   <- tg_channel_subscribers()
views         <- tg_channel_views()
avg_post_viev <- tg_channel_avg_posts_reach()
err           <- tg_channel_err()

# Визуализация динамики ERR
ggplot(err, aes(x = as.Date(period), y = err, group = 1)) +
  geom_point() +
  geom_line()

# Статистика публикации
some_post     <- tg_post('https://t.me/datalytx/637')
posts         <- tg_channel_posts()
post_stat     <- tg_post_stat(post_id = posts$link[1])
post_views    <- post_stat$views
post_forwards <- post_stat$forwards
post_mentions <- post_stat$mentions


# Визуализация Top постов по просмотрам
ggplot(posts, aes(x = fct_reorder(link, views, max), y = views)) +
  geom_col(aes(fill=-views)) +
  coord_flip() +
  labs(x = 'post_id', y = 'views count', title = 'Post Views Rating')

# Упоминания
mentions_dinamics <- tg_mentions_by_period(query = 'Алексей Селезнёв')
mentions_channels <- tg_mentions_by_channels(query = 'Алексей Селезнёв')
mentions          <- mentions_channels$items
m_channels        <- mentions_channels$channels

# Визуализация Top постов по просмотрам
ggplot(mentions_dinamics, aes(x = as.Date(period), y = mentions_count)) +
  geom_col(aes(fill = -(views_count / mentions_count)))

# Справочники
langs      <- tg_languages()
countries  <- tg_countries()
categories <- tg_categories()

# Поиск каналов
channels   <- tg_channels_search(
  query    = 'analytics', 
  country  = 'ru',
  category = 'tech', 
  search_by_description = 1
)

# Квота API
tg_api_usage()

# Опции
tg_set_api_quote_alert_rate(0.99)
tg_api_usage()

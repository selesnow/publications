library(rvkstat)

# получить список групп
my_groups <- vkGetUserGroups()

# статистика группы
group_stat <- vkGetGroupStat(
  group_id  = 119709976, 
  date_from = '2021-01-01', 
  date_to   = '2021-01-15'
  )

# группировать по недел¤м
group_stat_weekly <- vkGetGroupStat(
  group_id = 119709976, 
  interval = 'week', 
  intervals_count = 4
)

# группировать по мес¤цам
group_stat_monthly <- vkGetGroupStat(
  group_id = 119709976,
  interval = 'all'
)

# по возрасту посетителей
age <- vkGetGroupStatAge(
  group_id  = 119709976, 
  date_from = '2021-01-01', 
  date_to   = '2021-01-15'
)

# по полу посетителей
gender <- vkGetGroupStatGender(
  group_id  = 119709976, 
  date_from = '2021-01-01', 
  date_to   = '2021-01-15'
)

# по полу и возрасту
gender_age <- vkGetGroupStatGenderAge(
  group_id  = 119709976, 
  date_from = '2021-01-01', 
  date_to   = '2021-01-15'
)

# по городу
city <- vkGetGroupStatCity(
  group_id  = 119709976, 
  date_from = '2021-01-01', 
  date_to   = '2021-01-15'
)

# по стране
country <- vkGetGroupStatCountries(
  group_id  = 119709976,
  date_from = '2021-01-01', 
  date_to   = '2021-01-15'
)


# ¬изуализаци¤
library(ggplot2)

ggplot(age,
       aes(x = period_from, y = visitors) ) +
geom_col( aes(fill = age), position = position_fill() )

ggplot(age,
       aes(x = period_from, y = visitors) ) +
  geom_col( aes(fill = age), position = position_stack() )

ggplot(gender,
       aes(x = period_from, y = visitors) ) +
  geom_col( aes(fill = gender), position = position_stack() )

library(readr)
library(dplyr)

# загрузка данных
salary <- read_csv("D:\\Google Диск\\Курс 20 шагов от Excel до языка R\\materials\\lesson_8\\salary_analysis.csv")

# структура таблицы
str(salary)

# ######################
# Простые оконные функции
# ######################

# добавляем суммарную зарплату по отделу
salary <- salary %>% 
            group_by(departmen, month) %>%
            mutate(total_dep = sum(total))

# какой процент зп получает каждый сотрудник в рамках отдела
salary <- salary %>%
            mutate(staff_rate = total / total_dep)

# вывести по каждому сотруднику разницу от средней зарплаты по отделу
# в рамках месяца
salary %>%
  group_by(departmen, month) %>%
  mutate(from_dep_avg = total / mean(total))


# ######################
# Ранжирующие оконные функции
# ######################

# сотрудники имеющие наибольшую долю от ФОТ своего отдела по месяцам
rating_by_dap_rate <- 
  salary %>%
    group_by(month) %>%
    mutate(rank = min_rank(staff_rate)) %>%
    filter(rank ==  max(rank)) %>%
    arrange(month)

# сотрудники получившие максимальный бонус в рамках каждого месяца
salary %>%
  group_by(month) %>%
  mutate(rank = dense_rank(bonus)) %>%
  filter(rank ==  max(rank)) %>%
  arrange(month)

# сотрудники получившие макисмлаьные бонусы за 2019 год
# в по отделам
salary %>%
  filter(grepl("^2019", month)) %>%    # фильтр по гожу
  group_by(name_dep, name_emploee) %>% # группировка по отделу и сотруднику
  summarise(bonus = sum(bonus)) %>%    # агрегация данных
  group_by(name_dep) %>%               # создание окна по отделу
  mutate(max_bonus = max(bonus)) %>%   # расчёт максимального бонуса в рамках отдела
  filter(bonus == max_bonus)           # оставляем тех чей бонус равен максимальному

# ######################
# Смещающие оконные функции
# ######################

# Вывести рост зарплаты каждого сотрудника относительно прошлого месяца
salary_grow <-
  salary %>%
    arrange(month) %>%      # задаём сортировку по месяцам
    group_by(id) %>%        # разбиваем таблицу на окна по сотрудникам
    mutate(total_grow_rate = ( total - lag(total) ) / total ) # расчёт роста

# вывести сотрудников с максимальным ростом зарплат
# в каждом месяце
test <-
salary %>%
  arrange(month) %>%      # задаём сортировку по месяцам
  group_by(id) %>%        # разбиваем таблицу на окна по сотрудникам
  mutate(total_grow_rate = ( total - lag(total) ) / total  ) %>%  # расчёт роста
  group_by(month) %>%
  filter(total_grow_rate == max(total_grow_rate, na.rm = T))
  
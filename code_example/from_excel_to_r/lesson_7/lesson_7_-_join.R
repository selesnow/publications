library(readxl)
library(dplyr)
library(tidyr)
library(stringr)

###
# Задача: собрать таблицу с бонусами и ставками за 2 месяца
###

# скачиваем файл из интернета
download.file("https://github.com/selesnow/publications/blob/master/code_example/from_excel_to_r/lesson_7/salary.xlsx?raw=true", 
              destfile = "salary.xlsx", 
              mode = "wb")

# считываем листы
sheets <- excel_sheets("salary.xlsx")

# считываем книгу
excel_book <- sapply( sheets, 
                        read_excel, 
                        path = "salary.xlsx" )

# смотрим объект
str(excel_book)

# смотрим содержание листа staff
excel_book[['staff']]

# #######
# ВЕРТИКАЛЬНОЕ ОБЪЕДИНЕНИЕ ТАБЛИЦ
# создаём две отдельные таблицы со ствками
# #######
staff_jan <- mutate(excel_book[['staff']], month = "2020.01") 
staff_feb <- mutate(excel_book[['staff']], month = "2020.02")

# объединяем таблицы
staff_salary <- bind_rows( staff_jan, staff_feb )

# объединяем бонусы
staff_bonuses <- bind_rows(excel_book[["bonus_jan"]], 
                           excel_book[["bonus_feb"]]) %>%
                 mutate(month = format(date, "%Y.%m")) %>%
                 group_by(employee_id, month) %>%
                 summarise_at("bonus", sum)
                
# объединяем штрафы
staff_payroll <- bind_rows(excel_book[["payroll_jan"]], 
                           excel_book[["payroll_feb"]]) %>%
                 mutate(month = format(date, "%Y.%m")) %>%
                 group_by(employee_id, month) %>%
                 summarise_at("sum", sum)

# #######
# ГОРИЗОНТАЛЬНОЕ ОБЪЕДИНЕНИЕ ТАБЛИЦ
# #######
salary_analysis <- left_join(staff_salary, staff_bonuses, 
                             by = c("id" = "employee_id", "month")) %>%
                   left_join(staff_payroll,
                             by = c("id" = "employee_id", "month")) %>%
                   rename(payroll = sum) %>%
                   mutate_at(c("bonus", "payroll"), replace_na, 0) %>%
                   mutate(total = rate + bonus - payroll)

# добавим данные об отделе
salary_analysis <- left_join(salary_analysis, excel_book[['departmen']],
                             by = c("departmen" = "id"), suffix = c("_emploee", "_dep"))

# anti join и semi join
# сотрудники которые получили штраф и в январе и в феврале
semi_join(excel_book[['payroll_jan']], excel_book[['payroll_feb']], 
          by = "employee_id") %>%
  select(employee_id) %>%
  distinct() %>%
  left_join(excel_book[['staff']], 
            by = c("employee_id" = "id"))

# сотрудники которые получили штраф в январе но не получили феврале
anti_join(excel_book[['payroll_jan']], excel_book[['payroll_feb']], 
          by = "employee_id") %>%
  select(employee_id) %>%
  distinct() %>%
  left_join(excel_book[['staff']], 
            by = c("employee_id" = "id"))

# сотрудники которые получили и штраф и бонус в январе
semi_join(excel_book[['payroll_jan']], excel_book[['bonus_feb']], 
          by = "employee_id") %>%
  select(employee_id) %>%
  distinct() %>%
  left_join(excel_book[['staff']], 
            by = c("employee_id" = "id"))

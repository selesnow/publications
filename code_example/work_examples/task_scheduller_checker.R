# установка требуемых пакетов
# install.packages("taskscheduleR")
# install.packages("dplyr")
# install.packages("htmlTable")
# install.packages("stringr")
# install.packages("readr")

# подключение пакетов
library(taskscheduleR) # загрузка списка задач
library(dplyr)         # манипуляция с данными
library(htmlTable)     # перевод дата фрейма в формат HTML таблицы
library(mailR)         # отправка электронных писем
library(stringr)       # работа со строками
library(readr)         # преобразование даты

# переменные 
os_username    <- "имя пользователя" # имя пользоватя создавшего задачу в планировщике
days_window    <- 3                  # количество дней за которые надо проверить список запускаемых задач
email.username <- "petr@gmail.com"   # ваша gmail почта
email.password <- "пароль от почты"  # пароль от почты

# запрашиваем список задач и фильтруем его
task <- taskscheduler_ls() %>%
        mutate(`Last Run Time` = parse_datetime(`Last Run Time`, format = "%m/%d/%Y %I:%M:%S %p")) %>%
        filter(str_detect(string = tolower(Author), os_username) & 
               `Last Result` != "0" & 
               between(as.Date(`Last Run Time`), Sys.Date() - days_window , Sys.Date()) & 
               `Scheduled Task State` == "Enabled" &
               Status != "Running") %>%
               unique()

# проверяем есть ли задачи работа которых завершилась аварийно
if ( nrow(task) > 0 ) {
  
  # Создаём HTML таблицу
  html_tab <- select(task,
                     TaskName,
                     `Last Run Time`,
                     Status,
                     `Task To Run`) %>%
              htmlTable()
  
  # отправляем письмо
  send.mail(from     = "Task Schedulet",
            to       = email.username, 
            subject  = str_interp("Задачи которые завершились аварийно ${format.Date(Sys.Date(), '%d %B %Y')}"),
            body     = html_tab,
            encoding = "utf-8",
            inline   = TRUE,
            html     = TRUE,
            smtp     = list(host.name = "smtp.gmail.com", 
                            port      = 465, 
                            user.name = str_replace(email.username, "(.*)@(.*)", "\\1"), 
                            passwd    = email.password, 
                            ssl       = TRUE),
            authenticate = TRUE,
            send = TRUE)
}

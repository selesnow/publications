library(DBI)
library(RSQLite)
library(dplyr)
library(stringr)

# подключение к базе
con <- dbConnect(SQLite(), r'(C:\my_develop_workshop\r4marketing_contest_bot_1\contest_bot.db)')

# таблица ссылок
data <- dbReadTable(con, 'links')

# отключаемся от базы
dbDisconnect(con)

# к-во участников
nrow(data)

# список ссылок
cat(paste0(str_pad(1:nrow(data),width = 2, 'right') , ":", data$link, collapse = "\n"))

# выбор победителя
winner <- sample_n(data, 1)

# открываем ссылку победителя
browseURL(winner$link)


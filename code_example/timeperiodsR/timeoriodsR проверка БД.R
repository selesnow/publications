library(timeperiodsR)
library(RSQLite)
library(googleAnalyticsR)
library(stringr)
library(zoo)

# период
period <- last_n_days(n = 15)

# подключаемся к БД
con <- dbConnect(SQLite(), 
                 "my_smalldb.db")

# запрашиваем данные из БД на проверку
query <- str_interp("SELECT DISTINCT date FROM gadata WHERE date BETWEEN '${period$start}' AND '${period$end}'")
dates_in_db <- as.Date(dbGetQuery(con, query)$date)

# определяем каких дат нет
lose_dates <- dates_in_db %right_out% period

# по очереди загружаем даты которых нет 
res  <- lapply(lose_dates, 
          function(x)
            google_analytics(170507937, 
                             date_range =  c(x, x), 
                             metrics    = "sessions", 
                             dimensions = c("date", "source")
                             )
          )

# объединяем данные в таблицу
res <- do.call(rbind, res)
res$date <- as.character(res$date)

# дописываем данные в БД
dbWriteTable(con, 
             "gadata",
             res, 
             append = TRUE)

# повторная проверка
query <- str_interp("SELECT DISTINCT date FROM gadata WHERE date BETWEEN '${period$start}' AND '${period$end}'")
dates_in_db <- as.Date(dbGetQuery(con, query)$date)

lose_dates <- dates_in_db %right_out% period

#install.packages('lgr')
library(lgr)

# работчая директория
setwd("D:/logger_lesson")
lgr
# встроенный логгер
lgr$info("Информация")
lgr$warn("Предупреждение")

# создаём собственный логгер
mylg <- get_logger('my_firts_logger')

# создаём обработчик, пишущий логи в текстовый файл
file_appender <- AppenderFile$new('logfile.txt')
# добавляем обработчик в логгер
mylg$add_appender(file_appender, name = 'txt_appender')

# ######################## #
# уровень детализации      #
# ######################## #
get_log_levels()

# смотрим наш логгер
mylg

# отправим сообщение уровнем ниже чем info
mylg$info("Информация №2")
mylg$debug("Дебаг сообщение")
mylg$trace("Trace сообщение")

# посмотреть журнал
mylg$appenders$txt_appender$show()

# меняем уровень детализации логгера
mylg$set_threshold('trace')

# отправим сообщение уровнем ниже чем info
mylg$info("Информация №2")
mylg$debug("Дебаг сообщение")
mylg$trace("Trace сообщение")

# посмотреть журнал
mylg$appenders$txt_appender$show()

# меняем уровень детализации обработчика
mylg$appenders$txt_appender$set_threshold('info')

# отправим сообщение уровнем ниже чем info
mylg$info("Информация №3")
mylg$debug("Дебаг сообщение 3")
mylg$trace("Trace сообщение 3")

# посмотреть журнал
mylg$appenders$txt_appender$show()

# ######################## #
# json обработчик          #
# ######################## #
# создаём json обработчик
json_appender <- AppenderJson$new('mylog.json')

# добаляем json обработчик в наш логгер
mylg$add_appender(json_appender, name = 'json_appender')

# сотрим логгер
mylg

# задаём уровень нового обработчика
mylg$appenders$json_appender$set_threshold('error')

# отправляем данные с кастомными полями
mylg$info("Информация №3 - %s", "my text")
mylg$debug("Дебаг сообщение")
mylg$error("Error message", custom_data = 'my data', my_field = 'Alexey')

# смотрим json log
mylg$appenders$json_appender$show()
mylg$appenders$json_appender$data

# ######################## #
# запись лога в БД         #
# ######################## #
# создаём json обработчик
devtools::install_github('s-fleck/lgrExtra')
library(lgrExtra)
library(RSQLite)

# создаём новый логгер
lg <- get_logger_glue('database_logger')

# создаём макет таблицы в базе данных
lo <- LayoutDbi$new(
  col_types = c(
    level       = "integer",
    timestamp   = "text",
    logger      = "text",
    msg         = "text",
    caller      = "text",
    custom_data = "text",
    my_field    = "text"
  )
)

# создаём обработчик
db_appender <- AppenderDbi$new(
  layout      = lo,
  conn        = DBI::dbConnect(RSQLite::SQLite(), 'log.db'),
  table       = "log_table",
  buffer_size = 0,
  threshold   = 'fatal'
)

# добавляем в наш логгер обработчик
mylg$add_appender( 
  name = 'db', 
  db_appender)

# пишем лог
mylg$info("Info 4")
mylg$error('Error 2', custom_data = 'my data', my_field = 'Alexey')
mylg$fatal("Fatal error", custom_data = 'my data 2', my_field = 'John')

# ######################## #
# фильтры                  #
# ######################## #
# создаём фильтрующую функцию
filter_fun <- function(event) {
  grepl( pattern = 'special', 
         event$custom_data, 
         ignore.case = TRUE )
}

# добавляем на основе созданной функции фильтр
mylg$appenders$db$add_filter(filter_fun, name = 'spec_filter')

# пишем лог
mylg$fatal("Just Fatal error", custom_data = 'my data 2 ', my_field = 'John')
mylg$fatal("Just Fatal error", custom_data = 'my special data', my_field = 'Lion')

# смотрим лог
mylg$appenders$db$data

# ######################## #
# tryCatch                 #
# ######################## #

tryCatch(expr = {
 
  mylg$info("Start code", custom_data = 'FALSE')
  
  mylg$debug("Calculate X", custom_data = 'FALSE')
  x <- 10 * runif(1, 1, 10)
  
  mylg$debug("Calculate y", custom_data = 'FALSE')
  y <- x ** runif(1, 1, 10)
  
  mylg$debug("calculate last_val", custom_data = 'FALSE')
  last_val <- unlist(sample(list(1, 5, "o"), 1))
  
  mylg$info("last val is %s", last_val, custom_data = 'FALSE')
  
  mylg$debug("calculate result", custom_data = 'FALSE')
  res <- x / y / last_val
  
  mylg$info("Result is %s",res, custom_data = 'FALSE')
}, 
  error   = function(err) mylg$fatal(err$message, custom_data = 'my special data'), 
  warning = function(warn) mylg$warn(warn$message, custom_data = 'my special data'),
  finally = {
    mylg$info("End of code", custom_data = 'FALSE')
  })

mylg$appenders$txt_appender$show()

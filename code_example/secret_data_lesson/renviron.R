# создание и редактирование файла .Renviron
usethis::edit_r_environ(scope = 'project')

# чтение переменных среды
Sys.getenv('host')

# подключение к базе данных
con <- DBI::dbConnect(
  RMariaDB::MariaDB(),
  username = Sys.getenv('user'),
  password = Sys.getenv('pwd'),
  host     = Sys.getenv('host'),
  dbname   = Sys.getenv('database')
)

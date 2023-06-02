library(keyring)

# создать запись с учётными данными
key_set_with_value(
  service  = 'my_service', 
  username = 'alex',
  password = 'mypass'
)

# посмотреть созданные записи
key_list()

# использовать запись
pass <- key_get('my_service', 'alex')
pass

# подключение к базе данных
con <- DBI::dbConnect(
  RMariaDB::MariaDB(),
  username = 'alex',
  password = key_get('my_service', 'alex'),
  host     = 'localhost',
  dbname   = 'main_db'
)

# удалить запись
key_delete('my_service', 'alex')
key_list()

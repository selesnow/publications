# configr -----------------------------------------------------------------
library(configr)

# считываем конфиги разных форматов
cfg_yml <- read.config('config.yml')
cfg_ini <- read.config('config.ini')
cfg_jsn <- read.config('config.json')

# смотрим структуру конфига
lobstr::tree(cfg_ini)

# сравниваем результат
waldo::compare(cfg_yml, cfg_ini)
waldo::compare(cfg_yml, cfg_jsn)

# подключение к базе данных
con <- DBI::dbConnect(
  RMariaDB::MariaDB(),
  username = cfg_ini$database$user,
  password = cfg_ini$database$pwd,
  host     = cfg_ini$database$host,
  dbname   = cfg_ini$database$database
)


# где хранить конфиги -----------------------------------------------------
library(rappdirs)

# получить путь к папке с конфигами
config_dir <- user_config_dir(
  appname   = 'configs', 
  appauthor = 'alex'
)

normalizePath(config_dir, mustWork = F)


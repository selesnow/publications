# vk auth
# install.packages('rvkstat')
library(rvkstat)

# простая авторизация
vkAuth(username   = 'selesnow', 
       token_path = 'c:/vkauth_data')

# запрашиваем список аккаунтов
accounts <- vkGetAdAccounts(username   = 'selesnow', 
                            token_path = 'c:/vkauth_data')

# задаём опции
vkSetUsername('selesnow')
vkSetTokenPath('c:/vkauth_data')

# запрашиваем список аккаунтов
accounts_2 <- vkGetAdAccounts()


# авторизация через собственное приложение --------------------------------
vkAuth(app_id     = ,
       app_secret = )

# переменные среды и файл .Renviron ---------------------------------------
# переменные среды
Sys.setenv(
  RVK_USER = "selesnow", 
  RVK_TOKEN_PATH = "c:/vkauth_data"
)

# подключение пакета
library(rvkstat)

# запрашиваем список аккаунтов
accounts_3 <- vkGetAdAccounts()

# файл .Renviron
file.edit(path.expand(file.path("~", ".Renviron")))

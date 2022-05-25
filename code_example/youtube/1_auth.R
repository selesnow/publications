library(rytstat)

# проверка авторизованы мы или нет
ryt_has_token()

# Дефолтные параметры -----------------------------------------------------
# простая авторизация с параметрами по умолчанию
ryt_auth('selesnow@gmail.com')

# посмотреть под каким пользователем мы автоизовались
ryt_has_token()
ryt_user()

# деавторизация
ryt_deauth()

# указываем пользователя
ryt_auth("r4marketing-6832@pages.plusgoogle.com")

# Собственный OAuth клиент ------------------------------------------------
ryt_auth_configure(path = 'C:/yt_auth/app.json')
ryt_auth("selesnow@gmail.com")

# посмотреть под каким пользователем мы автоизовались
ryt_user()
ryt_auth_cache_path()


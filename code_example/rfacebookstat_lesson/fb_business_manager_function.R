library(rfacebookstat)

# Получить список доступных бизнес менеджеров
bm <- fbGetBusinessManagers()

# установка опции
options(rfacebookstat.business_id = bm$id)

# получить список пользователей бизнес менеджера
bm_users <- fbGetBusinessManagersUsers()

# получить список достпных аккаунтов для пользователя
user_accounts <- fbGetBusinessUserAdAccounts(
                      business_users_id = "133486951426870"
                      )

library(rgoogleads)

# простейший способ авторизации
gads_auth('alsey.netpeak@gmail.com')

# настройка конфигурации авторизации
gads_auth_configure(
  path = 'C:/gads_auth_data/gads_oauth.json'
    )

gads_auth('alsey.netpeak@gmail.com')

# иерархия аккаунтов
top_accounts <- gads_get_accessible_customers()

# опции
gads_set_login_customer_id(1754107253)

# запрос все иерархии аккаунтов
account_hie <- gads_get_account_hierarchy()


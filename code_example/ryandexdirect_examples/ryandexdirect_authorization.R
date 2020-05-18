library(ryandexdirect)

# авторизация
yadirAuth('selesnow', 
          TokenPath = 'yd_auth')

# запрашиваем список кампаний
camp <- yadirGetCampaign(Logins = 'selesnow', 
                         TokenPath = 'yd_auth')

# #############################
# опции пакета
options(ryandexdirect.user = 'selesnow',
        ryandexdirect.token_path = 'C:/Users/Alsey/Documents/yd_auth')

# запрашиваем список кампаний
camp <- yadirGetCampaign()

# #############################
# запрашиваем список логинов
options(ryandexdirect.token_path = 'C:\\my_develop_workshop\\ppc_digest\\token_yandex')
yadirGetLogins()

# запрашиваем список кампаний
irina.camp <- yadirGetCampaign()

# переключаемся на другой аккаунт
yadirSetLogin('ooo.mystery')
mystery.camp <- yadirGetCampaign()

# переключаемся на агентский аккаунт
yadirSetAgencyAccount('vipman.netpeak')

# запрашиваем список клиентов
vipman.clients <- yadirGetClientList()

# переключаемся на клиента агентского аккаунта
vipman.clients$Login
yadirSetLogin('q-page-direct')

# запрашиваем список реклмных кампаний
q_page.camp <- yadirGetCampaign()

# #############################
# переключаемся на другой аккаунт
yadirSetAgencyAccount(NULL)
yadirSetLogin('ooo.mystery')
mystery.camp <- yadirGetCampaign()

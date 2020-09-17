library(ryandexdirect)
library(telegram.bot)
library(stringr)

# установка аккаунта
yadirSetLogin('irina.netpeak')

# запрос баланса
balance <- yadirGetBalance()

# запрашиваем траты за последние 7 дней
spent <- yadirGetReport(DateRangeType = 'LAST_7_DAYS',
                        FieldNames    = 'Cost')

# расчитываем на сколько дней хватит средств
days <- floor(as.numeric(balance$Amount) / (spent$Cost / 7))

# отправляем сообщение с балансом, если средств хватит менее чем на 3 дня
if { days <= 3 } {
  
  bot <- Bot()
  
  msg <- str_glue('Остаток средств на вашем счету в Яндекс.Директ {spent$Cost}, 
                  при текущих тратах баланс будет израсходован через {days} дн.')
  
  bot$sendMessage(, msg, 'HTML')
  
}
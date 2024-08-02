library(telegram.bot)
library(httr)
library(jsonlite)

# Метод запроса курса валют
get_cur_rate <- function(bot, update, args) {
  
  currency_code <- toupper(args)
  api_key <- Sys.getenv('
                        ')
  url     <- paste0("https://api.exchangerate-api.com/v4/latest/USD?apikey=", api_key)
  
  response <- GET(url)
  data <- fromJSON(content(response, "text"))
  
  if (!currency_code %in% names(data$rates)) {
    bot$sendMessage(chat_id = update$message$chat_id, text = paste0(args, " is Invalid currency code."))
    return(NULL)
  }
  
  rate <- data$rates[[currency_code]]
  message <- sprintf("Курс %s к USD: %f", currency_code, rate)
  bot$sendMessage(chat_id = update$message$chat_id, text = message)
  
}

# Создаём Webhook
webhook <- Webhook(
  webhook_url = Sys.getenv('WEBHOOK_URL'), 
  token       = bot_token('CURBOT'), 
  verbose     = TRUE
)

# Добавляем обработчики
webhook <- webhook + CommandHandler("get_cur_rate", get_cur_rate, pass_args = T)

# Запускаем Webhook
webhook$start_server(
  host = "0.0.0.0",
  port = as.integer(Sys.getenv("PORT", 8080))
)

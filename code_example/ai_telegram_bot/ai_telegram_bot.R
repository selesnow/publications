library(telegram.bot)
library(ellmer)

# Создаём глобальную переменную для хранения сессий
# в которую будут добавляться новые чаты
sessions <- list()

# Handler для команды /start
start_handler <- function(bot, update) {
  
  chat_id <- update$message$chat$id
  
  # Создаём новый чат-объект для пользователя с уникальным чатом
  chat <- chat_gemini(
    system_prompt = "Ты специалист по разработке кода и анализу данных на языке на языке R, 
                     в этом чате помогаешь с разработкой кода на R. Твои ответы должны занимать не более 1500 символов."
  )
  
  # Сохраняем чат-объект в глобальной переменной sessions
  sessions[[as.character(chat_id)]] <<- chat
  
  bot$sendMessage(chat_id = chat_id, text = "Здравствуйте, чем могу вам помочь?")
  
}

# Handler для текстовых сообщений
message_handler <- function(bot, update) {
  
  chat_id <- update$message$chat$id
  
  # Получаем чат-объект для пользователя
  chat <- sessions[[as.character(chat_id)]]

  # Если чат не найден то просим выполнить команду start для его запуска
  if (is.null(chat)) {
    bot$sendMessage(chat_id = chat_id, text = "Используйте /start для начала AI чата.")
    return(NULL)
  }
  
  # текст запроса
  user_message <- update$message$text
  
  # отправляем запрос пользователя в LLM
  response <- chat$chat(user_message, echo = FALSE)
  
  # отправляем в чат полученный от LLM ответ
  bot$sendMessage(
    chat_id = chat_id, 
    text = response,
    parse_mode = 'markdown'
  )

}

# Инициализируем бот и добавляем обработчики
updater <- Updater(bot_token('TEST'))

# Обработчики
h_start <- CommandHandler("start", start_handler)
h_msgs  <- MessageHandler(message_handler, MessageFilters$text)

updater <- updater + h_start + h_msgs

# Запускаем бота
updater$start_polling()

library(ragnar)
library(tidyverse)
library(ellmer)

# 1. Создание базы знаний -------------------------------------------------

# задаём URL документации
base_url <- "https://selesnow.github.io/build_telegram_bot_using_r/"

# считываем все ссылки исключая не нужные
pages <- ragnar_find_links(base_url) %>% 
         .[stringr::str_detect(., 'https://selesnow.github.io/build_telegram_bot_using_r')]

# задём путь хранилища
store_location <- "tgbot_rag.duckdb"

# создаём хранилище
store <- ragnar_store_create(
  store_location,
  embed = \(x) ragnar::embed_google_gemini(x)
)

# разбиваем каждую отдельную страницу на чанки
# и записываем в хранилище
for (page in pages) {
  message("ingesting: ", page)
  chunks <- page |> read_as_markdown() |> markdown_chunk()
  ragnar_store_insert(store, chunks)
}

# строим индекс для поиска
ragnar_store_build_index(store)

# инструмент проверки хранилища
ragnar_store_inspect(store)


# 2. Обращение к базе знаний ----------------------------------------------

# подключение к базе знаний
store <- ragnar_store_connect(store_location, read_only = TRUE)

text <- "Можно ли хранить токен telegram бота в переменной среды?"

# запрос информации из базы знаний
relevant_chunks <- ragnar_retrieve(store, text)

# подключаем базу знаний к ellmer чату
chat <- ellmer::chat_google_gemini(
  system_prompt =  stringr::str_squish(
  "Ты помощник по разработке telegram ботов на языке R. 
   Прежде чем ответить, найди соответствующую информацию в своей базе знаний с помощью инстрвмента get_data_from_knowledge_store.
   Процитируй или перефразируй отрывки, четко отличая свои слова от слов источника. 
   Предоставь рабочую ссылку на каждый цитируемый источник, а также любые дополнительные соответствующие ссылки.
   В ответе обязательно списком указывай какие чанки (укажи в том числе origin, doc_id, chunk_id) из базы знаний ты использовал для ответа."
  ),
  model = 'gemini-2.0-flash',  
  echo  = 'none'
)

# добавляем в объект чата инструмент поиска по базе знаний
ragnar_register_tool_retrieve(chat, store, top_k = 10, name = 'get_data_from_knowledge_store', title = 'knowledge_store')

chat$chat(text, echo = T)

chat$chat("Порекомендуй, где можно развернуть telegram бота, если у меня нет своего сервера", echo = T)


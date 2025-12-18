library(shiny)
library(shinychat)

ui <- bslib::page_fillable(
  chat_ui(
    id = "chat",
    messages = "**Привет!** я помогаю в рабзаботке telegram ботов на языке R. Чем могу тебе помочь?"
  ),
  fillable_mobile = TRUE
)

server <- function(input, output, session) {
  
  # подключаем базу знаний к ellmer чату
  chat <- ellmer::chat_google_gemini(
    system_prompt =  stringr::str_squish(
      "Ты помощник по разработке telegram ботов на языке R. 
       Для формирования каждого ответа сначала ищи информацию в своей базе знаний используя инструмент get_data_from_knowledge_store, 
       т.е. предупреждай что начинаешь поиск по базе знаний, используй инструмент get_data_from_knowledge_store и только потом отвечай 
       с учётом полученной из базы знаний информаии, это обязательное условие для формирования ответов.
       Процитируй или перефразируй отрывки, четко отличая свои слова от слов источника. 
       Предоставь рабочую ссылку на каждый цитируемый источник, а также любые дополнительные соответствующие ссылки.
       Так же всегда добавляй в ответ дополнительный контекст чанков которые использовал для формирования самого ответа, заголовки частей из которых был получен используемый чанк в формате списка с ссылками, где текст бези из поля context используемого чанка, а сама ссылка поля origin используемого чанка.
       Т.е. в конце сообщения ты обязательно должен вывести информацию про используемые для ответа чанки из базы знаний.
       Если ты не смог найти ниодин чанк в базе знаний то в ответе просто скажи, что по вашему запросу я не сумел найти ничего в своей базе знаний, т.е. сам никогда ничего не придумывай, это важно!
      "
    ),
    model = 'gemini-2.0-flash',  
    echo  = 'none'
  )
  
  store <- ragnar_store_connect("tgbot_rag.duckdb", read_only = TRUE)
  ragnar_register_tool_retrieve(chat, store, top_k = 10, name = 'get_data_from_knowledge_store', title = 'knowledge_store')
  
  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)
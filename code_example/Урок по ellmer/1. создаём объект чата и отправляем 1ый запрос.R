pak::pak('ellmer')
library(ellmer)

# API ключ
Sys.setenv(GOOGLE_API_KEY = 'ВАШ API ТОКЕН')

chat <- chat_gemini(
  system_prompt = 
    'Ты специалист по анализу данных, и разработчик на языке R. 
     В этом чате ты помогаешь генерировать код на языке R.'
  )

out <- chat$chat(
  'Напиши мне функцию, которая по заданному 
   городу запрашивает текущу погоду из бесплатного API', 
  echo = 'none'
  )

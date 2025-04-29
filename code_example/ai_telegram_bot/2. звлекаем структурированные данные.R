library(ellmer)

chat <- chat_gemini()

# Извлекаем простую структуру из текста
## описание структуры
personal_data_str <- type_object(
  age  = type_integer('Возраст в годах, целое число'),
  name = type_string('Имя'),
  job  = type_string('Занимаемая на работе должность')
)

## извлекаем информацию
text <- "
Привет, меня зовут Алексей, мне 40 лет, с 2016 года занимаю должность 
руководителя отдела аналитики.
"
personal_data <- chat$extract_data(text, type = personal_data_str)

# классификация настроения комментария
text <- "
Купленный товар работает отлично, к нему никаких притензий нет, 
но обслуживание клиентов было ужасным. 
Я, вероятно, больше не буду у них покупать.
"
type_sentiment <- type_object(
  "Извлеки оценки настроений заданного текста. Сумма оценок настроений должна быть равна 1.",
  positive_score = type_number("Положительная оценка, число от 0.0 до 1.0."),
  negative_score = type_number("Отрицаетльная оценка, число от 0.0 до 1.0."),
  neutral_score = type_number("Нейтральная оценка, число от 0.0 до 1.0.")
)

str(chat$extract_data(text, type = type_sentiment))

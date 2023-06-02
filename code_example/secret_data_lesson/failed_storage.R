# подключение к базе данных
con <- DBI::dbConnect(
  RMariaDB::MariaDB(),
  username = 'alex',
  password = '1122334455',
  host     = 'localhost',
  dbname   = 'main_db'
)

# отправка письма
html_body <- '<html><body><img src="cid:image"></body></html>'

email <- envelope() %>%
  html(html_body) %>%
  attachment(path = "image.jpg", cid = "image")

smtp <- server(
  host = "smtp.gmail.com",
  port = 465,
  username = "bob@gmail.com",
  password = "bd40ef6d4a9413de9c1318a65cbae5d7"
)

# запрос к API
resp <- request("https://api.nytimes.com/svc/books/v3") %>% 
  req_url_path_append("/reviews.json") %>% 
  req_url_query(
    `api-key` = 'ajhuiy8y84yn8t4by873y8bgy', 
    isbn      = 9780307476463
    ) %>% 
  req_perform()


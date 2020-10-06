# рабочая директория
setwd(r'(C:\Users\Alsey\Documents\try_catch_lesson)')

# Конструкция try
res <- try( 10 / 'u' )

# класс объекта
class(res)

# сообщение
attr(res, 'condition')

# пример 
values <- list(3, 6, 2, 'x', 7, 3, 't', 9)

for ( val in values ) {
  
  res <- try( val / 10, silent = TRUE )
  
  if ( class(res) == 'try-error' ) {
    
    print(attr(res, 'condition')) 
    
  } else {
    
    print( paste0( val, " / 10 = ", res))
    
  }
  
}


# Конструкция tryCatch
## обработка ошибок
### функция
div <- function(x, y) {
  
  if ( is.na(y) ) {
    
    warning("Y is NA")
    
  } 
  
  return( x / y )
  
}

### значение
val <- "just text"

### проверка
result <- 
  tryCatch( 
    expr = {
      
      y <- div(10, val)
      
    },
    error = function(err) {
      
      message(err$message)
      y <- 0
      
    },
    warning = function(war) {
      
      message(war$message)
      y <- 1
      
    })


### обработка ошибок
if ( 'error' %in% class(result)  ) {
  
  message("Catch")
  
}

### в цикле 
values <- list(1, 3, NA, 8, "text")

for ( val in values ) {
  
  temp <-
    tryCatch({
      div(10, val)
    },
    error = function(err) {
      
      print(err$message)
      
    })
  
  if ( 'error' %in% class(temp) ) next
}


# блок finnaly
library(DBI)
library(RSQLite)

## подключение
con <- dbConnect(SQLite(), 'my.db')
## создаём фрейм
df <- data.frame(a = 1:5,
                 b = letters[1:5])

## попытка записать данные
out <- 
  tryCatch(
    {
      
      dbWriteTable(con, 
                   'my_data',
                   df)
      
    },
    
    error = function(err) {
      print(err$message)
      return(err)
    },
    
    finally = {
      
      print("Закрываю соединение")
      dbDisconnect(con)
    }
  )

# создаём собственные классы исключений
## функция дл ягенерации собственных классов исключений
exception <- function(class, msg)
  {
    stop(errorCondition(msg, class = class))
  }

## функция в которой будем использовать собственные классы исключений
divideByX <- function(x){
  # исключения
  if (length(x) != 1) {
    exception("NonScalar", "x is not length 1")
  } else if (is.na(x)) {
    exception("IsNA", "x is NA")
  } else if (x == 0) {
    exception("DivByZero", "divide by zero")
  }
  # результат
  10 / x
}

## обработка исключений
val <- 0

tryCatch(
  {
    divideByX(val)
  }, 
  IsNA = function(x) {
    print("Catch")
  },
  NonScalar = function(x) {
    print("Catch2")
  },
  DivByZero = function(x) {
    print('Catch3')
  }
)

# векторизируем обработку исключений
lapply(list(NA, 3:5, 0, 4, 7), 
       function(x) tryCatch({
         
           divideByX(x)
         
       }, 
       IsNA=function(err) {
            warning(err)  # signal a warning, return NA
            NA
       }, 
       NonScalar=function(err) {
            message(err)     # fail
       },
       DivByZero=function(err) {
            message(err)
       })
)

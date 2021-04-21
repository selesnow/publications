# циклы в базовом синтаксисе R


# for ---------------------------------------------------------------------
## выполняется до тех пор,
## пока в итерируем оъекте не будут перебраны
## все элементы

## итерирование по вектору
week <- c('Sunday', 
          'Monday', 
          'Tuesday', 
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday')

for ( day in week ) {
  
  print(n)
  Sys.sleep(0.25)
  
}

## итерирование по списку
persons <- list(
  list(name = "Alexey", age = 36), 
  list(name = "Justin", age = 27),
  list(name = "Piter",  age = 22),
  list(name = "Sergey", age = 39))

## оператор next позволяет переходить на следующую итерацию
for ( person in persons ) {
  
  if ( person$age < 30 ) next
  
  print( paste0( person$name, " is ", person$age, " years old") )
  
} 

## итерирование по таблицам
for ( col in mtcars ) {
  print(mean(col))
  names(col)
}

## итерирование по строкам таблицы
for ( row in 1:nrow(mtcars) ) {
  print(mtcars[row, c('cyl', 'gear')])
}

## вложенные циклы for
x <- 1:5
y <- letters[1:5]
  
for ( int in x ) {
  
  for ( let in y ) {
    
    print(paste0(int, ": ", let))
    
  }
  
}

## как поступить если мне надо на каждой итерации объединять таблицы
setwd('docs')
files <- dir()
result <- list()

for ( file in files ) {
  
  temp_df <- read.csv(file)

  result <- append(result, list(temp_df))
  
}

# объединяем результаты в одну таблицу
result <- do.call('rbind', result)



# while -------------------------------------------------------------------
## итерируется до тех пор,
## пока истинно заданное условие
x <- 1

while ( x < 10 ) {
  
  print(x)
  x <- x + 1
  
}

# оператор break
x <- 1
while ( x < 20 ) {
  
  print(x)
  
  if ( x / 2 == 5 ) break
  
  x <- x + 1
  
}

# repeate -----------------------------------------------------------------
## итерируется до тех пор,
## пока не встретит break
x <- 1

repeat {
  
  print(x)
  
  if (x / 2 == 5) break
  
  x <- x + 1
}


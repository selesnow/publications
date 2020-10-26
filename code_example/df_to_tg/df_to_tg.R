library(purrr)
library(tidyr)
library(stringr)

# функция для перевода data.frame в telegram таблицу
df_to_tg <- function( table, align = NULL, indents = 3, parse_mode = 'Markdown' ) {

  # если выравнивание не задано то выравниваем по левому краю
  if ( is.null(align) ) {

    col_num <- length(table)
    align   <- str_c( rep('l', col_num), collapse = '' )

  }

  # проверяем правильно ли заданно выравнивание
  if ( length(table) != nchar(align) ) {

    align <- NULL

  }

  # новое выравнивание столбцов
  side <- sapply(1:nchar(align),
                 function(x) {
                   letter <- substr(align, x, x)
                   switch (letter,
                           'l' = 'right',
                           'r' = 'left',
                           'c' = 'both',
                           'left'
                   )
                 })

  # сохраняем имена
  t_names      <- names(table)

  # вычисляем ширину столбцов
  names_length <- sapply(t_names, nchar)
  value_length <- sapply(table, function(x) max(nchar(as.character(x))))
  max_length   <- ifelse(value_length > names_length, value_length, names_length)

  # подгоняем размер имён столбцов под их ширину + указанное в indents к-во пробелов
  t_names <- mapply(str_pad,
                    string = t_names,
                    width  = max_length + indents,
                    side   = side)

  # объединяем названия столбцов
  str_names <- str_c(t_names, collapse = '')

  # аргументы для фукнции str_pad
  rules <- list(string = table, width = max_length + indents, side = side)

  # поочереди переводим каждый столбец к нужному виду
  t_str <-   pmap_df( rules, str_pad )%>%
    unite("data", everything(), remove = TRUE, sep = '') %>%
    unlist(data) %>%
    str_c(collapse = '\n')

  # если таблица занимает более 4096 символов обрезаем её
  if ( nchar(t_str) >= 4021 ) {

    warning('Таблица составляет более 4096 символов!')
    t_str <- substr(t_str, 1, 4021)

  }

  # символы выделения блока кода согласно выбранной разметке
  code_block <- switch(parse_mode,
                       'Markdown' = c('```', '```'),
                       'HTML' = c('`', '`'))

  # переводим в code
  res <- str_c(code_block[1], str_names, t_str, code_block[2], sep = '\n')

  return(res)
}

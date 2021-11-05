# apply family

# пример с циклом ---------------------------------------------------------
# строки
for ( x in seq_along(1:nrow(mtcars)) ) {
  cat(rownames(mtcars[x,]), ":", sum(mtcars[x,]), "\n")
}

# столбцы
col_num <- 1

for ( x in mtcars ) {
  cat(names(mtcars)[col_num], ":", sum(x), "\n")
  col_num <- col_num + 1
}

# apply -------------------------------------------------------------------
# 1 - строки
# 2 - столюцы
apply(mtcars, 1, sum)
apply(mtcars, 2, sum)

sum(mtcars[3, ])
sum(mtcars[ ,3])
# row operation -----------------------------------------------------------
rowSums(mtcars)
rowMeans(mtcars)
# передача дополнительных аргументов --------------------------------------
apply(mtcars, 2, quantile, probs = 0.25)
quantile(mtcars[, 3], probs = 0.25)

# lapply ------------------------------------------------------------------
values <- list(
  x = c(4, 6, 1),
  y = c(5, 10, 1, 23, 4),
  z = c(2, 5, 6, 7)
)

lapply(values, sum)
sapply(values, sum)
vapply(values, sum, FUN.VALUE = 7)

# lapply с самописной функцией --------------------------------------------
fl <- function(x) {
  num_elements <- length(x)
  return(x[1] + x[num_elements])
}

lapply(values, fl)


# пример чтения файлов ----------------------------------------------------
directory <- 'C:/Users/Alsey/Documents/docs/'
files <- dir(path = directory, pattern = '\\.csv$')
all_data <- list()

# цикл 
for ( file in files ) {
  data <- read.csv(paste0(directory, file))
  all_data <- append(all_data, list(data))
}

dplyr::bind_rows(all_data)

# lapply
file_paths <- paste0(directory, files)
all_data <- lapply(file_paths, read.csv)
dplyr::bind_rows(all_data)


# mapply ------------------------------------------------------------------
mapply(rep, 1:4, times=4:1)
mapply(rep, times = 1:4, x = 4:1)

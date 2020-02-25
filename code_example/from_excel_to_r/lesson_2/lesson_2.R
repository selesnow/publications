# переменная
x <- 1

# вектор
y <- 1:10
typeof(y)
strings <- c("string", "vector")
typeof(strings)
vec <- c(3, "string")
typeof(vec)

# обраение к элементу вектора
strings[1]
strings[2]
y[3:6]
y[c(2, 5, 9)]

# таблица, data frame
df1 <- data.frame(a = 1:3,
                  b = c("a", "b", "c"))

# обратиться к определённому столбцу таблицы
df1$a
df1['a']

# списки
typeof(df1)
class(df1)
list1 <- list(y, strings, vec, df1)
list2 <- list(node1 = c(1, 5, 8),
              node2 = list("y", 3, "p"))

# структура объекта
str(df1)
str(list2)
str(vec)

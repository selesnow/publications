#Загружаем данные из CSV файлв в кодировке UTF-8, с русским текстом
Sys.setlocale("LC_CTYPE", "russian")
rus_df <- read.csv2("C:/alsey/russian_text/справочник имён.csv", encoding = "UTF-8")
#Записываем данные в файл
write.csv(file = "C:/alsey/russian_text/out.csv", rus_df,row.names = F)

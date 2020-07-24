#!/usr/bin/env python
# coding: utf-8

# # Подключаем библиотеки

# In[ ]:


import pandas as pd             # библиотека для анализа данных
import sqlite3                  # подключение к базе данных SQLite3
get_ipython().run_line_magic('matplotlib', 'inline              # отображение графиков')
import matplotlib.pyplot as plt # построение графиков


# # Структуры данных в Pandas
# ## Серия

# In[ ]:


# создаём серию
simple_list = ['a', 'b', 'c', 'd']
simple_ser = pd.Series(simple_list)

simple_ser


# In[ ]:


# обращение к элементам серии
simple_list[1:3]


# In[ ]:


# арифметические операции с сериями
num_series_1 = pd.Series([1,4,6,7,8])
num_series_2 = pd.Series([10,20,30,40,55])

num_series_1 + num_series_2


# In[ ]:


# выравнивание по индексам
num_series_1 = pd.Series([1,4,6,7,8], index = ['a','b','c','d','e'])
num_series_2 = pd.Series([10,20,30,40,55], index = ['e','d','c','b','a'])

num_series_1 + num_series_2


# ---
# ## DataFrame

# In[ ]:


# создаём таблицу из словара
data_dict = {'name': ['Alexey', 'Andrey', 'Sergey', 'Denis', 'Anna', 'Kirill'],
             'age': [36, 31, 23, 19, 25, 42],
             'department': ['analytics', 'programmers', 'sales', 'sales', 'accountant', 'analytics']}

data = pd.DataFrame(data_dict)

data


# In[ ]:


# по сути таблица это набор серий
sr1 = pd.Series(['a', 'b', 'c', 'a', 'c'])
sr2 = pd.Series([10, 13, 9, 5, 15])

df = pd.DataFrame({'mark': sr1, 
                   'val': sr2})

df


# In[ ]:


# отобрать несколько столбцов
data[['name', 'department']]


# In[ ]:


# отобрать строки, сотрудники старше 30 лет
data[ data.age > 30 ]


# # Загрузка данных из внешних источников
# ## Загрузка данных из CSV файла

# In[ ]:


staff_dict = pd.read_csv('D:/Google Диск/Отчётность/Netpeak/Выступления/ProductStar/Основы Python. Работа с библиотекой Pandas/staff_dict.csv', 
                        sep=';')

staff_dict


# ## Загрузка данных из Excel

# In[ ]:


## Загрузка данных из  Excel файла
staff_dict_excel = pd.read_excel('D:/Google Диск/Отчётность/Netpeak/Выступления/ProductStar/Основы Python. Работа с библиотекой Pandas/staff_dict.xlsx',
                                index_col='id',
                                sheet_name='staff_dict')

staff_dict_excel


# ## Загрузка данных из базы данных

# In[ ]:


# подключение к БД
con = sqlite3.connect("D:/Google Диск/Отчётность/Netpeak/Выступления/ProductStar/Основы Python. Работа с библиотекой Pandas/database.db")
# формируем запрос 
query = """
SELECT id, name, Age, Experience, Salary
FROM staff_table;
"""
# получить результат выполнения SQL запроса
staff_dict_sql = pd.read_sql(query, con, index_col = 'id')

staff_dict_sql


# # Проверка загруженных данных

# In[ ]:


# посмотреть 3 первые строки
staff_dict.head(3)


# In[ ]:


# посмотреть 3 последние строки
staff_dict.tail(3)


# In[ ]:


# посмотреть структуру таблицы
staff_dict.dtypes


# In[ ]:


# получить описательные статистики
staff_dict.describe()


# In[ ]:


# получить описательные статистики по категориальной переменной
staff_dict.name.describe()


# # Основные операции по манипуляции с данными

# In[ ]:


# загрузка данных
# таблицы продаж
sales_1 = pd.read_excel('D:/Google Диск/Отчётность/Netpeak/Выступления/ProductStar/Основы Python. Работа с библиотекой Pandas/sales.xlsx',
                        sheet_name='sales_1')

sales_2 = pd.read_excel('D:/Google Диск/Отчётность/Netpeak/Выступления/ProductStar/Основы Python. Работа с библиотекой Pandas/sales.xlsx',
                        sheet_name='sales_2')

# справочник магазинов
shops = pd.read_excel('D:/Google Диск/Отчётность/Netpeak/Выступления/ProductStar/Основы Python. Работа с библиотекой Pandas/sales.xlsx',
                      sheet_name='shop')
# справочник товаров
products = pd.read_excel('D:/Google Диск/Отчётность/Netpeak/Выступления/ProductStar/Основы Python. Работа с библиотекой Pandas/sales.xlsx',
                          sheet_name='products')
# справочник менеджеров по продажам
managers = pd.read_excel('D:/Google Диск/Отчётность/Netpeak/Выступления/ProductStar/Основы Python. Работа с библиотекой Pandas/sales.xlsx',
                          sheet_name='managers')


# ## Анализ структуры загруженных данных

# In[ ]:


# таблица продаж
sales_1.head(5)


# In[ ]:


# посмотреть количество строк и столбцов
sales_1.shape


# In[ ]:


# типы данных в таблице продаж
sales_1.dtypes


# In[ ]:


# справочник магазинов
shops


# In[ ]:


# справочник товаров
products.head()


# In[ ]:


# справочник менеджеров по продажам
managers


# ## Переименование столбцов и вертикальное объединение таблиц

# In[ ]:


{'sales_1': sales_1.columns,
 'sales_2': sales_2.columns}


# In[ ]:


# попытка вертикально объединить таблицы
sales = pd.concat([sales_1, sales_2])
sales


# In[ ]:


# переименовываем столбцы
sales_2.rename(columns = {'id': 'sale_id', 'sale_date': 'date', 'Shop': 'shop'}, inplace=True)
sales_2


# In[ ]:


## Горизонтальное соединение таблиц по ключу
sales_total = pd.merge(sales, shops, left_on = 'shop', right_on = 'shop_id', how='inner').                 merge(products, left_on = 'product', right_on = 'product_id', how='inner').                 merge(managers, left_on = 'manager', right_on = 'manager_id', how='inner')

sales_total


# ## Добавление вычисляемых столбцов

# In[ ]:


# рассчитываем сумму транзакции
sales_total['transaction_sum'] = sales_total['price'] * sales_total['count']

# расчитываем бонус менеджера
sales_total['manager_bonus'] = sales_total['transaction_sum'] * ( sales_total['percent'] / 100 )

sales_total


# ## Группировка и агрегация данных

# In[ ]:


# рассчитываем сводные данные по менеджерам
mangers_stat = sales_total.groupby('manager_name').                           agg({'manager_bonus': 'sum',
                                'transaction_sum': ['sum', 'mean'],
                                'sale_id': pd.Series.nunique}).\
                           reset_index().\
                           sort_values(by=('manager_bonus',  'sum'), ascending=False)

# переименовываем столбцы
mangers_stat.columns = ['name', 'bonus', 'sale_sum', 'avg_transaction', 'transaction']

# округление
mangers_stat = mangers_stat.round({'avg_transaction': 2})

mangers_stat


# ## Визуализация результатов

# In[ ]:


# переносим имя менеджера в индекс
mangers_stat.index = mangers_stat.name
# строим визуализацию результатов
mangers_stat.bonus.plot(kind='barh')

# альтернативный вариант, вызвать метод bar()
#mangers_stat.bonus.plot.bar()


# In[ ]:


# линейный график продаж
sales_total.groupby('date').agg({'transaction_sum': sum}).plot()


# In[ ]:


# расчёт и визуализация нарастающего итога
cumsum_sales = sales_total.groupby('date').                           agg({'manager_bonus': sum}).                           manager_bonus.cumsum().                           plot(kind='area')


# In[ ]:


# скользящее среднее
cumsum_sales = sales_total.groupby('date').                           agg({'manager_bonus': sum}).                           manager_bonus.                           rolling(window=20).                           mean().                           plot()


# In[ ]:


# сравниваем продажи по странам
sales_total.boxplot(column=['manager_bonus'], by=['manager_name'])


# # Сводные таблицы в pandas

# In[ ]:


pd.pivot_table(sales_total, 
               index = 'manager_name', 
               columns = 'shop_name', 
               values = 'sale_id', 
               aggfunc = pd.Series.nunique)


# In[ ]:


pd.pivot_table(sales_total, 
               index = 'product_name', 
               columns = 'country', 
               values = 'transaction_sum', 
               aggfunc = sum,
               margins = True)


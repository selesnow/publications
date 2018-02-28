#Подключаем пакет
library("ryandexdirect")

#Получаем токен разработчика
tok <- yadirGetToken()

#Вводим переменную содержащую логин пользователя, замените MYLOGIN на ваш логин в Яндексе
my_login <- "MYLOGIN"

#Получаем географический справочник
geo_dict <- yadirGetDictionary(DictionaryName = "GeoRegions", Language = "en", login = my_login, token = tok )

#Добавляем поле с идентификатором страны
geo_dict$CountryID <- NA

#Определяем страну для каждого элемента справочника
#Запускаем цикл по каждому элементу справочника
for(gd in 1:nrow(geo_dict)){
  #Проверяем, если текущий элемент является страной то в поле ID страны устанавливаем ID этого же элемента, иначе устанавливаем ID родительского элемента
  if(geo_dict$GeoRegionType[gd] == "Country"){
    geo_dict$CountryID[gd] <- geo_dict$GeoRegionId[gd]
  }else{
    geo_dict$CountryID[gd] <- geo_dict$ParentId[gd]}
  
  #Проверяем тип родительского региона, если он ниже страны то присваиваем в ID страны ID региона который является родительским для родительского региона начальной строки, повторяем до тех пор пока не найдём страну
  while(geo_dict$GeoRegionType[geo_dict$GeoRegionId == geo_dict$CountryID[gd]] %in% c("Administrative area", "District", "City", "City district", "Village")){
    
    geo_dict$CountryID[gd] <- geo_dict$ParentId[geo_dict$GeoRegionId == geo_dict$CountryID[gd]]
    
  }
}


#Отделяем справочник областей
geo_dict <- merge(geo_dict, subset(geo_dict, select = c("GeoRegionId","GeoRegionName")),by.x = "CountryID", by.y = "GeoRegionId", all.x = T)
names(geo_dict) <- c("CountryID", "GeoRegionId", "ParentId", "GeoRegionType", "GeoRegionName", "CountryName")

#Добавляем поле с идентификатором области
geo_dict$AreaID <- NA

#Определяем область для каждого элемента справочника
#Запускаем цикл по каждому элементу справочника
for(gd in 1:nrow(geo_dict)){
  #Проверяем если текущий элемент является областью то в поле ID страны устанавливаем ID этого же элемента, иначе устанавливаем ID родительского элемента
  if(geo_dict$GeoRegionType[gd] == "Administrative area"){
    geo_dict$AreaID[gd] <- geo_dict$GeoRegionId[gd]
  }else{
    geo_dict$AreaID[gd] <- geo_dict$ParentId[gd]}
  
  #Проверяем тип родительского региона, если он ниже области то присваиваем в ID области ID региона который является родительским для родительского региона начальной строки, повторяем до тех пор пока не найдём область
  while(geo_dict$GeoRegionType[geo_dict$GeoRegionId == geo_dict$AreaID[gd]] %in% c("District", "City", "City district", "Village")){
    
    geo_dict$AreaID[gd] <- geo_dict$ParentId[geo_dict$GeoRegionId == geo_dict$AreaID[gd]]
    
  }
}

#Отделяем справочник областей
geo_dict <- merge(geo_dict, subset(geo_dict, select = c("GeoRegionId","GeoRegionName")),by.x = "AreaID", by.y = "GeoRegionId", all.x = T)
names(geo_dict) <- c("AreaID","CountryID", "GeoRegionId", "ParentId", "GeoRegionType", "GeoRegionName", "CountryName", "AreaName")

#Запрашиваем статистику из Report сервиса
stat <- yadirGetReport(ReportType = "CUSTOM_REPORT", 
                       DateRangeType = "CUSTOM_DATE", 
                       DateFrom = "2018-01-01", 
                       DateTo = "2018-01-31", 
                       FieldNames = c("LocationOfPresenceId",
                                      "Impressions",
                                      "Clicks",
                                      "Cost"), 
                       FilterList = NULL, 
                       IncludeVAT = "YES", 
                       IncludeDiscount = "NO", 
                       Login =my_login, 
                       Token = tok)

#Соединяем данные статистики со справочником регионов
stat <- merge(stat, geo_dict, by.x = "LocationOfPresenceId", by.y = "GeoRegionId", all.x = T)

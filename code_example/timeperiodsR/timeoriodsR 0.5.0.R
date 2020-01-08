# Intro to timeperiodsR 0.5.0
# instal.packages("timeperiodsR")
library(timeperiodsR)

# next month
nm <- next_month()

library(timeperiodsR)
# set options
options("timeperiodsR.official_day_offs" = TRUE,
        "timeperiodsR.official_day_offs_country" = "ru",
        "timeperiodsR.official_day_offs_pre" = 1)

# next month
nm <- next_month()

# official calendar
nm$official_workdays
nm$official_first_workday
nm$official_last_workday
nm$dayoffs_marks

# official dayoffs
nm$official_day_offs

# check dayoffs
check_dayoffs(nm)
check_dayoffs(c("2019-01-01", "2019-01-06", "2019-01-17"))

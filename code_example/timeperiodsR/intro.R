# Intro to timeperiodsR
# install package
# install.packages("timeperiodsR")

# attach
library(timeperiodsR)

# create tpr object
period <- custom_period("2019-11-05", "2019-11-11")
period

# #########################
# tpr object structure
# #########################

# get object components
## by $
period$start    # start of period
period$end      # end of period
period$sequence # all dates in period
period$length   # number of days in period

## by methods
start(period)  # start of period
end(period)    # end of period
seq(period)    # all dates in period
length(period) # number of days in period

## by argument
custom_period("2019-11-05", "2019-11-11", "start")
custom_period("2019-11-05", "2019-11-11", "end")
custom_period("2019-11-05", "2019-11-11", "sequence")
custom_period("2019-11-05", "2019-11-11", "length")


# #########################
# time periods functions
# #########################

# list of functions
help(package = "timeperiodsR")

# last_n_*
Sys.Date() # current date

last_period <- last_n_days(n = 15)

last_period
last_period$start
last_period$end
last_period$sequence
last_period$length

# change x date
last_n_days(x = "2019-10-12", n = 15)

# other periods
# 3 last month with current
last_n_months(n = 3, include_current = F) 

# 5 last months from 12 of september 2019
last_n_weeks(x = "2019-09-12", n = 5)

# get 5 last week from 12 of september 2019
# include week of 12 of september 2019
last_n_weeks(x = "2019-09-12", n = 5, include_current = T) 

# get 5 last week from 20 of september 2019
# start week day is Sunday
last_n_weeks(x = "2019-09-20", n = 2, week_start = 7) 


# previous_*
previous_period <- previous_week(x = "2019-12-04")
previous_period
previous_week(week_start = 7)

previous_month(n = 3)
last_n_months(n = 3)

# this_*
this_month()
this_year()

# next_*
next_n_weeks(n = 2)
next_n_weeks(x = "2019-09-11", n = 2)
n5m <- next_n_months(n = 5)
length(n5m)

# next_n_*
next_week()
next_week(n = 2)
next_quarter()
next_year()

# #########################
# convert date to tpr
# #########################
dates1 <- seq(from = as.Date("2019-11-01"), to = as.Date("2019-11-10"), "day")
dates1
dates1 <- as_timeperiod(dates1)
dates1
dates1$start


dates <- as.Date(c("2019-09-11", "2019-09-02", "2019-10-11", "2019-08-30"))
dates_tpr <- as_timeperiod(dates)
dates_tpr
dates_tpr$sequence

# #########################
# dates filtrning
# #########################
losse_dates <- as.Date(c("2019-11-30","2019-12-01", "2019-12-02", "2019-12-04"))
all_dates   <- last_n_days(n = 5)

losse_dates %right_out% all_dates
losse_dates %left_out% all_dates
losse_dates %right_in% all_dates
losse_dates %left_in% all_dates

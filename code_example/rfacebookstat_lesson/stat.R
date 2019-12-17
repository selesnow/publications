library(rfacebookstat)

fbAuth()# set options 
options(rfacebookstat.accounts_id = c("act_343997796237759",
                                      "act_723923827948880",
                                      "act_132967703707573",
                                      "act_1362794783741060",
                                      "act_10203885161435114"))

# fb statistic
simple_report <- fbGetMarketingStat(level  = "account",
                                    fields = "account_id,clicks,spend,impressions",
                                    date_start = "2019-12-01",
                                    date_stop  = "2019-12-05")

# visualisation
library(ggplot2)
library(dplyr)

mutate(simple_report, 
       clicks = as.integer(clicks)) %>%
  ggplot(aes(y = clicks, x = date_start, 
             group = account_id,
             color = account_id)) +
  geom_line() +
  geom_point()

# ###################################################################
# fb actions ########################################################
# ###################################################################
action_report <- fbGetMarketingStat(level  = "account",
                                    fields = "account_id,actions",
                                    action_breakdowns = "action_type",
                                    date_start = "2019-12-01",
                                    date_stop  = "2019-12-05")

names(action_report)

# fb attribution_window
attrib_report <- fbGetMarketingStat(level  = "account",
                                    fields = "account_id,actions",
                                    action_breakdowns = "action_type",
                                    attribution_window = c('default', 
                                                           '1d_view', 
                                                           '28d_view', 
                                                           '28d_click'),
                                    date_start = "2019-12-01",
                                    date_stop  = "2019-12-05")
  
names(attrib_report)


  
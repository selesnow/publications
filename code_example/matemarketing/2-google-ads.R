# ###############################################
# RAdwords
# ###############################################
devtools::install_github("jburkhardt/RAdwords" ) # Óñòàíîâêà ïàêåòà
library(RAdwords)                                # Ïîäêëþ÷àåì ïàêåò
setwd("C:/matemarketing")                        # óñòàíàâëèâàåì íîâóþ ðàáî÷óþ äèðåêòîðèþ

# Âûáîð îò÷¸òà
reports()

# Âûáîð ïîëåé
metrics(report = "ACCOUNT_PERFORMANCE_REPORT")

# àâòîðèçàöèÿ
browseURL("https://console.cloud.google.com") # íàñòðîéêà Google Cloud Console
browseURL("https://ads.google.com/")           # óïðàâëÿþùèé àêêàóíò Google Ads
adw_auth <- doAuth(save = TRUE)               # àâòîðèçàöèÿ

# ôîðìèðîâàíèå ïðîñòîãî îò÷¸òà
simple_body <- statement(report = "CAMPAIGN_PERFORMANCE_REPORT", 
                         select = c("CampaignId",
                                    "CampaignStatus", 
                                    "StartDate",
                                    "Date",
                                    "Clicks",
                                    "Cost"),
                         start  = "2018-09-01",
                         end    = "2018-09-30")

# îòïðàâêà çàïðîñà
simple_data <- getData(clientCustomerId = "957-328-7481",
                       google_auth      = adw_auth,
                       statement        = simple_body)

# ïîëó÷èòü ïîëíûé ñïèñîê îáúåêòîâ, äàæå åñëè ïî íèì íå áûëî ïîêàçîâ
kw_body <- simple_body <- statement(report = "CRITERIA_PERFORMANCE_REPORT", 
                                    select = c("Id",
                                               "Criteria", 
                                               "CriteriaType",
                                               "DisplayName",
                                               "CpcBid",
                                               "QualityScore"))

# îòïðàâêà çàïðîñà
keywords <- getData(clientCustomerId = "957-328-7481",
                    google_auth      = adw_auth,
                    statement        = kw_body,
                    includeZeroImpressions = TRUE)

# èñïðàâëÿåì ïðîáëåìó ñ êîäèðîâêîé
keywords$`Keyword/Placement` <- iconv(keywords$`Keyword/Placement`, from = "UTF-8", to = "1251") 
keywords$`Keyword/Placement` <- iconv(keywords$`Keyword/Placement`, from = "UTF-8", to = "1251") 
keywords$CriteriaDisplayName <- iconv(keywords$CriteriaDisplayName, from = "UTF-8", to = "1251") 
keywords$CriteriaDisplayName <- iconv(keywords$CriteriaDisplayName, from = "UTF-8", to = "1251") 

# ###############################################
# adwordsR
# ###############################################
install.packages("adwordsR") # óñòàíîâêà
library(adwordsR)            # ïîäêëþ÷åíèå

# àâòîðèçàöèÿ
my_adw_token <- generateAdwordsToken(addGitignore = FALSE) # àâòîðèçàöèÿ
my_adw_token <- loadAdwordsToken()                         # çàãðóçêà òîêåíà

# ïðîñòîé çàïðîñ
simple_data2 <- getReportData(reportType        = "CAMPAIGN_PERFORMANCE_REPORT",
                              attributes        = c("CampaignId",
                                                    "CampaignStatus", 
                                                    "StartDate"),
                              segment           = c("Date"),
                              metrics           = c("Clicks",
                                                    "Cost"),
                              startDate         = "2018-09-01",
                              endDate           = "2018-09-30",
                              clientCustomerId  = "957-328-7481",
                              credentials       = my_adw_token)

# ïðåîáðàçóåì äåíåæíûå äàííûå
simple_data2$Cost <- simple_data2$Cost / 1000000

# ñïèñîê êëþ÷åâûõ ñëîâ
keywords2 <- getReportData(reportType        = "CRITERIA_PERFORMANCE_REPORT",
                           attributes        = c("Id",
                                                 "Criteria", 
                                                 "CriteriaType",
                                                 "DisplayName",
                                                 "CpcBid",
                                                 "QualityScore"),
                           startDate         = "2018-09-01",
                           endDate           = "2018-09-30",
                           clientCustomerId  = "957-328-7481",
                           includeZeroImpressions = TRUE,
                           credentials       = my_adw_token)

# https://github.com/jennybc/googlesheets/blob/master/vignettes/managing-auth-tokens.md

setwd("/home/jirong/Desktop/personal-finance")

library("googlesheets")
# token <- gs_auth(cache = FALSE)
# gd_token()
# saveRDS(token, file = "googlesheets_token.rds")

# gs_ls()

gs_auth(token = "googlesheets_token.rds")
## and you're back in business, using the same old token
## if you want silence re: token loading, use this instead
suppressMessages(gs_auth(token = "googlesheets_token.rds", verbose = FALSE))

dat = gs_title("JR_Investment")
gs_ws_ls(dat)   #tab names
data <- gs_read(ss=dat, ws = "monthly_dashboard", skip=0)
data = as.data.frame(data)
data = subset(data,select = c("Date","NW","NW_exCPF","Portfolio","Portfolio_and_CPFOA_STIETF"))
data$Date = as.Date(data$Date,origin = "1899-12-30")

#real = gs_title("JR_Investment")
#gs_ws_ls(real)
#real <- gs_read(ss=real, ws = "Summary", skip=0)


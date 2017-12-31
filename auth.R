library("googlesheets")

gs_ls()
dat = gs_title("JR_Investment")
gs_ws_ls(dat)   #tab names
data <- gs_read(ss=dat, ws = "monthly_dashboard", skip=0)
data = as.data.frame(data)
data = subset(data,select = c("Date","NW","NW_exCPF","Portfolio","Portfolio_and_CPFOA_STIETF"))
data$Date = as.Date(data$Date,origin = "1899-12-30")

#real = gs_title("JR_Investment")
#gs_ws_ls(real)
#real <- gs_read(ss=real, ws = "Summary", skip=0)


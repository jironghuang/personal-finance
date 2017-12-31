library("ggplot2")
library("dplyr")
library("reshape2")
library("shiny")


# https://cran.r-project.org/web/packages/googlesheets/vignettes/basic-usage.html
# Define a server for the Shiny app
## add first six rows of iris data (and var names) into a blank sheet
# foo <- foo %>%
#   gs_edit_cells(ws = "edit_cells", input = head(iris), trim = TRUE)
#Alternatively write a csv to print to folder

source("auth.R")
function(input, output) {

  # Fill in the spot we created for a plot
  output$Plot <- renderPlot({
    
    # gs_ls()
    # dat = gs_title("JR_Investment")
    # gs_ws_ls(dat)
    # data <- gs_read(ss=dat, ws = "monthly_dashboard", skip=0)
    # data = as.data.frame(data)
    # data = subset(data,select = c("Date","NW","NW_exCPF","Portfolio","Portfolio_and_CPFOA_STIETF"))
    # data$Date = as.Date(data$Date,origin = "1899-12-30")
    d = melt(data,id = "Date")
    
    # data = read.csv("net_worth.csv",stringsAsFactors = FALSE)
    # data$Date <- as.Date(data$Date,origin = "1899-12-30")
    # 
    # d = melt(data,id = "Date")
    
    p = ggplot(data=d,
           aes(x=Date, y=value, colour=variable)) +
    geom_line() +
    geom_point() +
    geom_text(aes(label = round(value/1000,0)),vjust = -1) +
    ylim(0,300000)
    
   print(p)
   
  },height = 800, width = 800)
}




library("shiny")
library("ggplot2")
library("googlesheets")


# gs_ls()
real = gs_title("JR_Investment")
gs_ws_ls(real)
real <- gs_read(ss=real, ws = "Summary", skip=0)
# real = read.csv("real_time.csv",stringsAsFactors = FALSE)
real = as.data.frame(real)
# source("auth.R")
fluidPage(
  
  titlePanel(paste("Feedback loop machines updated daily",round(real[which(real$Type == "Net_worth"),2]/1000,1),round(real[which(real$Type == "Net_worth_excl_cpf"),2]/1000,1),round(real[which(real$Type == "portfolio"),2]/1000,1),sep = ", ")),
  # titlePanel(paste("Feedback loop machines updated daily",round(real[1,1]/1000,1),round(real[1,2]/1000,1),round(real[1,3]/1000,1),sep = ", ")),

  # sidebarPanel(
  #   
  #   radioButtons("Pls choose the options", label = h3("Radio buttons"),
  #                choices = list("Net Worth Including CPF" = 3, "Net Worth excluding CPF" = 2, "Portfolio" = 1), 
  #                selected = 3),
  #   
  #   hr(),
  #   fluidRow(column(2, verbatimTextOutput("value")))  
  #   
  # ),
  
  mainPanel(
    plotOutput(outputId ='Plot',width = "100%")
  )
)
#Update spreadsheet first

setwd("/home/jirong/Desktop/personal-finance")
library(shiny)
#To test application
# runApp()

#To deploy the app
library(rsconnect)
options(repos=c(CRAN="https://cran.rstudio.com")) #Have to add this for command line to work
rsconnect::setAccountInfo(name='sef88',
                          token='774B78F3DCDF204010B6DB8A549AFD06',
                          secret='T+53U52YBPufrcz6hI68A3pBCuAWqqCMDR86WLqu')


deployApp()



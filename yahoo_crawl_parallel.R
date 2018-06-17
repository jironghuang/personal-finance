#Use this script to rbind
library("tidyr")
library("dplyr")

#Change your working directory here
if( .Platform$OS.type == "windows" ){
  wd = file.path("C:", "Users", "Huang Jirong", "Google Drive", "Shiny","yahoo prices", fsep = .Platform$file.sep)
}else{
  wd = "/home/jirong/Desktop/github/personal-finance"
}

setwd(wd)

source("/home/jirong/Desktop/github/personal-finance/auth.R")

Sys.sleep(70)

for(i in 1:6){
  name = paste("yahoo_info",i,".csv",sep = "")
  
  if(i == 1){
    yahoo_list = read.csv(name,stringsAsFactors = F)    
  }else{
   file_ind = read.csv(name,stringsAsFactors = F)
   yahoo_list = rbind(yahoo_list,file_ind)
  }
}

yahoo_list = arrange(yahoo_list,Change_fr_52_week_high)

dat <- dat %>%
  gs_edit_cells(ws = "Yahoo", input = yahoo_list, trim = TRUE)

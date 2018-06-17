#Take 9 mins to run 

#Scraping financial information from yahoo to fill up yahoo spreadsheet
#Use spell-checker algortihm to match the company in 2000 to Fortune
library("stringr")
# library("XML")  #for parsing
# library("rvest")
library("RCurl")

#Change your working directory here
if( .Platform$OS.type == "windows" ){
  wd = file.path("C:", "Users", "Huang Jirong", "Google Drive", "Shiny","yahoo prices", fsep = .Platform$file.sep)
}else{
  wd = "/home/jirong/Desktop/github/personal-finance"
}

setwd(wd)

# source("/home/jirong/Desktop/github/personal-finance/auth.R")

###################################Scraping direclty from website########################
#########################################################################################
# https://finance.yahoo.com/quote/AAPL?p=AAPL
yahoo_list = read.csv("yahoo_prices.csv",stringsAsFactors = FALSE)
yahoo_list$link = paste("https://finance.yahoo.com/quote/",yahoo_list$Ticker,"?p=",yahoo_list$Ticker,sep = "")
yahoo_list$fifty_two_weekrange = ""
yahoo_list$fifty_two_weekhigh = ""
yahoo_list$fifty_two_weeklow = ""

#59 error
# for (i in 1:10) {
#   tryCatch({
#     print(i)
#     if (i==7) stop("Urgh, the iphone is in the blender !")
#   }, error=function(e){})
# }

yahoo_list = yahoo_list[43:63,]
for(i in 1:21){
  tryCatch({
  print(i);print(yahoo_list$Ticker[i]);yahoo_list$Price[i-1]
  html = getURL(yahoo_list$link[i]) 
  if(length(html)>=1){
    # a = as.data.frame(html); a$html = as.character(a$html)
    
    if(grepl("Summary for ",html) == TRUE){
      name_h = str_locate(html,'Summary for ')[1,2]
      yahoo_list$Name[i] = substring(html, first = name_h-100, last = name_h+100)  
      yahoo_list$Name[i] = substring(yahoo_list$Name[i], 
                                     first = str_locate(yahoo_list$Name[i],"Summary for ")[1,2]+1, 
                                     last = str_locate(yahoo_list$Name[i],"Yahoo Finance")[1,1]-4)      
    }
    
    # if(grepl("data-reactid=\"35\"><!-- react-text: 36 -->",html) == TRUE){
    #   #In numeric
    #   price_h = str_locate_all(html,'data-reactid=\"35\"><!-- react-text: 36 -->')[[1]][1,2]
    #   yahoo_list$Price[i] = substring(html, first = price_h+1, last = price_h+100)  
    #   yahoo_list$Price[i] = substring(yahoo_list$Price[i], 
    #                                   first = 1, 
    #                                   last = str_locate(yahoo_list$Price[i],"<")[1,1]-1)       
    # }

    if(grepl("data-reactid=\"35\">",html) == TRUE){
      #In numeric
      price_h = str_locate_all(html,'data-reactid=\"35\">')[[1]][2,2]
      yahoo_list$Price[i] = substring(html, first = price_h+1, last = price_h+100)  
      yahoo_list$Price[i] = substring(yahoo_list$Price[i], 
                                      first = 1, 
                                      last = str_locate(yahoo_list$Price[i],"<")[1,1]-1)       
    }    
    
    if(grepl('data-test="PE_RATIO-value"',html) == TRUE){
      pe_h = str_locate(html,'data-test="PE_RATIO-value"')[1,2]
      yahoo_list$P.E[i] = substring(html, first = pe_h-200, last = pe_h+200)  
      yahoo_list$P.E[i] = substring(yahoo_list$P.E[i], 
                                    first = str_locate(yahoo_list$P.E[i],"<!-- react-text: 101 -->")[1,2]+1, 
                                    last = str_locate(yahoo_list$P.E[i],"<!-- /react-text --></span>")[1,1]-1)   
    }


    # div_h = str_locate(html,'DIVIDEND_AND_YIELD-value"')[1,2]
    # div_h$P.E[i] = substring(html, first = div_h, last = div_h+200)  
    # yahoo_list$P.E[i] = substring(yahoo_list$P.E[i], 
    #                               first = str_locate(yahoo_list$P.E[i],"<!-- react-text: 101 -->")[1,2]+1, 
    #                               last = str_locate(yahoo_list$P.E[i],"<!-- /react-text --></span>")[1,1]-1)       
    
    # div_h = str_locate(a$html[grep('DIVIDEND_AND_YIELD-value',a$html)],'DIVIDEND_AND_YIELD-value')[1,1]
    
    if(grepl('FIFTY_TWO_WK_RANGE',html) == TRUE){
      fifty_two_week_h = str_locate(html,'FIFTY_TWO_WK_RANGE')[1,2]
      yahoo_list$fifty_two_weekrange[i] = substring(html, first = fifty_two_week_h+1, last = fifty_two_week_h+200)  
      yahoo_list$fifty_two_weekrange[i] = substring(yahoo_list$fifty_two_weekrange[i], 
                                                    first = str_locate(yahoo_list$fifty_two_weekrange[i],'>')[1,2]+1, 
                                                    last = str_locate(yahoo_list$fifty_two_weekrange[i],'<')[1,1]-1)  
      print(yahoo_list$fifty_two_weekrange[i])
  
    }
    

  }
  }, error=function(e){})
}



#Functions for formatting

range_fx_high = function(range){
  range = gsub(",","",range)
  a = strsplit(range," - ")
  fifty_two_weekhigh = a[[1]][2]
  return(fifty_two_weekhigh)
}

range_fx_low = function(range){
  range = gsub(",","",range)
  a = strsplit(range," - ")
  fifty_two_weeklow = a[[1]][1]
  return(fifty_two_weeklow)
}

yahoo_list$fifty_two_weekhigh = as.numeric(lapply(yahoo_list$fifty_two_weekrange,range_fx_high))
yahoo_list$fifty_two_weeklow = as.numeric(lapply(yahoo_list$fifty_two_weekrange,range_fx_low))
yahoo_list$Price = as.numeric(gsub(",","",yahoo_list$Price))

yahoo_list$Change_fr_52_week_high = (yahoo_list$Price - yahoo_list$fifty_two_weekhigh)/yahoo_list$fifty_two_weekhigh
yahoo_list$Change_fr_52_week_low = (yahoo_list$Price - yahoo_list$fifty_two_weeklow)/yahoo_list$fifty_two_weeklow

write.csv(yahoo_list,"yahoo_info3.csv",row.names = FALSE)

# library("googlesheets")
# 
# gs_ls()
# dat = gs_title("JR_Investment")

# dat <- dat %>%
#   gs_edit_cells(ws = "Yahoo", input = yahoo_list, trim = TRUE)

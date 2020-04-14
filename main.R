#install.packages("rvest")
rm(list = ls())
library(rvest)
options(scipen=999)

url_base <- "http://cr.justice.gov.lb/search/result.aspx?id="

RecordsIndex <- list()
CorporateRecords <- list()
CorporateStructure <- list()
Branches <- list()
Contracts <- list()
Representations <- list()
CourtDecisions <- list()

CorporateRecords_colnames <- c("reg_number", "name", "name_supp", "mouhafaza", "reg_date", "reg_type", "status", "duration", "legal_form", "capital", "address", "activity")

# 1000000000 is Beirut
# 2000000000 is Mount Leb
# 3000000000 is Shmel
# 4000000000 is Beqaa
# 6000000000 is Jnoub

for (search_id in 1000000000:1001095945){
  print(search_id)
  url <- paste0(url_base, as.character(search_id))
  
  record <- tryCatch(
    { 
      read_html(url)
    },
    error=function(e){
      return(NA)
    })
  
  if(!is.na(record)){
    #Sys.sleep(5)
    record_info <- sapply(X = 1:12, FUN = function(i){record %>% html_node(xpath=paste0('//*[@id="DataList1_Label', i,'_0"]')) %>% html_text()})
    
    record_id <- record_info[1]
    persons <- tryCatch(
      { 
        record %>% html_node(xpath='//*[@id="Relations_ListView_itemPlaceholderContainer"]') %>%  html_table(fill = TRUE)
      },
      error=function(e){
        return(NA)
      })
    
    branches <- tryCatch(
      { 
        record %>% html_node(xpath='//*[@id="ListView1_itemPlaceholderContainer"]') %>%  html_table(fill = TRUE)
      },
      error=function(e){
        return(NA)
      })
    
    representations <- tryCatch(
      { 
        record %>% html_node(xpath='//*[@id="RepresentationsListView_itemPlaceholderContainer"]') %>%  html_table(fill = TRUE)
      },
      error=function(e){
        return(NA)
      })
    

    contracts <- tryCatch(
      { 
        record %>% html_node(xpath='//*[@id="ContractsListView_itemPlaceholderContainer"]') %>%  html_table(fill = TRUE)
      },
      error=function(e){
        return(NA)
      })
    

    courtdecisions <- tryCatch(
      { 
        record %>% html_node(xpath='//*[@id="Court_decisionsListView_itemPlaceholderContainer"]') %>%  html_table(fill = TRUE)
      },
      error=function(e){
        return(NA)
      })
    
    
  } else {
    record_info <- NA
    record_id <- NA
    persons <- NA
    branches <- NA
    representations <- NA
    contracts <- NA
    courtdecisions <- NA
  }
  search_id <- as.character(search_id)
  RecordsIndex[[search_id]] <- record_id
  CorporateRecords[[search_id]] <- record_info
  CorporateStructure[[search_id]] <- persons
  Branches[[search_id]] <- branches
  Representations[[search_id]] <- representations
  Contracts[[search_id]] <- contracts
  CourtDecisions[[search_id]] <- courtdecisions
  
  closeAllConnections()
  
  #Sys.sleep(1)
}

#get_record(1000000001)




#install.packages("rvest")

library(rvest)
url_base <- "http://cr.justice.gov.lb/search/result.aspx?id="

RecordsIndex <- list()
CorporateRecords <- list()
CorporateStructure <- list()
Branches <- list()
Contracts <- list()
Representations <- list()
CourtDecisions <- list()

CorporateRecords_colnames <- c("reg_number", "name", "name_supp", "mouhafaza", "reg_date", "reg_type", "status", "duration", "legal_form", "capital", "address", "activity")

get_record <- function(search_id){
url <- paste0(url_base, search_id)

record <- read_html(url)
record_info <- sapply(X = 1:12, FUN = function(i){record %>% html_node(xpath=paste0('//*[@id="DataList1_Label', i,'_0"]')) %>% html_text()})

record_id <- record_info[1]
persons <- record %>% html_node(xpath='//*[@id="Relations_ListView_itemPlaceholderContainer"]') %>%  html_table(fill = TRUE)
persons$record_id <- record_id #adds the record id to the persons table
branches <- record %>% html_node(xpath='//*[@id="ListView1_Table1"]') %>%  html_table(fill = TRUE)
representations <- record %>% html_node(xpath='//*[@id="RepresentationsListView_Table2"]') %>%  html_table(fill = TRUE)
contracts <- record %>% html_node(xpath='//*[@id="ContractsListView_Table3"]') %>%  html_table(fill = TRUE)
courtdecisions <- record %>% html_node(xpath='//*[@id="Court_decisionsListView_Table4"]') %>%  html_table(fill = TRUE)

search_id <- as.character(search_id)
RecordsIndex[[search_id]] <- record_id
CorporateRecords[[search_id]] <- record_info
CorporateStructure[[search_id]] <- persons
Branches[[search_id]] <- branches
Representations[[search_id]] <- representations
Contracts[[search_id]] <- contracts
CourtDecisions[[search_id]] <- courtdecisions
}

## Testing
#search_id0 <- 1000095945
#get_record(search_id0)

# 1000000000 is Beirut
# 2000000000 is Mount Leb
# 3000000000 is Shmel
# 4000000000 is Beqaa
# 6000000000 is Jnoub

for (search in 1000000000:1000095945){
  get_record(search)
}





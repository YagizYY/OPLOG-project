# rm(list = ls())
# .rs.restartR()

source("C:/Users/yagiz/Desktop/oplog_project/Cities.R")

library(readxl) 
library(lubridate)
library(data.table)

# read address & sales_orders datasets
reader_xlsx <- function(read_bucket , folder_path, columns){
  files = list.files(folder_path ,read_bucket)
  files = files[which(files %like% ".xlsx")]

  holder = list()
  my_index=1
  
  for (i in files){

    aa = read_excel(file.path(folder_path,i))[columns]

    holder[[my_index]] = aa
    rm(aa); gc();
    my_index=my_index+1
  }
  
  holder = rbindlist(holder)
  holder = as.data.table(holder)
  return(holder)
}
  

address <- reader_xlsx('xlsx',
                       "C:/Users/yagiz/Desktop/PilotStudyData/PilotStudyData/Address",
                       c("SalesOrdersId","Country","City","District"))

sales_orders <- reader_xlsx('xlsx',
                            "C:/Users/yagiz/Desktop/PilotStudyData/PilotStudyData/SalesOrders,
        c("SalesOrdersId","ProductId","Amount", "CreatedAt"))

################################################################################

sales_orders <- sales_orders[!duplicated(sales_orders)]

# correct date column
setnames(sales_orders, "CreatedAt", "Date")
sales_orders[, Date := as.Date(substr(Date, 1, 10), format="%Y-%m-%d")]

# lower characters
address[, c("Country","City","District") := list(tolower(Country),
                            tolower(City), tolower(District))]

source <- ("þçðöüý")
change <- ("scgoui")

address[, c("Country","City","District") := list(chartr(
  source,change,address[,Country]),chartr(source,change,address[,City]), 
  chartr(source,change,address[,District]))]

address[Country == "turkey", Country := "turkiye"]

address <- address[!(City == "turkiye" & is.na(District))]
address <- address[!(City == "merkez" & is.na(District))]

address[City == "n/a", City := NA]
address[District == "n/a", District := NA]

address <- address[!duplicated(address)]


# Correct district names
for (i in tur_city){
  assign(paste0("district_",i), tolower(get(paste0("district_",i))))
  assign(paste0("district_",i), chartr(source,change,
                                       get(paste0("district_",i))))
}


## Country by City
addresso <- unique(address[Country != "turkiye", Country])
for (i in (1:length(tur_city))){
  address[Country %chin% unique(addresso[addresso %like% tur_city[i]]), 
        Country := "turkiye"]
}

## Country by District
for (j in tur_city){
  for (i in (1:length(get(paste0("district_",j))))){
    address[Country %chin% unique(addresso[addresso %like% 
           get(paste0("district_",j))[i]]), Country := "turkiye"]
 }
}

address[Country == "izmit", Country := "turkiye"]
address[Country == "tur", Country := "turkiye"]


address <- address[Country == "turkiye"]

address <- address[!(City == "turkey" & is.na(District))]

## City names in cities
for (i in (1:length(tur_city))){
  addresso <- unique(address[,City])
  address[City %chin% unique(addresso[addresso %like% tur_city[i]]), 
          City := tur_city[i]]
  }

# City names in districts
addresso <- unique(address[,District])
for (i in (1:length(tur_city))){
  address[District %chin% unique(addresso[addresso %like% tur_city[i]]), 
          City := tur_city[i]]
}

# District names in cities
addresso <- unique(address[!(City %chin% tur_city), City])
for (j in tur_city){
  for (i in (1:length(get(paste0("district_",j))))){
    address[City %chin% unique(addresso[addresso %like% 
                get(paste0("district_",j))[i]]), City := j]
  }
}



# District names in Districts
addresso <- unique(address[!(City %chin% tur_city), District])
for (j in tur_city){
  for (i in (1:length(get(paste0("district_",j))))){
    address[District %chin% unique(addresso[addresso %like% 
          get(paste0("district_",j))[i]]), City := j]
  }
}


# check typos
address[City == "siiirt", City := "siirt"]
address[City == "esksehir", City := "eskisehir"]
address[City == "sakarka", City := "sakarya"]
address[City == "icel", City := "mersin"]
address[City == "hakkeri", City := "hakkari"]
address[City == "izmit", City := "kocaeli"]
address[City == "antakya", City := "hatay"]
address[City == "afana", City := "adana"]
address[District == "kocaeli", City:="kocaeli"]
address[City == "buraa", City := "bursa"]
address[City == "antlaya", City := "antalya"]
address[City == "yalove", City := "yalova"]
address[City == "iznir", City := "izmir"]
address[City == "	istenbil", City := "istanbul"]
address[City == "gaziantrp", City := "gaziantep"]
address[City == "bursq", City := "bursa"]
address[City == "adaba", City := "adana"]
address[City == "adama", City := "adana"]
address[City == "amasyda", City := "amasya"]
address[City == "amaya merkez", City := "amasya"]
address[City == "anakara", City := "ankara"]
address[City == "anatalya", City := "antalya"]
address[City == "amtalya", City := "antalya"]
address[City == "anatalya", City := "antalya"]
address[City == "anara", City := "ankara"]
address[City == "anlata", City := "ankara"]
address[City == "anatalya", City := "antalya"]
address[City == "bakikesir", City := "balikesir"]
address[City == "baliikesir", City := "baliikesir"]
address[City == "baetin", City := "bartin"]
address[City == "bandirm", City := "bandirma"]
address[City == "demizli", City := "denizli"]
address[City == "anlara", City := "ankara"]
address[City == "malataya", City := "malatya"]
address[City == "anlara", City := "ankara"]
address[City == "izmri", City := "izmir"]
address[City == "izmsr", City := "izmir"]
address[City == "izir", City := "izmir"]
address[City == "izimir", City := "izmir"]
address[City == "ismir", City := "izmir"]
address[City == "eskissehir", City := "eskisehir"]
address[City == "eskishir", City := "eskisehir"]
address[City == "eskisekir", City := "eskisehir"]
address[City == "eskisejir", City := "eskisehir"]
address[City == "eskisehie", City := "eskisehir"]
address[City == "eskisehgt", City := "eskisehir"]
address[City == "ekisehir", City := "eskisehir"]
address[City == "	ediene", City := "edirne"]
address[City == "	edirme", City := "edirne"]
address[City == "edirn", City := "edirne"]
address[City == "edirn", City := "edirne"]
address[City == "sansun", City := "samsun"]
address[City == "ankra", City := "ankara"]
address[City == "anakra", City := "ankara"]
address[City == "ankqra", City := "ankara"]


addresso <- unique(address[!(City %chin% tur_city), City])

address[City %chin% unique(addresso[addresso %like% "izmi"]),
        City := "izmir"]

address[City %chin% unique(addresso[addresso %like% "balik"]),
        City := "balikesir"]

address[City %chin% unique(addresso[addresso %like% "esir"]),
        City := "balikesir"]

address[City %chin% unique(addresso[addresso %like% "mersi"]),
        City := "mersin"]

address[City %chin% unique(addresso[addresso %like% "mug"]),
        City := "mugla"]

address[City %chin% unique(addresso[addresso %like% "anka"]),
        City := "ankara"]

address[City %chin% unique(addresso[addresso %like% "samsu"]),
        City := "samsun"]

address[City %chin% unique(addresso[addresso %like% "zong"]),
        City := "zonguldak"]

address[City %chin% unique(addresso[addresso %like% "zomg"]),
        City := "zonguldak"]

address[City %chin% unique(addresso[addresso %like% "bul"]), 
        City := "istanbul"]

address[City %chin% unique(addresso[addresso %like% "ista"]), 
        City := "istanbul"]

address[City %chin% unique(addresso[addresso %like% "talya"]),
        City := "antalya"]

address[City %chin% unique(addresso[addresso %like% "anta"]), 
        City := "antalya"]


address <- address[City %in% tur_city]
address[, c("Country", "District") := NULL]


# write to rds
# saveRDS(address, "C:/Users/yagiz.yaman/Desktop/Oplog/data/address.rds")
# saveRDS(sales_orders, "C:/Users/yagiz.yaman/Desktop/Oplog/data/sales_orders.rds")

# read from rds
# address <- readRDS("C:/Users/yagiz.yaman/Desktop/Oplog/data/address.rds")
# sales_orders <- readRDS("C:/Users/yagiz.yaman/Desktop/Oplog/data/sales_orders.rds")

x <- c()
for (i in tur_city){
 x <- c(x, paste0("district_",i))  
}

rm(list = x, tur_city, i,j, source, change, addresso)

setkey(address, "SalesOrdersId")
setkey(sales_orders, "SalesOrdersId")

sales <- address[sales_orders]  

setcolorder(sales, c("SalesOrdersId","ProductId", "City", "Amount", "Date"))

sales <- sales[!(is.na(City))]

saveRDS(sales, "C:/Users/yagiz/Desktop/oplog_project/Forecast/sales.rds")

rm(list = ls())





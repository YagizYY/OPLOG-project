library(data.table)
library(lubridate)
#library(ggplot2)

#source("C:/Users/yagiz/Desktop/oplog_project/11_Oplog.R")

sales <- readRDS("C:/Users/yagiz/Desktop/oplog_project/Forecast/sales.rds")

# Take dates after "2021-01-01" due to covid
sales0 <- sales[Date >= "2021-01-01"]

## CLUSTERS ##
Zone_1 <- c("bitlis", "van", "mus", "agri", "igdir", "bingol", "elazig", 
          "tunceli", "mardin", "batman", "siirt", "hakkari", "sirnak",
          "diyarbakir","artvin", "ardahan", "kars", "rize","erzurum", 
          "erzincan", "trabzon", "bayburt","gumushane", "giresun", 
          "malatya", "maras", "adiyaman", "urfa", "antep", "osmaniye", "kilis",
         "hatay", "adana")

Zone_2 <- c("ordu", "tokat", "amasya", "samsun", "sinop", "kastamonu", "bartin",
         "karabuk", "cankiri", "bolu", "duzce", "zonguldak", "kocaeli", 
         "sakarya", "corum", "yalova")

Zone_3 <- c("bilecik", "bursa", "canakkale", "balikesir", "kutahya","manisa",
         "izmir","usak", "afyon", "isparta", "antalya","burdur", "mugla",
         "denizli", "aydin")

Zone_4 <- c("edirne", "kirklareli", "tekirdag", "istanbul")

Zone_5 <- c("kirikkale", "kirsehir", "yozgat", "nevsehir", 
             "kayseri", "sivas","aksaray","nigde", "konya", "karaman", 
            "mersin", "ankara", "eskisehir")

zones <- c("Zone_1", "Zone_2", "Zone_3", "Zone_4", "Zone_5")

# Summing the sales day by day
sales1 <- sales0[, .(Sales = sum(Amount)),
                 .(ProductId, City, Date)]

# Creating Zone column
for (i in zones) {
  sales1[City %chin% get(i), Zone := i]
}


# Summing the sales according to zone level
sales2 <- sales1[, .(Sales = sum(Sales)), .(Zone, ProductId, Date)]


# Eliminate outlier sales
sales2 <-
  sales2[Sales > quantile(Sales, 0.25) - (3) * IQR(Sales) &
           Sales < quantile(Sales, 0.75) + (3) * IQR(Sales)
         ,
         .(Date, Sales),
         .(Zone, ProductId)]


# Bar chart for sales per zone

# ggplot(sales2, aes(x=Zone, y= sum(Sales))) +
#    geom_bar(stat = "identity") +
#    labs(x = "Zones", y = "Total Sales") +
#    ggtitle("Sales by Zones") +
#    theme_bw()


# Creating Year, Month and Week columns
sales2[, c("Year", "Month", "Week") := list(year(Date), month(Date), week(Date))]

# Aggregate sales weekly
sales2 <- sales2[, .(Sales = sum(Sales)),
                 .(Zone, ProductId, Year, Week)]

# Create a YearWeek column which looks like 2021,24 for ex.
sales2[, YearWeek := paste0(Year, ",", Week)]

# Sales Frequency Ratio will be calculated below
get_info <- sales2[order(Zone, ProductId, Year, Week)]
get_info <- get_info[, .SD[1], .(Zone, ProductId)]
max_year <- get_info[, max(Year)]
max_year_week <- get_info[Year == max(Year), max(Week)]
min_year <- get_info[, min(Year)]
min_year_week <- get_info[Year == min(Year), min(Week)]
get_info <-
  get_info[, .(starting_week_sales = (Year - min_year) * 53 -
                 min_year_week + Week), .(Zone, ProductId)]

week_horizon <-
  (max_year - min_year) * 53 - min_year_week + max_year_week + 1

sfr <-
  sales2[, .(count_week = uniqueN(YearWeek)), .(Zone, ProductId)]
setkey(get_info, "Zone", "ProductId")
setkey(sfr, "Zone", "ProductId")

sfr <- get_info[sfr]

# rm(list = c(
#   max_year,
#   max_year_week,
#   min_year,
#   min_year_week,
#   get_info,
#   sales1
# ))

sfr[, sfr := count_week / (week_horizon + 1 - starting_week_sales) , ProductId]

# Using number of weeks subject to sales and sfr, categorize products.
direct_assignment <- sfr[count_week < 20 & sfr < 0.65]
ma <- sfr[count_week < 20 & sfr >= 0.65]
croston <- sfr[count_week >= 20 & sfr < 0.65]
machine_learning <- sfr[count_week >= 20 & sfr >= 0.65]

# arrange direct_assignment
direct_assignment <- direct_assignment[order(Zone, ProductId)]
direct_assignment[, c("starting_week_sales", "count_week", "sfr") := NULL]

sales_sum <-
  sales2[, .(total_sales = sum(Sales)), .(Zone, ProductId)]

setkey(direct_assignment, "Zone", "ProductId")
setkey(sales_sum, "Zone", "ProductId")

direct_assignment <- sales_sum[direct_assignment]

# Arrange ma dataset

# We want to create weekly sales but there are weeks that have not any sales. 
# We should add those weeks and corresponding sales column should be zero for
# those ones.
# 

ma <- ma[order(Zone, ProductId)]

x <- unique(ma[, .(Zone, ProductId)])
zone <- x[, Zone]
product <- x[, ProductId]

zone <- rep(zone, week_horizon)
product <- rep(product, week_horizon)

connector <- data.table(
  Zone = zone,
  ProductId = product
)

connector <- connector[order(Zone, ProductId)]

week <- c(min_year_week:53)
week <- c(week, rep(1:53, max_year - min_year - 1))
week <- c(week, 1:max_year_week)
week <- rep(week, nrow(x))

year <- rep(min_year, length(min_year_week:53))
year <-
  c(year, rep((min_year + 1):(max_year - 1), 53 * (max_year - min_year -
                                                     1)))
year <- c(year, rep(max_year, length(1:max_year_week)))
year <- rep(year, nrow(x))

connector[, c("Year", "Week") := list(year, week)]

connector <- connector[order(Zone, ProductId, Year, Week)]

ma[, c("count_week", "sfr", "starting_week_sales") := NULL]
ma[, ML := 1]

setkey(sales2, "Zone", "ProductId")
setkey(ma, "Zone", "ProductId")

ma <- ma[sales2]
ma <- ma[ML == 1]

setkey(ma, "Zone", "ProductId", "Year", "Week")
setkey(connector, "Zone", "ProductId", "Year", "Week")

ma <- ma[, .(Zone, ProductId, Year, Week,
             Sales)][connector]

ma[is.na(Sales), Sales := 0]


ma[, Date := as.Date(paste0(
  ifelse(Week > 52, Year + 1, Year),
  "-W",
  sprintf("%02d", ifelse(Week > 52, 1, Week)),
  "-1"
),
format = "%Y-W%W-%u")]

ma <- ma[, .(Sales = sum(Sales)),
         .(Zone, ProductId, Date)]

ma <- ma[order(Zone, ProductId, Date)]

ma <- ma[, c("Year", "Week") := list(year(Date),
                                     week(Date))]

ma[, WeekOrder := 1:.N, .(Zone, ProductId)]

setcolorder(ma,
            c(
              "Zone",
              "ProductId",
              "Year",
              "Week",
              "Date",
              "Sales",
              "WeekOrder"
            ))


# Arrange croston
croston <- croston[order(Zone, ProductId)]

x <- unique(croston[, .(Zone, ProductId)])
zone <- x[, Zone]
product <- x[, ProductId]

zone <- rep(zone, week_horizon)
product <- rep(product, week_horizon)

connector <- data.table(
  Zone = zone,
  ProductId = product
)

connector <- connector[order(Zone, ProductId)]

week <- c(min_year_week:53)
week <- c(week, rep(1:53, max_year - min_year - 1))
week <- c(week, 1:max_year_week)
week <- rep(week, nrow(x))

year <- rep(min_year, length(min_year_week:53))
year <-
  c(year, rep((min_year + 1):(max_year - 1), 53 * (max_year - min_year -
                                                     1)))
year <- c(year, rep(max_year, length(1:max_year_week)))
year <- rep(year, nrow(x))

connector[, c("Year", "Week") := list(year, week)]

connector <- connector[order(Zone, ProductId, Year, Week)]

croston[, c("count_week", "sfr", "starting_week_sales") := NULL]
croston[, ML := 1]

setkey(sales2, "Zone", "ProductId")
setkey(croston, "Zone", "ProductId")

croston <- croston[sales2]
croston <- croston[ML == 1]

setkey(croston, "Zone", "ProductId", "Year", "Week")
setkey(connector, "Zone", "ProductId", "Year", "Week")

croston <- croston[, .(Zone, ProductId, Year, Week,
                       Sales)][connector]

croston[is.na(Sales), Sales := 0]


croston[, Date := as.Date(paste0(
  ifelse(Week > 52, Year + 1, Year),
  "-W",
  sprintf("%02d", ifelse(Week > 52, 1, Week)),
  "-1"
),
format = "%Y-W%W-%u")]

croston <- croston[, .(Sales = sum(Sales)),
                   .(Zone, ProductId, Date)]

croston <- croston[order(Zone, ProductId, Date)]

croston <- croston[, c("Year", "Week") := list(year(Date),
                                               week(Date))]

croston[, WeekOrder := 1:.N, .(Zone, ProductId)]

setcolorder(croston,
            c(
              "Zone",
              "ProductId",
              "Year",
              "Week",
              "Date",
              "Sales",
              "WeekOrder"
            ))



# Arrange machine_learning dataset
machine_learning <- machine_learning[order(Zone, ProductId)]

x <- unique(machine_learning[, .(Zone, ProductId)])
zone <- x[, Zone]
product <- x[, ProductId]

zone <- rep(zone, week_horizon)
product <- rep(product, week_horizon)

connector <- data.table(
  Zone = zone,
  ProductId = product
)

connector <- connector[order(Zone, ProductId)]

week <- c(min_year_week:53)
week <- c(week, rep(1:53, max_year - min_year - 1))
week <- c(week, 1:max_year_week)
week <- rep(week, nrow(x))

year <- rep(min_year, length(min_year_week:53))
year <-
  c(year, rep((min_year + 1):(max_year - 1), 53 * (max_year - min_year -
                                                     1)))
year <- c(year, rep(max_year, length(1:max_year_week)))
year <- rep(year, nrow(x))

connector[, c("Year", "Week") := list(year, week)]

connector <- connector[order(Zone, ProductId, Year, Week)]

machine_learning[, c("count_week", "sfr", "starting_week_sales") := NULL]
machine_learning[, ML := 1]

setkey(sales2, "Zone", "ProductId")
setkey(machine_learning, "Zone", "ProductId")

machine_learning <- machine_learning[sales2]
machine_learning <- machine_learning[ML == 1]

setkey(machine_learning, "Zone", "ProductId", "Year", "Week")
setkey(connector, "Zone", "ProductId", "Year", "Week")

machine_learning <- machine_learning[, .(Zone, ProductId, Year, Week,
                                         Sales)][connector]

machine_learning[is.na(Sales), Sales := 0]


machine_learning[, Date := as.Date(paste0(
  ifelse(Week > 52, Year + 1, Year),
  "-W",
  sprintf("%02d", ifelse(Week > 52, 1, Week)),
  "-1"
),
format = "%Y-W%W-%u")]

machine_learning <- machine_learning[, .(Sales = sum(Sales)),
                                     .(Zone, ProductId, Date)]

machine_learning <- machine_learning[order(Zone, ProductId, Date)]

machine_learning <- machine_learning[, c("Year", "Week") := list(year(Date),
                                                                 week(Date))]

machine_learning[, WeekOrder := 1:.N, .(Zone, ProductId)]

setcolorder(machine_learning,
            c(
              "Zone",
              "ProductId",
              "Year",
              "Week",
              "Date",
              "Sales",
              "WeekOrder"
            ))

ma <- ma[!(WeekOrder == 109)]
croston <- croston[!(WeekOrder == 109)]
machine_learning <- machine_learning[!(WeekOrder == 109)]

saveRDS(machine_learning,
"C:/Users/yagiz/Desktop/oplog_project/Forecast/for_ML.rds")
saveRDS(croston,
"C:/Users/yagiz/Desktop/oplog_project/Forecast/for_croston.rds")
saveRDS(ma,
"C:/Users/yagiz/Desktop/oplog_project/Forecast/for_ma.rds")
saveRDS(direct_assignment,
"C:/Users/yagiz/Desktop/oplog_project/Forecast/direct_assignment")

rm(list = ls())


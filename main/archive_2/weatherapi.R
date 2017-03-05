library(bitops)
library(RCurl)
library(RJSONIO)

# this is code to extract weather data from weathersource. 
# Reference: https://developer.weathersource.com/documentation/resources/get-history_by_postal_code/
# Data is free up to 10 calls per minute and 1000 calls per day. So be patient. Call for 1 month

weatherhourly <- NULL 
# refer to the latest file
# Change "Admin" to "Tee" for ICME computer
#weatherhourly  <- read.csv("C:/Users/Admin/Dropbox/Active/EnergyProject/Thesis/PVreadingsStudies/main/data/Weather/weathersource/hourly/2013/08641/ver0.csv")
weatherhourly  <- read.csv("C:/Users/Admin/Dropbox/Active/EnergyProject/Thesis/PVreadingsStudies/main/data/Weather/weathersource/hourly/2013/92563/ver1.csv")


# refer to your prefer zipcode
#zipinterest <- '08641'
zipinterest <- '92563'
#timezone <- '-05:00'
timezone <- '-08:00'
# refer to the next time stamp (not in the file)
timetarget <- '2014-10-14T15:00:00'
#timetarget <- '2013-11-25T04:00:00'

api_key <- 'd19a8b0cf05776a9d0f9'
str1 <- 'https://api.weathersource.com/v1/'

#here we want hourly data so period = hour
#str2 <-'/history_by_postal_code.json?period=day&postal_code_eq='
str2 <-'/history_by_postal_code.json?period=hour&postal_code_eq='
str3 <- '&country_eq=US&timestamp_eq='
#this is elements for day
#str4 <-'&fields=postal_code,country,timestamp,tempMax,tempAvg,tempMin,precip,snowfall,windSpdMax,windSpdAvg,windSpdMin,cldCvrMax,cldCvrAvg,cldCvrMin,dewPtMax,dewPtAvg,dewPtMin,feelsLikeMax,feelsLikeAvg,feelsLikeMin,relHumMax,relHumAvg,relHumMin,sfcPresMax,sfcPresAvg,sfcPresMin,spcHumMax,spcHumAvg,spcHumMin,wetBulbMax,wetBulbAvg,wetBulbMin'
#this is elements for hour
str4 <-'&fields=postal_code,country,timestamp,temp,precip,precipConf,snowfall,snowfallConf,windSpd,cldCvr,dewPt,feelsLike,relHum,sfcPres,spcHum,wetBulb'

timetarget <- as.POSIXct(timetarget, origin = "1970-01-01",format = "%Y-%m-%dT%H:%M:%S")


#########################keep running this #######################################

for(i in 1:1000){

url <- paste(str1,api_key,str2,zipinterest,str3, strftime(timetarget,format="%Y-%m-%dT%H:%M:%S"),timezone,str4,sep='')
web <- getURL(url,ssl.verifypeer=FALSE)
raw <-fromJSON(web)

tmp <- lapply( raw, function(u) 
  lapply(u, function(x) if(is.null(x)) NA else x)
)
tmp <- lapply( tmp, as.data.frame )
tmp <- do.call( rbind, tmp )
    #here we want hourly data so use 3600*1 instead of 3600*24
   #startday <- startday + 3600*24
  timetarget <- timetarget + 3600*1

weatherhourly <- rbind(weatherhourly, tmp)
cat(i,"\n")
Sys.sleep(6.1)
}

#############save data###############################

#write.csv(weatherhourly, "C:/Users/Admin/Dropbox/Active/EnergyProject/Thesis/PVreadingsStudies/main/data/Weather/weathersource/hourly/2013/08641/ver1.csv",
#          row.names=FALSE)
write.csv(weatherhourly, "C:/Users/Admin/Dropbox/Active/EnergyProject/Thesis/PVreadingsStudies/main/data/Weather/weathersource/hourly/2013/92563/ver1.csv",
          row.names=FALSE)

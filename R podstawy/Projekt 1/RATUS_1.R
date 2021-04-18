library( sf)      # read shp
library(dplyr)    # pipes

rm(list = ls())

##### FUNCTIONS
myPlot <- function(dataIn, shapeIn, colorScheme = c("orange", "darkred")){
  require(dplyr)
  require(sf)
  colnames(dataIn)[1] <- "JPT_NAZWA_"
  dataIn <- dataIn %>% mutate(JPT_NAZWA_ = tolower(JPT_NAZWA_))
  shapeIn <- shapeIn %>%  right_join(dataIn, by = "JPT_NAZWA_")
  shapeIn %>% select(ncol(.) - 1) %>% plot(pal = colorRampPalette(colorScheme)(nrow(.)), nbreaks = nrow(.)+1)
  
}




##### LOAD DATA 
### Shape
# path <- file.path(tempdir(), "Wojewodztwa.zip", fsep = "/")
# download.file("https://www.gis-support.pl/downloads/Wojewodztwa.zip", path)
# unzip(path, exdir = tempdir())
# shape <- st_read( dsn = file.path(tempdir(), "Wojew??dztwa.shp"))

shape <- st_read( dsn = file.path()) ###### <- Wojewodztwa.shp file path

### Data
data <- read.csv(url("http://michal.ramsza.org/lectures/2_r_programming/data/data_2.csv"), encoding="UTF-8")




##### DATA ANALYSIS
### 1
data1 <- data %>%
  filter( Brand == "Audi" ) %>%
  select( Price, Voivodeship) %>%
  group_by( Voivodeship) %>%
  summarise( "Srednia cena Audi" = mean( Price)) %>%
  arrange( Voivodeship)

myPlot(data1, shape)


### 2
data2_1 <- data %>%
  filter( Brand == "Audi" & Gas_type == "Diesel") %>%
  select( Price, Voivodeship) %>%
  group_by( Voivodeship) %>%
  summarise( "Srednia cena Audi diesel" = mean( Price)) %>%
  arrange( Voivodeship)

myPlot(data2_1, shape)

data2_2 <- data %>%
  filter( Brand == "Audi" & Gas_type != "Diesel") %>%
  select( Price, Voivodeship) %>%
  group_by( Voivodeship) %>%
  summarise( "Srednia cena Audi nie diesel" = mean( Price)) %>%
  arrange( Voivodeship)

myPlot(data2_2, shape)


### 3
data3 <- data2_1 %>% 
  right_join(data2_2, by = "Voivodeship") %>%
  mutate( .[2] - .[3]) %>%
  select(1,2) %>%
  rename("Srednia roznica Audi diesel i nie diesel" = 2)
  
myPlot(data3, shape, colorScheme = c("blue", "white"))






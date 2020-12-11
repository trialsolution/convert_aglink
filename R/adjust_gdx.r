#
#  convert original Aglink .gdx files into a more appropriate format
#
#  output: MTO20XX.gdx file, to be read by scripts/convert_to_gdx.gms
#



# set library path on local computer
.libPaths( c(.libPaths(), "c:/Users/Public/R/libraries_x64_64"))


library(dplyr)
library(gdxrrw)
library(tidyverse)
igdx("c:/Program Files (x86)/GAMS/win64/28.2/")


setwd("c:/Users/Public/jrc_bl")


agri19 <- rgdx.param("data/result_EUNMerge_PostM.gdx", "p_dbvar")

agri19 <- as_tibble(agri19)


colnames(agri19) <- c("countries", "commodities", "attributes", "aglinkYears", "value")

agri19 <- agri19 %>% select(countries, attributes, commodities, aglinkYears, value)

# filter out undefined data points (Undf alredy in the input .gdx)
agri19 <- agri19 %>% filter(!is.na(value))



# write to .gdx
#--------------

DATAOUT <- as.data.frame(agri19)

DATAOUT$aglinkYears <- factor(DATAOUT$aglinkYears)
attr(DATAOUT, "symName") <- "DATAOUT"
attr(DATAOUT, "ts")      <- "output cube from Aglink"

# prepare GAMS sets
x <- agri19 %>% group_by(countries) %>% summarise(value = sum(value))
countries <- x$countries
countries <- as.data.frame(countries)
attr(countries, "symName") <- "countries"
attr(countries, "ts")      <- "countries in the output cube from Aglink"


x <- agri19 %>% group_by(attributes) %>% summarise(value = sum(value))
attributes <- x$attributes
attributes <- as.data.frame(attributes)
attr(attributes, "symName") <- "attributes"
attr(attributes, "ts")      <- "attributes in the output cube from Aglink"


x <- agri19 %>% group_by(commodities) %>% summarise(value = sum(value))
commodities <- x$commodities
commodities <- as.data.frame(commodities)
attr(commodities, "symName") <- "commodities"
attr(commodities, "ts")      <- "commodities in the output cube from Aglink"


x <- agri19 %>% group_by(aglinkYears) %>% summarise(value = sum(value))
aglinkYears <- x$aglinkYears
aglinkYears <- as.data.frame(aglinkYears)
attr(aglinkYears, "symName") <- "aglinkYears"
attr(aglinkYears, "ts")      <- "aglinkYears in the output cube from Aglink"


# 'tuple' will hold the combinations of (countries, attributes, commodities) with data
x <- agri19 %>% group_by(countries, attributes, commodities) %>% summarise(value = sum(value))
tuple <- x %>% select(-value)
tuple <- as.data.frame(tuple)
attr(tuple, "symName") <- "tuple"
attr(tuple, "ts")      <- "tuples in the output cube from Aglink"

rm(x)

wgdx.lst("data/MTO_2019.gdx", list(DATAOUT, commodities, attributes, aglinkYears, countries, tuple))


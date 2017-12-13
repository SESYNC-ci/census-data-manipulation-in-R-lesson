## Used command line to wget and unzip data from: https://www2.census.gov/programs-surveys/cbp/datasets/2015/cbp15co.zip
## File layout available at: https://www2.census.gov/programs-surveys/rhfs/cbp/technical%20documentation/2015_record_layouts/county_layout_2015.txt
## NAICS code list at: https://www.naics.com/search/

library(magrittr)
library(dplyr)

cbp15 <- read.csv('~/censusdat/cbp15co.txt') %>%
         select(FIPSSTATE, FIPSCTY, NAICS, EST)


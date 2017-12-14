## Used command line to wget and unzip data from: https://www2.census.gov/programs-surveys/cbp/datasets/2015/cbp15co.zip
## File layout available at: https://www2.census.gov/programs-surveys/rhfs/cbp/technical%20documentation/2015_record_layouts/county_layout_2015.txt
## NAICS code list at: https://www.naics.com/search/

library(magrittr)
library(dplyr)

# Select only identifiers and number of establishments
cbp15 <- read.csv('~/censusdat/cbp15co.txt') %>%
         select(FIPSTATE, FIPSCTY, NAICS, EST)

# Limit to two-digit NAICS and create new var with that two digits 
# cbp15_2 has one record per county per 2-digit NAICS, where EST for the code !=0
cbp15_2 <- filter(cbp15, substr(NAICS, 3, 6)=='----') %>%
       mutate(naics = as.numeric((ifelse(substr(NAICS,1,2) != '--', substr(NAICS,1,2), 0)))) %>%
       select(-NAICS)
  
# TODO: Make a new variable that combines state and county fips by combining and padding the
# two separate vars


# Create data set of NAICS codes
naics <- c(11,21,22,23,31,42,44,48,51,52,53,54,55,56,61,62,71,72,81,92,0)
naicsTxt <- c('Agriculture, Forestry, Fishing and Hunting',
       'Mining',
       'Utilities',
       'Construction',
       'Manufacturing',
       'Wholesale Trade',
       'Retail Trade',
       'Transportation and Warehousing',
       'Information',
       'Finance and Insurance',
       'Real Estate Rental and Leasing',
       'Professional, Scientific, and Technical Services',
       'Management of Companies and Enterprises',
       'Administrative and Support and Waste Management and Remediation Services',
       'Educational Services',
       'Health Care and Social Assistance',
       'Arts, Entertainment, and Recreation',
       'Accommodation and Food Services',
       'Other Services (except Public Administration)',
       'Public Administration',
       'TOTAL')
naicsDat<-data.frame(cbind(naics,naicsTxt))

# TODO: decide whether to make naics code numeric to match cbp15_2


# TODO: Create data set of county names to merge 





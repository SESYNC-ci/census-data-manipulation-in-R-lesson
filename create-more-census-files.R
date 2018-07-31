library(acs)
library(data.table)
library(tidyr)
library(dplyr)
library(stringr)

# nb: API key was installed with acs::api.key.install

# but i can't get this to work
# geo <- geo.make(us = "*", county = "*")
# census <- acs.fetch(endyear = 2015, span = 5, geo, table.number = "S2413")

# data downloaded manually from
# https://factfinder.census.gov/faces/tableservices/jsf/pages/productview.xhtml?pid=ACS_15_5YR_S2413&prodType=table
# https://www.census.gov/eos/www/naics/downloadables/downloadables.html

# map between codes and titles
naics <- fread('data/ACS/2-digit_2012_Codes.csv') %>%
  mutate(Title = gsub('[[:punct:]]', '', tolower(`2012 NAICS US Title`))) %>%
  select(Title, code = `2012 NAICS US   Code`) %>%
  filter(nchar(code) == 2 | str_detect(code, '-')) %>%
  rowwise() %>%
  do(
    data.frame(., NAICS = as.character(
      seq(str_extract(.$code, '^[^-]+'), str_extract(.$code, '[^-]+$'))),
      stringsAsFactors = FALSE)
  ) %>%
  select(Sector = Title, NAICS)
write.csv(naics, 'data/ACS/sector_naics.csv', row.names = FALSE)

# join to ACS description of column variables
meta <- fread('data/ACS/ACS_15_5YR_S2413_metadata.csv', header = FALSE) %>%
  setnames(c('acs_var', 'desc')) %>%
  mutate(Sector = gsub(
    '[[:punct:]]', '',
    tolower(str_trim(str_extract(desc, "[^;-]+$"))))) %>%
  semi_join(naics) %>%
  select(acs_var, Sector)

# tidy the ACS data and add naics codes
acs <- fread('data/ACS/ACS_15_5YR_S2413.csv',
    colClasses = c(GEO.id2 = 'character')
  ) %>%
  select(starts_with('GEO'), starts_with('HC01_EST')) %>%
  gather(key = 'acs_var', value = 'median_income', -starts_with('GEO')) %>%
  inner_join(meta) %>%
  select(FIPS = GEO.id2, County = `GEO.display-label`, Sector, median_income)
write.csv(acs, 'data/ACS/sector_ACS_15_5YR_S2413.csv', row.names = FALSE)

## FIXME
# so it turns out that the CBP data don't seem to actually use any but
# the code in any ACS range. E.G. the ACS has "manufacturing", which should map
# to '31-33', but only 31 appears in the CBP data.
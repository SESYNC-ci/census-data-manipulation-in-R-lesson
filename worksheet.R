## Tidy data concept

# evaluate the next command to create response
response <- read.csv(text = "
trial, drug_A, drug_B, placebo
1,     0.22,   0.58,   0.31
2,     0.12,   0.98,   0.47
3,     0.42,   0.19,   0.40
")

## Reshaping multiple columns in category/value pairs

library(...)
tidy_response <- gather(...,
  ...)

# evaluate the next command to create counts
counts <- read.csv(text = "
site, species, n
1,    lynx,    2
1,    hare,    341
2,    lynx,    7
2,    hare,    42
3,    hare,    289
")

wide_counts <- ...(counts,
			...,
			...)

wide_counts <- spread(counts,
  key = species,
  value = n,
  ...)

## Exercise 1

...

## Read comma-separated-value (CSV) files

library(...)
cbp <- ...

cbp <- fread(
  'data/cbp15co.csv',
  ...)

## Subsetting and sorting

library(...)

cbp_health_care <- filter(
  ...,
  ...)

library(...)
cbp_health_care <- filter(
  cbp,
  ...,
  ...
)

cbp_health_care <- select(cbp_health_care,
  ...,
  NAICS,
  ...
)

## Exercise 2

...

## Chainning with pipes

library(...)


cbp_health_care <- cbp ...
  ...(
    str_detect(NAICS, '^62'),
    !is.na(as.integer(NAICS))) ...
  ...(
    starts_with('FIPS'),
    NAICS,
    starts_with('EMP'))

## Grouping and aggregation

state_cbp_health_care <- cbp_health_care %>%
    ...(...)

state_cbp_health_care <- cbp_health_care %>%
  group_by(FIPSTATE) ...
  ...  

state_cbp_health_care <- cbp_health_care %>%
  group_by(FIPSTATE) %>%
  summarize(EMP = sum(EMP),
            ...)

## Exercise 3

...


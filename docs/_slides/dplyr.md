---
# filter by NAICS
---

## Key dplyr functions

| Function    | Returns                                            |
|-------------+----------------------------------------------------|
| `filter`    | keep rows that staisfy conditions                  |
| `select`    | keep columns with matching names                   |
| `group_by`  | split data into groups by an existing factor       |
| `mutate`    | apply a transformation to existing [split] columns |
| `summarize` | summarize across rows [and combine split groups]   |

The table above presents the most commonly used functions in [dplyr](){:.rlib}, which we will demonstrate in turn, starting from the `cbp` data frame.
{:.notes}

===

## Subsetting

The cbp table includes character `NAICS` column. Of the 2 million observations, lets see how many observations are left when we keep only observations from the Health Care and Social Assistance sector.


~~~r
library(dplyr)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===


~~~r
cbp_health_care <- filter(
  cbp,
  NAICS == '62----')
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

That may not be what we wanted, because it's the aggregated data.


~~~r
str(cbp_health_care)
~~~
{:.input}
~~~
'data.frame':	3171 obs. of  26 variables:
 $ FIPSTATE: chr  "01" "01" "01" "01" ...
 $ FIPSCTY : chr  "001" "003" "005" "007" ...
 $ NAICS   : chr  "62----" "62----" "62----" "62----" ...
 $ EMPFLAG : chr  NA NA NA NA ...
 $ EMP_NF  : chr  "G" "G" "G" "H" ...
 $ EMP     : int  1618 7507 679 620 958 404 894 6088 673 449 ...
 $ QP1_NF  : chr  "G" "G" "G" "H" ...
 $ QP1     : int  12038 72416 5262 4698 7861 3016 8089 54848 5240 4176 ...
 $ AP_NF   : chr  "G" "G" "G" "H" ...
 $ AP      : int  50965 308177 22234 20161 33012 12961 32906 238227 22789 17087 ...
 $ EST     : int  93 493 45 26 53 14 41 270 57 37 ...
 $ N1_4    : int  34 191 21 8 20 5 11 104 23 14 ...
 $ N5_9    : int  21 123 12 6 14 3 12 65 15 12 ...
 $ N10_19  : int  22 112 7 3 9 3 12 47 11 5 ...
 $ N20_49  : int  10 43 3 8 6 1 2 31 5 5 ...
 $ N50_99  : int  3 15 0 0 1 0 1 15 3 0 ...
 $ N100_249: int  2 7 2 0 3 2 3 6 0 1 ...
 $ N250_499: int  1 0 0 1 0 0 0 1 0 0 ...
 $ N500_999: int  0 2 0 0 0 0 0 0 0 0 ...
 $ N1000   : int  0 0 0 0 0 0 0 1 0 0 ...
 $ N1000_1 : int  0 0 0 0 0 0 0 1 0 0 ...
 $ N1000_2 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_3 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_4 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ CENSTATE: chr  "63" "63" "63" "63" ...
 $ CENCTY  : chr  "001" "003" "005" "007" ...
 - attr(*, ".internal.selfref")=<externalptr> 
~~~
{:.output}

===


~~~r
library(stringr)
cbp_health_care <- filter(
  cbp,
  str_detect(NAICS, '^62'),
  !is.na(as.integer(NAICS))
  )
~~~
{:.text-document title="{{ site.handouts[0] }}"}

Note that a logical "and" is implied when conditions are separated by commas.
(This is perhaps the main way in which `filter` differs from the base R `subset`
function.) Therefore, the example above is equivalent to `filter(cbp,
str_detect(NAICS, '^62') & !is.na(as.integer(NAICS)))`. A logical "or" must be
specified explicitly with the `|` operator.
{:.notes}

===

To keep particular columns of a data frame (rather than choosing rows) , use the `select` with arguments that match the column names.


~~~r
names(cbp)
~~~
{:.input}
~~~
 [1] "FIPSTATE" "FIPSCTY"  "NAICS"    "EMPFLAG"  "EMP_NF"   "EMP"     
 [7] "QP1_NF"   "QP1"      "AP_NF"    "AP"       "EST"      "N1_4"    
[13] "N5_9"     "N10_19"   "N20_49"   "N50_99"   "N100_249" "N250_499"
[19] "N500_999" "N1000"    "N1000_1"  "N1000_2"  "N1000_3"  "N1000_4" 
[25] "CENSTATE" "CENCTY"  
~~~
{:.output}

===

One way to "match" is by including complete names, each one you want to keep:


~~~r
select(cbp_health_care,
  FIPSTATE, FIPSCTY,
  NAICS,
  EMPFLAG, EMP_NF, EMP
)
~~~
{:.input}

===

Alternatively, we can use a "select helper"" to match patterns.


~~~r
cbp_health_care <- select(cbp_health_care,
  starts_with('FIPS'),
  NAICS,
  starts_with('EMP')
)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===


~~~r
str(cbp_health_care)
~~~
{:.input}
~~~
'data.frame':	63231 obs. of  6 variables:
 $ FIPSTATE: chr  "01" "01" "01" "01" ...
 $ FIPSCTY : chr  "001" "001" "001" "001" ...
 $ NAICS   : chr  "621111" "621210" "621310" "621320" ...
 $ EMPFLAG : chr  NA NA NA NA ...
 $ EMP_NF  : chr  "G" "H" "G" "J" ...
 $ EMP     : int  156 95 27 36 31 0 0 0 0 0 ...
 - attr(*, ".internal.selfref")=<externalptr> 
~~~
{:.output}

<!--
===

To complete this section, we sort the 1990 winter animals data by descending order of species name, then by ascending order of weight. Note that `arrange` assumes ascending order unless the variable name is enclosed by `desc()`.


~~~r
sorted <- arrange(animals_1990_winter,
                  desc(species_id), weight)
~~~

~~~
Error in arrange(animals_1990_winter, desc(species_id), weight): object 'animals_1990_winter' not found
~~~
{:.text-document title="{{ site.handouts[0] }}"}


~~~r
head(sorted)
~~~
{:.input}
~~~
Error in head(sorted): object 'sorted' not found
~~~
{:.output}
-->

===

## Exercise 2

Write code that returns the annual payroll data for the top level Construction sector ("23----").

[View solution](#solution-2)
{:.notes}

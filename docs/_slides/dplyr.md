---
---

## dplyr Functions

| Function    | Returns                                            |
|-------------+----------------------------------------------------|
| `filter`    | keep rows that staisfy conditions                  |
| `mutate`    | apply a transformation to existing [split] columns |
| `select`    | keep columns with matching names                   |
| `inner_join`| merge columns from separate tables into one table  |
| `group_by`  | split data into groups by an existing factor       |
| `summarize` | summarize across rows [and combine split groups]   |

The table above summarizes the most commonly used functions in
[dplyr](){:.rlib}, which we will demonstrate in turn on data from the U.S.
Census Bureau.
{:.notes}

===

### Filter

The `cbp` table includes character `NAICS` column. Of the 2 million
observations, lets see how many observations are left when we keep only the
2-digit NAICS codes, representing high-level sectors of the economy.



~~~r
library(dplyr)
cbp2 <- filter(cbp,
  grepl('----', NAICS),
  !grepl('------', NAICS))
~~~
{:.text-document title="{{ site.handouts[0] }}"}




~~~r
> str(cbp2)
~~~
{:.input title="Console"}


~~~
'data.frame':	58901 obs. of  26 variables:
 $ FIPSTATE: chr  "01" "01" "01" "01" ...
 $ FIPSCTY : chr  "001" "001" "001" "001" ...
 $ NAICS   : chr  "11----" "21----" "22----" "23----" ...
 $ EMPFLAG : chr  "" "" "" "" ...
 $ EMP_NF  : chr  "H" "H" "H" "G" ...
 $ EMP     : int  70 82 196 372 971 211 2631 124 73 375 ...
 $ QP1_NF  : chr  "H" "H" "H" "G" ...
 $ QP1     : int  790 713 4793 2891 15386 2034 14905 1229 924 4201 ...
 $ AP_NF   : chr  "H" "H" "H" "G" ...
 $ AP      : int  3566 3294 18611 13801 64263 11071 61502 5128 3407 16328 ...
 $ EST     : int  7 3 9 75 24 29 169 16 9 67 ...
 $ N1_4    : int  5 0 2 51 9 18 68 9 5 41 ...
 $ N5_9    : int  1 1 1 13 4 6 41 4 1 18 ...
 $ N10_19  : int  0 1 2 7 4 2 34 1 1 6 ...
 $ N20_49  : int  0 0 3 4 3 3 11 2 2 2 ...
 $ N50_99  : int  1 1 1 0 3 0 11 0 0 0 ...
 $ N100_249: int  0 0 0 0 0 0 3 0 0 0 ...
 $ N250_499: int  0 0 0 0 0 0 1 0 0 0 ...
 $ N500_999: int  0 0 0 0 1 0 0 0 0 0 ...
 $ N1000   : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_1 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_2 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_3 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_4 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ CENSTATE: chr  "63" "63" "63" "63" ...
 $ CENCTY  : chr  "001" "001" "001" "001" ...
 - attr(*, ".internal.selfref")=<externalptr> 
~~~
{:.output}


Note that a logical "and" is implied when conditions are separated by commas.
(This is perhaps the main way in which `filter` differs from the base R `subset`
function.) Therefore, the example above is equivalent to `filter(grepl('----',
NAICS), !grepl('------', NAICS)`. A logical "or", on the other hand, must be
specified explicitly with the `|` operator.
{:.notes}

===

The [stringr](){:.rlib} package makes the use of pattern matching by [regular
expressions] a bit more maneageble, and streamlines this step.



~~~r
library(stringr)
cbp2 <- filter(cbp,
  str_detect(NAICS, '[0-9]{2}----'))
~~~
{:.text-document title="{{ site.handouts[0] }}"}


[regular expressions]: https://stringr.tidyverse.org/articles/regular-expressions.html

===

### Mutate

The `mutate` function is the [dplyr](){:.rlib} answer to updating or altering
your columns. It performs arbitrary operations on existing columns and appends
the result as a new column of the same length.

===

Here's one you've probably needed before:



~~~r
cbp3 <- mutate(cbp2,
  FIPS = str_c(FIPSTATE, FIPSCTY))
~~~
{:.text-document title="{{ site.handouts[0] }}"}


===

Multiple arguments to `mutate` produce multiple transformations.



~~~r
cbp3 <- mutate(cbp2,
  FIPS = str_c(FIPSTATE, FIPSCTY),
  NAICS = str_remove(NAICS, '-+'))
~~~
{:.text-document title="{{ site.handouts[0] }}"}


===

### Chaining Functions

All the functions from the [dplyr](){:.rpkg} package take a data frame as their
first argument, and they return a data frame. This consistent syntax is on
purpose. It is designed for easily chaining data transformations together:
creating a data pipeline that is easy to read and modify.

===

The "pipe" operator (`%>%`) takes the expression on its left-hand side and
inserts it, as the first argument, into the function on its right-hand side.
Equivalent to `sum(c(1,3,5))`, for example, we have:



~~~r
> c(1, 3, 5) %>% sum()
~~~
{:.input title="Console"}


~~~
[1] 9
~~~
{:.output}


===

Additional arguments are accepted---pipe only handles the first.



~~~r
> c(1, 3, 5, NA) %>% sum(na.rm = TRUE)
~~~
{:.input title="Console"}


~~~
[1] 9
~~~
{:.output}


===

The pipe operator's main utility is to condense a chain of operations applied to
the same piece of data, when you don't want any intermediate results. We
can do the `filter` and `mutate` operations from above with one assignment.

===



~~~r
cbp <- cbp %>%
  filter(
    str_detect(NAICS, '[0-9]{2}----')
  ) %>%
  mutate(
    FIPS = str_c(FIPSTATE, FIPSCTY),
    NAICS = str_remove(NAICS, '-+')
  )
~~~
{:.text-document title="{{ site.handouts[0] }}"}


===

### Select

To keep particular columns of a data frame (rather than filtering rows), use
the `select` function with arguments that match column names.



~~~r
> names(cbp)
~~~
{:.input title="Console"}


~~~
 [1] "FIPSTATE" "FIPSCTY"  "NAICS"    "EMPFLAG"  "EMP_NF"   "EMP"     
 [7] "QP1_NF"   "QP1"      "AP_NF"    "AP"       "EST"      "N1_4"    
[13] "N5_9"     "N10_19"   "N20_49"   "N50_99"   "N100_249" "N250_499"
[19] "N500_999" "N1000"    "N1000_1"  "N1000_2"  "N1000_3"  "N1000_4" 
[25] "CENSTATE" "CENCTY"   "FIPS"    
~~~
{:.output}


===

One way to "match" is by including complete names, each one you want to keep:



~~~r
> cbp %>%
+   select(
+     FIPS,
+     NAICS,
+     N1_4, N5_9, N10_19 # a better way?
+   )
~~~
{:.input title="Console"}


===

Alternatively, we can use a "select helper"" to match patterns.



~~~r
cbp <- cbp %>%
  select(
    FIPS,
    NAICS,
    starts_with('N')
  )
~~~
{:.text-document title="{{ site.handouts[0] }}"}


---
---

## dplyr Functions

| Function    | Returns                                            |
|-------------+----------------------------------------------------|
| `filter`    | keep rows that satisfy conditions                  |
| `mutate`    | apply a transformation to existing [split] columns |
| `select`    | keep columns with matching names                   |
| `inner_join`| merge columns from separate tables into one table  |
| `group_by`  | split data into groups by an existing factor       |
| `summarize` | summarize across rows [and combine split groups]   |

The table above summarizes the most commonly used functions in
[dplyr](){:.rlib}. We will use [dplyr](){:.rlib} manipulate data frames with the U.S. Census Bureau data in order to prepare for data analysis.
{:.notes}

===

### Filter

The `cbp` table includes character `NAICS` column for industry codes. NAICS codes can have up to 6 digits. As digits increase, the industry code becomes more specific. Of the 2 million observations, lets see how many observations are left when we keep only the 2-digit NAICS codes, representing high-level, broad sectors of the economy.
{:.notes}

We will use the `filter` command to only include rows where the NAICS code is 2 digits long. 

Empty digits are coded as "-"; we only include NAICS codes with 4 dashes using the `grepl` command to find these rows. The filtered data is saved as `cbp2`. 
{:.notes} 



~~~r
library(dplyr)
cbp2 <- filter(cbp,
  grepl('----', NAICS),
  !grepl('------', NAICS))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> str(cbp2)
~~~
{:title="Console" .input}


~~~
Classes 'data.table' and 'data.frame':	58901 obs. of  26 variables:
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
 $ CENSTATE: int  63 63 63 63 63 63 63 63 63 63 ...
 $ CENCTY  : int  1 1 1 1 1 1 1 1 1 1 ...
 - attr(*, ".internal.selfref")=<externalptr> 
~~~
{:.output}


Note that a logical "and" is implied when conditions are separated by commas.
(This is perhaps the main way in which `filter` differs from the base R `subset`
function.) Therefore, the example above is equivalent to `filter(grepl('----',
NAICS) & !grepl('------', NAICS)`. A logical "or", on the other hand, must be
specified explicitly with the `|` operator.
{:.notes}

===

Alternatively, the [stringr](){:.rlib} package makes the use of pattern matching by [regular
expressions] a bit more maneageble, and streamlines this step.



~~~r
library(stringr)
cbp2 <- filter(cbp,
  str_detect(NAICS, '[0-9]{2}----'))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


This code only inclues NAICS codes with any 2 numbers followed by 4 dashes. 
{:.notes}

[regular expressions]: https://stringr.tidyverse.org/articles/regular-expressions.html

===

### Mutate

The `mutate` function is the [dplyr](){:.rlib} answer to updating or altering
your columns. It performs operations on existing columns and appends
the result as a new column of the same length.

===

In the CBP data, FPS codes are split by state and county; however, the convention is to combine into 1 code, concatenating the 2 digit state and 3 digit county code. 

The `mutate` command will add a new column `FIPS` to the cbp2 data frame. Values for the FIPS column will be determined using operation `str_c` from the [stringr](){:.rlib} package. `str_c` combines the FIPS state and county codes. 
{:.notes}



~~~r
cbp3 <- mutate(cbp2,
  FIPS = str_c(FIPSTATE, FIPSCTY))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Multiple arguments to `mutate` produce multiple transformations.



~~~r
cbp3 <- mutate(cbp2,
  FIPS = str_c(FIPSTATE, FIPSCTY),
  NAICS = str_remove(NAICS, '-+'))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


FIPS is a new column. But can also transform the data and rewrite an existing column as done here with NAICS to remove the dashes from the NAICS codes in the `NAICS` column. 
{:.notes}

===

### Chaining Functions

All the functions from the [dplyr](){:.rpkg} package take a data frame as their
first argument, and they return a data frame. This consistent syntax is on
purpose. It is designed for easily chaining data transformations together:
creating a data pipeline that is easy to read and modify.

===

The "pipe" operator (`%>%`) takes the expression on its left-hand side and
inserts it, as the first argument, into the function on its right-hand side. x %>% function() is equivalent to function(x).
{:.notes}


For example, instead of `sum(c(1,3,5))`, we have:



~~~r
> c(1, 3, 5) %>% sum()
~~~
{:title="Console" .input}


~~~
[1] 9
~~~
{:.output}


===

Additional arguments can be added to the function---the pipe only handles the first argument.



~~~r
> c(1, 3, 5, NA) %>% sum(na.rm = TRUE)
~~~
{:title="Console" .input}


~~~
[1] 9
~~~
{:.output}


===

The pipe operator's main utility is to condense a chain of operations applied to the same piece of data, when you don't want any intermediate results. So instead of:
`function_A(function_B(function_C(x)))` 
pipes allow you to do the following:
`x %>% function_A() %>% function_B() %>% function_C()`
{:.notes}

We can do the `filter` and `mutate` operations from above with one assignment.



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
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

### Select

To keep particular columns of a data frame (rather than filtering rows), use
the `select` function with arguments that match column names.



~~~r
> names(cbp)
~~~
{:title="Console" .input}


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
+     N1_4, N5_9, N10_19 
+   )
~~~
{:title="Console" .no-eval .input}


===

Alternatively, we can use a "[select helper](https://dplyr.tidyverse.org/reference/select.html#useful-functions)" to match patterns.



~~~r
cbp <- cbp %>%
  select(
    FIPS,
    NAICS,
    starts_with('N')
  )
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


The `cbp` data frame now only includes columns that we are interested in for the our analysis: the full FIPS county code, the NAICS industry code, and the number of establishments at different employee size classess. 
{:.notes}

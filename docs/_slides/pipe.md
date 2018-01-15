---
---

## Chaining functions

All those functions from the [dplyr](){:.rpkg} package take a data frame as
their first argument, and they return a data frame. This consistent syntax is on
purpose. It is designed for easily chaining data transformations together:
processing data frames in easy-to-read steps.

===

The "pipe" operator (`%>%`) from the [magrittr](){:.rpkg} package is loaded by
[dplyr](){:.rpkg} The pipe takes the expression on its left-hand side and hands
it over as the first argument to the function on its right-hand side.


~~~r
library(magrittr)
~~~
{:.input}
~~~

Attaching package: 'magrittr'
~~~
{:.input}
~~~
The following object is masked from 'package:tidyr':

    extract
~~~
{:.output}

===

Equivalent to `sum(c(1,3,5))`, for example, we have:


~~~r
c(1, 3, 5) %>% sum()
~~~
{:.input}
~~~
[1] 9
~~~
{:.output}

===

Additional arguments are accepted, a pipe only handles the first.


~~~r
c(1, 3, 5, NA) %>% sum(na.rm = TRUE)
~~~
{:.input}
~~~
[1] 9
~~~
{:.output}

===

The pipe operator's main utility is to condense a chain of operations applied to
the same piece of data, when you don't need to save the intermediate results. We
can do both the filter and select operations from above with one assignment.

===


~~~r
cbp_health_care <- cbp %>%
  filter(
    str_detect(NAICS, '^62'),
    !is.na(as.integer(NAICS))) %>%
  select(
    starts_with('FIPS'),
    NAICS,
    starts_with('EMP'))
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

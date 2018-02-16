---
# Would like to do a better demonstration of EAV data versus long data.
# difference being that a single observation (with multiple values) may
# be spread across multiple rows in EAV model.
---

## Gather

The [tidyr](){:.rlib} package's `gather` function reshapes "wide" data frames into "long" ones.


~~~r
library(tidyr)
tidy_response <- gather(response,
  key = "treatment",
  value = "response",
  -trial)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===

All columns, accept for "trial", are stacked in two columns: a "key" and a "value". the key column gets the name `treatment` and the value column reveives the name `response`. For each row in the result, the key is taken from the name of the column and the value from the data in the column.

===


~~~r
tidy_response
~~~
{:.input}
~~~
  trial treatment response
1     1    drug_A     0.22
2     2    drug_A     0.12
3     3    drug_A     0.42
4     1    drug_B     0.58
5     2    drug_B     0.98
6     3    drug_B     0.19
7     1   placebo     0.31
8     2   placebo     0.47
9     3   placebo     0.40
~~~
{:.output}

Some notes on the syntax: a big advantage of [tidyr](){:.rlib} and [dplyr](){:.rlib} is that each function takes a data frame as its first argument and returns a new data frame. As we will see later, it makes it very easy to apply these functions in a chain. All functions also use column names as variables without subsetting them from a data frame (i.e. `trial` instead of `response$trial`).
{:.notes}

===

Some analyses require a "wide" data format rather than the long format produced by `gather`. The community ecology package [vegan](){:.rlib} uses a matrix of species counts, where rows correspond to species and columns to sites.

===

Suppose data are provided in a "entity-attribute-value" format.

site | species | n
1    | lynx    |   2 
1    | hare    | 341 
2    | lynx    |   7 
2    | hare    |  42 
3    | hare    | 289 



===

Transform the data with the `spread` function, which "reverses" a `gather`.


~~~r
wide_counts <- spread(counts,
  key = species,
  value = n)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===


~~~r
wide_counts
~~~
{:.input}
~~~
  site  hare      lynx    
1    1       341         2
2    2        42         7
3    3       289        NA
~~~
{:.output}

===

Question
: Why were `species` and `n` not quoted in the call to `spread`?

Answer
: {:.fragment} They refer to existing column names. In `gather`, quotes are used to create new column names.

===

Think about what "missing data" means in this table. Perhaps you can safely do:


~~~r
wide_counts <- spread(counts,
  key = species,
  value = n,
  fill = 0)
~~~
{:.text-document title="{{ site.handouts[0] }}"}

===


~~~r
wide_counts
~~~
{:.input}
~~~
  site  hare      lynx    
1    1       341         2
2    2        42         7
3    3       289         0
~~~
{:.output}
===

## Exercise 1

Now that we have a wide form of counts, convert it to a `tidy_counts` data frame
using `gather`. The only difference between `counts` and `tidy_counts` should be
the additional row for zero lynx at site 3. Remember, a tidy dataset has a row
for every observation, even if the value is "implied".

[View solution](#solution-1)
{:.notes}

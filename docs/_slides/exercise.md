---
---

## Exercises

===

### Exercise 1

Now that we have a tidy form of `survey`, convert it to a `long_survey` data
frame using `gather`. The only difference between `survey` and `long_survey`
should be an additional row for zero income.

[View solution](#solution-1)
{:.notes}

===

### Exercise 2

Use `filter` and `select` to return just the annual payroll data for the top
level construction sector ("23----").

[View solution](#solution-2)
{:.notes}

===

### Exercise 3

Write code to create a data frame giving, for each state, the number of counties
in the CBP survey with establishements in mining or oil and gas extraction
('21----') along with their total employment ("EMP"). Group the data using
*both* `FIPSTATE` and `FIPSCTY` and use the fact that one call to `summarize`
only combines across the lowest level of grouping. The [dplyr](){:.rlib}
function `n` counts rows in a group.

[View solution](#solution-3)
{:.notes}

===

### Exercise 4

A "pivot table" is a transformation of tidy data into a wide summary table.
First, data are summarized by *two* grouping factors, then one of these is
"pivoted" into columns. Starting from a filtered CBP data file, chain a
split-apply-combine procedure into the [tidyr](){:.rlib} function `spread` to
get the total number of employees ("EMP") in each state (as rows) by 2-digit
NAICS code (as columns).

===

## Solutions

===

### Solution 1



~~~r
> gather(tidy_survey, key = "attr",
+   value = "val", -participant)
~~~
{:.input title="Console"}


~~~
  participant    attr val
1           1     age  24
2           2     age  57
3           3     age  13
4           1  income  30
5           2  income  60
6           3  income   0
~~~
{:.output}


[Return](#exercise-1)
{:.notes}

===

### Solution 2



~~~r
> cbp_23 <- fread('data/cbp15co.csv', na.strings = '') %>%
+   filter(NAICS == '23----') %>%
+   select(starts_with('FIPS'), starts_with('AP'))
~~~
{:.input title="Console"}


~~~
Read 75.2% of 2126601 rowsRead 2126601 rows and 26 (of 26) columns from 0.167 GB file in 00:00:03
~~~
{:.output}


[Return](#exercise-2)
{:.notes}

===

### Solution 3



~~~r
> cbp_21 <- fread('data/cbp15co.csv', na.strings = '') %>%
+   filter(NAICS == '21----') %>%
+   group_by(FIPSTATE, FIPSCTY) %>%
+   summarize(EMP = sum(EMP)) %>%
+   summarize(EMP = sum(EMP), counties = n())
~~~
{:.input title="Console"}


~~~
Read 68.7% of 2126601 rowsRead 2126601 rows and 26 (of 26) columns from 0.167 GB file in 00:00:03
~~~
{:.output}


[Return](#exercise-3)
{:.notes}

===

### Solution 4



~~~r
> pivot <- fread('data/cbp15co.csv', na.strings = '') %>%
+   filter(str_detect(NAICS, '[0-9]{2}----')) %>%
+   group_by(FIPSTATE, NAICS) %>%
+   summarize(EMP = sum(EMP)) %>%
+   spread(key = NAICS, value = EMP)
~~~
{:.input title="Console"}


~~~
Read 72.4% of 2126601 rowsRead 2126601 rows and 26 (of 26) columns from 0.167 GB file in 00:00:03
~~~
{:.output}


[Return](#exercise-4)
{:.notes}

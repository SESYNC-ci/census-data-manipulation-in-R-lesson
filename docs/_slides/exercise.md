---
---

## Exercises

===

### Exercise 1

Now that we have a wide form of counts, convert it to a `tidy_counts` data frame
using `gather`. The only difference between `counts` and `tidy_counts` should be
the additional row for zero lynx at site 3. Remember, a tidy dataset has a row
for every observation, even if the value is "implied".

[View solution](#solution-1)
{:.notes}

===

### Exercise 2

Write code that returns the annual payroll data for the top level Construction
sector ("23----").

[View solution](#solution-2)
{:.notes}

===

### Exercise 3

Write code that fixes `state_cbp_health_care`, which should show the number
of counties and the total employment. Group the data using **both** `FIPSTATE`
and `FIPSCTY` and use the fact that a call to `summarize` only combines across
the lowest level of grouping.

[View solution](#solution-3)
{:.notes}

===
<!--

### Exercise 4

A "pivot table" is a transformation of tidy data into a wide summary table. First, data are summarized by *two* grouping factors, then one of these is "pivoted" into columns. Starting from the `animals` data frame, chain a `group_by` and `summarize` transformation into a [tidyr](){:.rlib} `spread` function to get the number of individuals counted in each month (as three columns) by species (as rows).

===
-->

## Solutions

===

### Solution 1



~~~r
> gather(wide_counts, key = "species", value = "n", -site)
~~~
{:.input title="Console"}


~~~
Error in gather(wide_counts, key = "species", value = "n", -site): object 'wide_counts' not found
~~~
{:.output}


[Return](#exercise-1)
{:.notes}

===

### Solution 2



~~~r
> cbp_construction <- filter(cbp, NAICS == '23----')
> select(cbp_construction, starts_with('FIPS'), starts_with('AP'))
~~~
{:.input title="Console"}


~~~
[1] FIPS
<0 rows> (or 0-length row.names)
~~~
{:.output}


[Return](#exercise-2)
{:.notes}

===

### Solution 3



~~~r
> state_cbp_health_care <- cbp_health_care %>%
+   group_by(FIPSTATE, FIPSCTY) %>%
+   summarize(EMP = sum(EMP)) %>%
+   summarize(EMP = sum(EMP), counties = n())
~~~
{:.input title="Console"}


~~~
Error in eval(lhs, parent, parent): object 'cbp_health_care' not found
~~~
{:.output}


[Return](#exercise-3)
{:.notes}

<!--
===

### Solution 4



~~~r
> group_by(animals, species_id, month) %>%
+   summarize(count = n()) %>%
+   spread(key = month, value = count, fill = 0)
~~~
{:.input title="Console"}


~~~
Error in group_by(animals, species_id, month): object 'animals' not found
~~~
{:.output}


[Return](#exercise-4)
{:.notes}
-->

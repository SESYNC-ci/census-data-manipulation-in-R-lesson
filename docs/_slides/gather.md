---
excerpt: Wide or Long
---

## Pivot_longer

The [tidyr](){:.rlib} package's `pivot_longer` function reshapes "wide" data frames
into "long" ones.



~~~r
library(tidyr)
tidy_trial <- pivot_longer(trial,
  cols = c(drug, control, placebo),
  names_to = 'treatment',
  values_to = 'response')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


All columns, accept for "block", are stacked in two columns: a "name" and a
"value". The name column gets the name `treatment` from the `names_to` argument,
and the `value` column receives the name `response` from the `values_to` argument. 
For each row in the result, the name is taken from the name
of the column and the value from the data in the column.
{:.notes}

===



~~~r
> tidy_trial
~~~
{:title="Console" .input}


~~~
# A tibble: 9 x 3
  block treatment response
  <int> <chr>        <dbl>
1     1 drug         0.22 
2     1 control      0.580
3     1 placebo      0.31 
4     2 drug         0.12 
5     2 control      0.98 
6     2 placebo      0.47 
7     3 drug         0.42 
8     3 control      0.19 
9     3 placebo      0.4  
~~~
{:.output}


Some notes on the syntax: a big advantage of [tidyr](){:.rlib} and
[dplyr](){:.rlib} is that each function takes a data frame as its first argument
and returns a new data frame. As we will see later, it makes it very easy to
chain these functions in a pipeline. All functions also use column names as
variables without subsetting them from a data frame (i.e. `block` instead of
`trial$block`).
{:.notes}

===

## Pivot_wider

Data can also fail to be tidy when a table is too long. The
Entity-Attribute-Value (EAV) structure common in large databases distributes
multible attributes of a single entity/observation into separate rows.

Remember that the exact state of "tidy" may depend on the analysis: the key is
knowing what counts as a complete observation. For example, the community
ecology package [vegan](){:.rlib} requires a matrix of species counts, where
rows correspond to species and columns to sites. This may seem like too "wide" a
format, but in the packages several multi-variate analyses, the abundance of a
species across multiple sites is considered a complete observation.
{:.notes}

===

Consider survey data on participant's age and income *stored* in a EAV
structure.



| participant|attr   | val|
|-----------:|:------|---:|
|           1|age    |  24|
|           2|age    |  57|
|           3|age    |  13|
|           1|income |  30|
|           2|income |  60|



===

Transform the data with the `pivot_wider` function, which "reverses" a `pivot_longer`.



~~~r
tidy_survey <- pivot_wider(survey,
  names_from = attr,
  values_from = val)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===



~~~r
> tidy_survey
~~~
{:title="Console" .input}


~~~
# A tibble: 3 x 3
  participant   age income
        <int> <int>  <int>
1           1    24     30
2           2    57     60
3           3    13     NA
~~~
{:.output}



===

One difficulty with EAV tables is the nature of missing data; an entire row
rather than a single cell is missing. Think about what "missing data" could mean
here---perhaps you can supply a value instead of the `NA` in the previous
result.



~~~r
tidy_survey <- pivot_wider(survey,
  names_from = attr,
  values_from = val,
  values_fill = list(val = 0))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===



~~~r
> tidy_survey
~~~
{:title="Console" .input}


~~~
# A tibble: 3 x 3
  participant   age income
        <int> <int>  <int>
1           1    24     30
2           2    57     60
3           3    13      0
~~~
{:.output}


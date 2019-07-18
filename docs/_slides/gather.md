---
excerpt: Wide or Long
---

## Gather

The [tidyr](){:.rlib} package's `gather` function reshapes "wide" data frames
into "long" ones.



~~~r
library(tidyr)
tidy_trial <- gather(trial,
  key = "treatment",
  value = "response",
  -block)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


All columns, accept for "block", are stacked in two columns: a "key" and a
"value". The key column gets the name `treatment` and the value column reveives
the name `response`. For each row in the result, the key is taken from the name
of the column and the value from the data in the column.
{:.notes}

===



~~~r
> tidy_trial
~~~
{:title="Console" .input}


~~~
  block treatment response
1     1      drug     0.22
2     2      drug     0.12
3     3      drug     0.42
4     1   control     0.58
5     2   control     0.98
6     3   control     0.19
7     1   placebo     0.31
8     2   placebo     0.47
9     3   placebo     0.40
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

## Spread

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

Transform the data with the `spread` function, which "reverses" a `gather`.



~~~r
tidy_survey <- spread(survey,
  key = attr,
  value = val)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===



~~~r
> tidy_survey
~~~
{:title="Console" .input}


~~~
  participant     age  income
1           1      24      30
2           2      57      60
3           3      13      NA
~~~
{:.output}



===

One difficulty with EAV tables is the nature of missing data; an entire row
rather than a single cell is missing. Think about what "missing data" could mean
here---perhaps you can supply a value instead of the `NA` in the previous
result.



~~~r
tidy_survey <- spread(survey,
  key = attr,
  value = val,
  fill = 0)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===



~~~r
> tidy_survey
~~~
{:title="Console" .input}


~~~
  participant     age  income
1           1      24      30
2           2      57      60
3           3      13       0
~~~
{:.output}


---
# mutate to concatenate fips
---
  
## Mutate

The `mutate` function is the [dplyr](){:.rlib} answer to cleaning up your
columns. It performs arbitrary row-wise operations on existing columns and
appends the result as a new column.

===

Here's one you've probably needed before:


~~~r
cbp_health_care %<>% mutate(
  FIPS = str_c(FIPSTATE, FIPSCTY))
~~~
{:.input}

===

Question
: Oh c'mon! `%<>%`?!

Answer
: {:.fragment} I know, but stay calm and `` ?`%<>%` ``.


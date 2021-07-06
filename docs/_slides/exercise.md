---
---

## Exercises

===

### Exercise 1

Now that we have a tidy form of `survey`, convert it to a `long_survey` data
frame using `pivot_longer`. The only difference between `survey` and `long_survey`
should be an additional row for zero income.

[View solution](#solution-1)
{:.notes}

===

### Exercise 2

Use `filter` and `select` to return just the annual payroll data for the top
level construction sector ("23----"), using data from CBP. Annual payroll information are in columns AP and AP_NF.

[View solution](#solution-2)
{:.notes}

===

### Exercise 3

Write code to create a data frame giving, for each state, the number of counties
in the CBP survey with establishements in mining or oil and gas extraction
('21----') along with their total employment ("EMP"). 


[View solution](#solution-3)
{:.notes}

===

### Exercise 4

A "pivot table" is a transformation of tidy data into a wide summary table.
First, data are summarized by *two* grouping factors, then one of these is
"pivoted" into columns. Using only data with a 2-digit NAICS code, chain a
split-apply-combine procedure into a "wide" table to
get the total number of employees ("EMP") in each state (as rows) by 
NAICS code (as columns).

===

## Solutions

===

### Solution 1



~~~r
long_survey <- pivot_longer(tidy_survey,  
                            cols=c(age, income), 
                            values_to = 'val', 
                            names_to = 'attr', 
                          )
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}

  
[Return](#exercise-1)
{:.notes}

===

### Solution 2



~~~r
cbp_23 <- fread('data/cbp15co.csv', na.strings = '') %>%
  filter(NAICS == '23----') %>%
  select(starts_with('FIPS'), starts_with('AP'))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


[Return](#exercise-2)
{:.notes}

===

### Solution 3



~~~r
cbp_21 <- fread('data/cbp15co.csv', na.strings = '') %>%
  filter(NAICS == '21----') %>%
  group_by(FIPSTATE) %>%
  summarize(EMP = sum(EMP), counties = n())
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
`summarise()` ungrouping output (override with `.groups` argument)
~~~
{:.output}


[Return](#exercise-3)
{:.notes}

===

### Solution 4



~~~r
pivot <- fread('data/cbp15co.csv', na.strings = '') %>%
  filter(str_detect(NAICS, '[0-9]{2}----')) %>%
  group_by(FIPSTATE, NAICS) %>%
  summarize(EMP = sum(EMP)) %>%
  pivot_wider(names_from = NAICS, values_from = EMP)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
`summarise()` regrouping output by 'FIPSTATE' (override with `.groups` argument)
~~~
{:.output}


[Return](#exercise-4)
{:.notes}

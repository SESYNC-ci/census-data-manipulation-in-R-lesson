---
---

## Tidy Concept

R developer Hadley Wickham (author of the [tidyr](){:.rlib}, [dplyr](){:.rlib}
and [ggplot2](){:.rlib} packages, among others) defines tidy datasets ([Wickham
2014](http://www.jstatsoft.org/v59/i10/paper)) as those where:

- each variable forms a column
- each observation forms a row
- each type of observational unit forms a table

These guidelines may be familiar to some of you---they closely map to best
practices for "normalization" in database design.
{:.notes}

===

Consider a data set where the outcome of an experiment has been *recorded* in a perfectly appropriate way:



| block| drug| control| placebo|
|-----:|----:|-------:|-------:|
|     1| 0.22|    0.58|    0.31|
|     2| 0.12|    0.98|    0.47|
|     3| 0.42|    0.19|    0.40|



===

The response data are present in a compact matrix, as you might record it on a
spreadsheet. The form does not match how we think about a statistical model,
such as:

$$
response \sim block + treatment
$$

In a tidy format, each row is a complete observation: it includes the response
value and all the predictor values. In this data, some of those predictor values
are column headers, so the table needs to be reshaped. The [tidyr](){:.rlib}
package provides functions to help re-organize tables.
{:.notes}

===

The third principle of tidy data, one table per category of observed entities,
becomes especially important in synthesis research. Following this principle
requires holding tidy data in multiple tables, with associations between them
formalized in metadata, as in a relational database.
{:.notes}

Datasets split across multiple tables are unavoidable in synthesis
research, and commonly used in the following two ways (often in combination):

- two tables are "un-tidied" by joins, or merging them into one table
- statistical models conform to the data model through a hierarchical structure
or employing "random effects"

===

The [dplyr](){:.rlib} package includes several functions that all perform
variations on table joins needed to "un-tidy" your tables, but there are only
two basic types of table relationships to recognize:

- **One-to-one** relationships allow tables to be combined based on the same
unique identifier (or "primary key") in both tables.
- **Many-to-one** relationships require non-unique "foreign keys" in the first
table to match the primary key of the second.


---
---

## Lesson Objectives

- Review what makes a dataset **tidy**
- Learn to transform datasets with split-apply-combine procedures
- Pay attention to code clarity

===

## Specific Achievements

- Reshape data frames with [tidyr](){:.rlib}
- Summarize data by groups with [dplyr](){:.rlib}
- Combine multiple data frame operations with pipes
- Combine multiple data frames with "joins"

Data frames occupy a central place in R analysis pipelines. While the base R
functions provide most necessary tools to subset, reformat and transform data
frames, the specialized packages in this lesson offer friendlier and often
computationally faster ways to perform common data frame processing steps. The
uniform syntax of the [tidyr](){:.rlib} and [dplyr](){:.rlib} packages also
makes scripts more readable and easier to debug. The key functions in both
packages have close counterparts in SQL (Structured Query Language), which
provides the added bonus of facilitating translation between R and relational
databases.
{:.notes}

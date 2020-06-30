---
excerpt: Join and Summarize
---

## Join

The CBP dataset uses FIPS to identify U.S. counties and NAICS codes to identify
types of industry. The ACS dataset also uses FIPS for counties but uses industry sectors instead of NAICS codes. The sectors are broader than the NAICS codes; with multiple NAICS codes representing a single industry sector. {:.notes}

To combine the ACS and CBP datasets, we need to relate the NAICS codes to the industry sector. 

===

A data frame `sector` relates the NAICS codes to the industry sector as used in the CBP dataset. 



~~~r
sector <- fread(
  'data/ACS/sector_naics.csv',
  colClasses = c(NAICS='character'))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



~~~r
> View(sector)
~~~
{:title="Console" .no-eval .input}


Probably the primary challenge in combining secondary datasets for synthesis
research is dealing with their different sampling frames. A very common issue is
that data are collected at different "scales", with one dataset being at higher
spatial or temporal resolution than another. The differences between the CBP and
ACS categories of industry present a similar problem, and require the same
solution of re-aggregating data at the "lower resolution".
{:.notes}

===

### Many-to-One
A [dplyr](){:.rlib} `join` function can be used to "join" the `cbp` and `sector` data frames.  

Join commands combine two data frames based on columns in the data frame specified by the `by = ` argument. If no columns are given, the default is to combine using all columns with the same names. In our example, `cbp` and `sector` will join based on the `NAICS` column in each of the data frames.
{:.notes}

There are multiple types of join commands which differ in how they handle data that is missing in one of the data frames. To combine `cbp` and `sector` we will use `inner_join` which will only include rows that have the same NAICS code in **both** `cbp` and `sector.` Information on the other types of join commands can be found in the dplyr [join documentation] (https://dplyr.tidyverse.org/reference/join.html).
{:.notes}



~~~r
cbp <- cbp %>%
  inner_join(sector)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Joining, by = "NAICS"
~~~
{:.output}




~~~r
> View(cbp)
~~~
{:title="Console" .no-eval .input}


===

![]({% include asset.html path="images/many-to-one.svg" %}){:width="80%"}
{:.notes}

The NAICS field in the `cbp` table can have the same value multiple times, it is
not a primary key in this table. In the `sector` table, the NAICS field is the
primary key uniquely identifying each record. The type of relationship between
these tables is therefore "many-to-one".
{:.notes}

Question
: Note that we lost a couple thousand rows through this join. How could
`cbp` have fewer rows after a join on NAICS codes?

Answer
: {:.fragment} The CBP data contains an NAICS code not mapped to a sector---the
"error code" 99 is not present in `sector`. The use of "error codes" that
could easilly be mistaken for data is frowned upon.

===

## Group By

A very common data manipulation procedure know as "split-apply-combine" tackles
the problem of applying the same transformation to subsets of data while keeping
the result all together. 

Because there were multiple NAICS codes associated with a `Sector`, there are now multiple rows for a single sector within a county. We need the total number of establishments
in each size class *aggregated within* each county and industry sector.
{:.notes}

===

The dplyr function `group_by` begins the process by indicating how the data
frame should be split into subsets.



~~~r
cbp_grouped <- cbp %>%
  group_by(FIPS, Sector)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

At this point, nothing has really changed:



~~~r
> str(cbp_grouped)
~~~
{:title="Console" .input}


~~~
tibble [56,704 × 16] (S3: grouped_df/tbl_df/tbl/data.frame)
 $ FIPS    : chr [1:56704] "01001" "01001" "01001" "01001" ...
 $ NAICS   : chr [1:56704] "11" "21" "22" "23" ...
 $ N1_4    : int [1:56704] 5 0 2 51 9 18 68 9 5 41 ...
 $ N5_9    : int [1:56704] 1 1 1 13 4 6 41 4 1 18 ...
 $ N10_19  : int [1:56704] 0 1 2 7 4 2 34 1 1 6 ...
 $ N20_49  : int [1:56704] 0 0 3 4 3 3 11 2 2 2 ...
 $ N50_99  : int [1:56704] 1 1 1 0 3 0 11 0 0 0 ...
 $ N100_249: int [1:56704] 0 0 0 0 0 0 3 0 0 0 ...
 $ N250_499: int [1:56704] 0 0 0 0 0 0 1 0 0 0 ...
 $ N500_999: int [1:56704] 0 0 0 0 1 0 0 0 0 0 ...
 $ N1000   : int [1:56704] 0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_1 : int [1:56704] 0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_2 : int [1:56704] 0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_3 : int [1:56704] 0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_4 : int [1:56704] 0 0 0 0 0 0 0 0 0 0 ...
 $ Sector  : chr [1:56704] "agriculture forestry fishing and hunting" "mining quarrying and oil and gas extraction" "utilities" "construction" ...
 - attr(*, ".internal.selfref")=<externalptr> 
 - attr(*, "groups")= tibble [56,704 × 3] (S3: tbl_df/tbl/data.frame)
  ..$ FIPS  : chr [1:56704] "01001" "01001" "01001" "01001" ...
  ..$ Sector: chr [1:56704] "accommodation and food services" "administrative and support and waste management and remediation services" "agriculture forestry fishing and hunting" "arts entertainment and recreation" ...
  ..$ .rows : list<int> [1:56704] 
  .. ..$ : int 18
  .. ..$ : int 14
  .. ..$ : int 1
  .. ..$ : int 17
  .. ..$ : int 4
  .. ..$ : int 15
  .. ..$ : int 10
  .. ..$ : int 16
  .. ..$ : int 9
  .. ..$ : int 13
  .. ..$ : int 5
  .. ..$ : int 2
  .. ..$ : int 19
  .. ..$ : int 12
  .. ..$ : int 11
  .. ..$ : int 7
  .. ..$ : int 8
  .. ..$ : int 3
  .. ..$ : int 6
  .. ..$ : int 37
  .. ..$ : int 33
  .. ..$ : int 20
  .. ..$ : int 36
  .. ..$ : int 23
  .. ..$ : int 34
  .. ..$ : int 29
  .. ..$ : int 35
  .. ..$ : int 28
  .. ..$ : int 32
  .. ..$ : int 24
  .. ..$ : int 21
  .. ..$ : int 38
  .. ..$ : int 31
  .. ..$ : int 30
  .. ..$ : int 26
  .. ..$ : int 27
  .. ..$ : int 22
  .. ..$ : int 25
  .. ..$ : int 55
  .. ..$ : int 51
  .. ..$ : int 39
  .. ..$ : int 54
  .. ..$ : int 42
  .. ..$ : int 52
  .. ..$ : int 48
  .. ..$ : int 53
  .. ..$ : int 47
  .. ..$ : int 43
  .. ..$ : int 40
  .. ..$ : int 56
  .. ..$ : int 50
  .. ..$ : int 49
  .. ..$ : int 45
  .. ..$ : int 46
  .. ..$ : int 41
  .. ..$ : int 44
  .. ..$ : int 74
  .. ..$ : int 70
  .. ..$ : int 57
  .. ..$ : int 73
  .. ..$ : int 60
  .. ..$ : int 71
  .. ..$ : int 66
  .. ..$ : int 72
  .. ..$ : int 65
  .. ..$ : int 69
  .. ..$ : int 61
  .. ..$ : int 58
  .. ..$ : int 75
  .. ..$ : int 68
  .. ..$ : int 67
  .. ..$ : int 63
  .. ..$ : int 64
  .. ..$ : int 59
  .. ..$ : int 62
  .. ..$ : int 93
  .. ..$ : int 89
  .. ..$ : int 76
  .. ..$ : int 92
  .. ..$ : int 79
  .. ..$ : int 90
  .. ..$ : int 85
  .. ..$ : int 91
  .. ..$ : int 84
  .. ..$ : int 88
  .. ..$ : int 80
  .. ..$ : int 77
  .. ..$ : int 94
  .. ..$ : int 87
  .. ..$ : int 86
  .. ..$ : int 82
  .. ..$ : int 83
  .. ..$ : int 78
  .. ..$ : int 81
  .. ..$ : int 111
  .. ..$ : int 107
  .. ..$ : int 95
  .. ..$ : int 110
  .. ..$ : int 97
  .. .. [list output truncated]
  .. ..@ ptype: int(0) 
  ..- attr(*, ".drop")= logi TRUE
~~~
{:.output}


The `group_by` statement does not change any values in the data frame; it only
adds attributes to the the original data frame. You can add multiple variables
(separated by commas) in `group_by`; each distinct combination of values across
these columns defines a different group.
{:.notes}

===

## Summarize

Differents operations can be used on each group. We need to sum the number of
establishments in each group. 

Using [dplyr](){:.rlib} functions, we group the data by couny and sector (`group_by`), select the columns for number of establishments (`select`) and sum the number of establishments within each group (`summarize_all`).
{:.notes}

===



~~~r
cbp <- cbp %>%
  group_by(FIPS, Sector) %>%
  select(starts_with('N'), -NAICS) %>%
  summarize_all(sum)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Adding missing grouping variables: `FIPS`, `Sector`
~~~
{:.output}


The "combine" part of "split-apply-combine" occurs automatically, when the
attributes introduced by `group_by` are dropped. You can see attributes either
by running the `str()` function on the data frame or by inspecting it in the
RStudio *Environment* pane.
{:.notes}

===

![]({% include asset.html path="images/one-to-one.svg" %}){:width="80%"}

There is now a one-to-one relationship between `cbp` and `acs`, based on
the combination of FIPS and Sector as the primary key for both tables.
{:.notes}

===

To finish creating the dataset for the analysis of interest, we now join the `acs` data frame. The two data frames are joined by `FIPS` and `Sector.`



~~~r
acs_cbp <- cbp %>%
  inner_join(acs)
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


~~~
Joining, by = c("FIPS", "Sector")
~~~
{:.output}


Again, however, the one-to-one relationship does not mean all rows are preserved
by the join. The specific nature of the `inner_join` is to keep all rows, even
duplicating rows if the relationship is many-to-one, where there are matching
values in both tables, and discarding the rest.
{:.notes}

===

The `acs_cbp` table now includes the `median_income` variable from the ACS and
appropriatey aggregated establishment size information (the number of
establishments by employee bins) from the CBP table.



~~~r
> View(acs_cbp)
~~~
{:title="Console" .no-eval .input}


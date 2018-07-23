---
excerpt: Join and Summarize
---

## Join

The CBP dataset uses FIPS to identify U.S. counties and NAICS codes to identify
types of industry. The ACS dataset also uses FIPS but their data may aggregate
across multiple NAICS codes representing a single industry sector.

===



~~~r
sector <- fread(
  'data/ACS/sector_naics.csv',
  colClasses = c(NAICS='character'))
~~~
{:.text-document title="{{ site.handouts[0] }}"}



~~~r
> View(sector)
~~~
{:.input title="Console"}


Probably the primary challenge in combining secondary datasets for synthesis
research is dealing with their different sampling frames. A very common issue is
that data are collected at different "scales", with one dataset being at higher
spatial or temporal resolution than another. The differences between the CBP and
ACS categories of industry present a similar problem, and require the same
solution of re-aggregating data at the "lower resolution".
{:.notes}

===

### Many-to-One



~~~r
cbp <- cbp %>%
  inner_join(sector)
~~~
{:.text-document title="{{ site.handouts[0] }}"}


~~~
Joining, by = "NAICS"
~~~
{:.output}




~~~r
> View(cbp)
~~~
{:.input title="Console"}


===

![]({{ site.baseurl }}/images/many-to-one.svg){:width="80%"}

The NAICS field in the `cbp` table can have the same value multiple times, it is
not a primary key in this table. In the `sector` table, the NAICS field is the
primary key uniquely identifying each record. The type of relationship between
these tables is therefore "many-to-one".
{:.notes}

===

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
the result all together. We need the total number of establishments
in each size class *aggregated within* each county and industry sector.

===

The dplyr function `group_by` begins the process by indicating how the data
frame should be split into subsets.



~~~r
cbp_grouped <- cbp %>%
  group_by(FIPS, Sector)
~~~
{:.text-document title="{{ site.handouts[0] }}"}


===

At this point, nothing has really changed:



~~~r
> str(cbp_grouped)
~~~
{:.input title="Console"}


~~~
Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	56704 obs. of  16 variables:
 $ FIPS    : chr  "01001" "01001" "01001" "01001" ...
 $ NAICS   : chr  "11" "21" "22" "23" ...
 $ N1_4    : int  5 0 2 51 9 18 68 9 5 41 ...
 $ N5_9    : int  1 1 1 13 4 6 41 4 1 18 ...
 $ N10_19  : int  0 1 2 7 4 2 34 1 1 6 ...
 $ N20_49  : int  0 0 3 4 3 3 11 2 2 2 ...
 $ N50_99  : int  1 1 1 0 3 0 11 0 0 0 ...
 $ N100_249: int  0 0 0 0 0 0 3 0 0 0 ...
 $ N250_499: int  0 0 0 0 0 0 1 0 0 0 ...
 $ N500_999: int  0 0 0 0 1 0 0 0 0 0 ...
 $ N1000   : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_1 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_2 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_3 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_4 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ Sector  : chr  "agriculture forestry fishing and hunting" "mining quarrying and oil and gas extraction" "utilities" "construction" ...
 - attr(*, "vars")= chr  "FIPS" "Sector"
 - attr(*, "drop")= logi TRUE
 - attr(*, "indices")=List of 56704
  ..$ : int 17
  ..$ : int 13
  ..$ : int 0
  ..$ : int 16
  ..$ : int 3
  ..$ : int 14
  ..$ : int 9
  ..$ : int 15
  ..$ : int 8
  ..$ : int 12
  ..$ : int 4
  ..$ : int 1
  ..$ : int 18
  ..$ : int 11
  ..$ : int 10
  ..$ : int 6
  ..$ : int 7
  ..$ : int 2
  ..$ : int 5
  ..$ : int 36
  ..$ : int 32
  ..$ : int 19
  ..$ : int 35
  ..$ : int 22
  ..$ : int 33
  ..$ : int 28
  ..$ : int 34
  ..$ : int 27
  ..$ : int 31
  ..$ : int 23
  ..$ : int 20
  ..$ : int 37
  ..$ : int 30
  ..$ : int 29
  ..$ : int 25
  ..$ : int 26
  ..$ : int 21
  ..$ : int 24
  ..$ : int 54
  ..$ : int 50
  ..$ : int 38
  ..$ : int 53
  ..$ : int 41
  ..$ : int 51
  ..$ : int 47
  ..$ : int 52
  ..$ : int 46
  ..$ : int 42
  ..$ : int 39
  ..$ : int 55
  ..$ : int 49
  ..$ : int 48
  ..$ : int 44
  ..$ : int 45
  ..$ : int 40
  ..$ : int 43
  ..$ : int 73
  ..$ : int 69
  ..$ : int 56
  ..$ : int 72
  ..$ : int 59
  ..$ : int 70
  ..$ : int 65
  ..$ : int 71
  ..$ : int 64
  ..$ : int 68
  ..$ : int 60
  ..$ : int 57
  ..$ : int 74
  ..$ : int 67
  ..$ : int 66
  ..$ : int 62
  ..$ : int 63
  ..$ : int 58
  ..$ : int 61
  ..$ : int 92
  ..$ : int 88
  ..$ : int 75
  ..$ : int 91
  ..$ : int 78
  ..$ : int 89
  ..$ : int 84
  ..$ : int 90
  ..$ : int 83
  ..$ : int 87
  ..$ : int 79
  ..$ : int 76
  ..$ : int 93
  ..$ : int 86
  ..$ : int 85
  ..$ : int 81
  ..$ : int 82
  ..$ : int 77
  ..$ : int 80
  ..$ : int 110
  ..$ : int 106
  ..$ : int 94
  ..$ : int 109
  ..$ : int 96
  .. [list output truncated]
 - attr(*, "group_sizes")= int  1 1 1 1 1 1 1 1 1 1 ...
 - attr(*, "biggest_group_size")= int 1
 - attr(*, "labels")='data.frame':	56704 obs. of  2 variables:
  ..$ FIPS  : chr  "01001" "01001" "01001" "01001" ...
  ..$ Sector: chr  "accommodation and food services" "administrative and support and waste management and remediation services" "agriculture forestry fishing and hunting" "arts entertainment and recreation" ...
  ..- attr(*, "vars")= chr  "FIPS" "Sector"
  ..- attr(*, "drop")= logi TRUE
~~~
{:.output}


The `group_by` statement does not change any values in the data frame; it only
adds attributes to the the original data frame. You can add multiple variables
(separated by commas) in `group_by`; each distinct combination of values across
these columns defines a different group.
{:.notes}

===

## Summarize

The operation to perform on each group is summing: we need to sum the number of
establishments in each group. Using [dplyr](){:.rlib} functions, the summaries
are automically combined into a data frame.

===



~~~r
cbp <- cbp %>%
  group_by(FIPS, Sector) %>%
  select(starts_with('N'), -NAICS) %>%
  summarize_all(sum)
~~~
{:.text-document title="{{ site.handouts[0] }}"}


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

![]({{ site.baseurl }}/images/one-to-one.svg){:width="80%"}

There is now a one-to-one relationship between `cbp` and `acs`, based on
the combination of FIPS and Sector as the primary key for both tables.
{:.notes}

===



~~~r
acs_cbp <- cbp %>%
  inner_join(acs)
~~~
{:.text-document title="{{ site.handouts[0] }}"}


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
{:.input title="Console"}


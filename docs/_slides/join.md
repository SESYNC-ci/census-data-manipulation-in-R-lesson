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
"error code" 99 is not present in `many_to_one`. The use of "error codes" that
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
 $ FIPS    : chr  "11" "11" "11" "11" ...
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
 - attr(*, "indices")=List of 55056
  ..$ : int 5811
  ..$ : int 5807
  ..$ : int 5794
  ..$ : int 5810
  ..$ : int 5797
  ..$ : int 5808
  ..$ : int 5803
  ..$ : int 5809
  ..$ : int 5802
  ..$ : int 5806
  ..$ : int 5798
  ..$ : int 5795
  ..$ : int 5812
  ..$ : int 5805
  ..$ : int 5804
  ..$ : int 5800
  ..$ : int 5801
  ..$ : int 5796
  ..$ : int 5799
  ..$ : int 5830
  ..$ : int 5826
  ..$ : int 5813
  ..$ : int 5829
  ..$ : int 5816
  ..$ : int 5827
  ..$ : int 5822
  ..$ : int 5828
  ..$ : int 5821
  ..$ : int 5825
  ..$ : int 5817
  ..$ : int 5814
  ..$ : int 5831
  ..$ : int 5824
  ..$ : int 5823
  ..$ : int 5819
  ..$ : int 5820
  ..$ : int 5815
  ..$ : int 5818
  ..$ : int 5849
  ..$ : int 5845
  ..$ : int 5832
  ..$ : int 5848
  ..$ : int 5835
  ..$ : int 5846
  ..$ : int 5841
  ..$ : int 5847
  ..$ : int 5840
  ..$ : int 5844
  ..$ : int 5836
  ..$ : int 5833
  ..$ : int 5850
  ..$ : int 5843
  ..$ : int 5842
  ..$ : int 5838
  ..$ : int 5839
  ..$ : int 5834
  ..$ : int 5837
  ..$ : int 5862
  ..$ : int 5859
  ..$ : int 5851
  ..$ : int 5860
  ..$ : int 5856
  ..$ : int 5861
  ..$ : int 5855
  ..$ : int 5858
  ..$ : int 5863
  ..$ : int 5857
  ..$ : int 5853
  ..$ : int 5854
  ..$ : int 5852
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
  ..$ : int 936
  ..$ : int 932
  ..$ : int 919
  ..$ : int 935
  ..$ : int 922
  ..$ : int 933
  ..$ : int 928
  ..$ : int 934
  ..$ : int 927
  ..$ : int 931
  .. [list output truncated]
 - attr(*, "group_sizes")= int  1 1 1 1 1 1 1 1 1 1 ...
 - attr(*, "biggest_group_size")= int 2
 - attr(*, "labels")='data.frame':	55056 obs. of  2 variables:
  ..$ FIPS  : chr  "101" "101" "101" "101" ...
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


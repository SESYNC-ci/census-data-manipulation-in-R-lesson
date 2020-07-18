---
# empflag for NA strings
#
---

## Sample Data

![]({% include asset.html path="images/data.jpg" %}){: width="50%"}  
*Credit: [US Census Bureau](https://www.census.gov/programs-surveys/cbp.html)*
{:.captioned}

===

To learn about data transformation with dplyr, we need more data. The Census
Bureau collects subnational economic data for the U.S., releasing annual [County
Business Patterns (CBP)] datasets including the number of establishments,
employment, and payroll by industry. They also conduct the [American Community
Survey (ACS)] and publish, among other demographic and economic variables, such as estimates of
median income for individuals working in different industries.
{:.notes}

- [County Business Patterns (CBP)]
- [American Community Survey (ACS)]

[County Business Patterns (CBP)]: https://www.census.gov/programs-surveys/cbp/data/datasets.html
[American Community Survey (ACS)]: https://www.census.gov/programs-surveys/acs/

===

These two datasets both contain economic variables for each U.S. county 
specified by different categories of industry. The data could potentially be
manipulated into a single table reflecting the following statistical model.

$$
median\_income \sim industry + establishment\_size
$$

===

First, load the CBP data. `fread` from [data.table](){:.rlib} is faster at reading large data sets than base R `read.csv`.



~~~r
library(data.table)
cbp <- fread('data/cbp15co.csv')
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}




~~~r
> str(cbp)
~~~
{:title="Console" .input}


~~~
Classes 'data.table' and 'data.frame':	2126601 obs. of  26 variables:
 $ FIPSTATE: int  1 1 1 1 1 1 1 1 1 1 ...
 $ FIPSCTY : int  1 1 1 1 1 1 1 1 1 1 ...
 $ NAICS   : chr  "------" "11----" "113///" "1133//" ...
 $ EMPFLAG : chr  "" "" "" "" ...
 $ EMP_NF  : chr  "G" "H" "H" "H" ...
 $ EMP     : int  10454 70 70 70 70 70 0 0 0 0 ...
 $ QP1_NF  : chr  "G" "H" "H" "H" ...
 $ QP1     : int  76437 790 790 790 790 790 0 0 0 0 ...
 $ AP_NF   : chr  "G" "H" "H" "H" ...
 $ AP      : int  321433 3566 3551 3551 3551 3551 0 0 0 0 ...
 $ EST     : int  844 7 6 6 6 6 1 1 1 1 ...
 $ N1_4    : int  430 5 4 4 4 4 1 1 1 1 ...
 $ N5_9    : int  171 1 1 1 1 1 0 0 0 0 ...
 $ N10_19  : int  118 0 0 0 0 0 0 0 0 0 ...
 $ N20_49  : int  81 0 0 0 0 0 0 0 0 0 ...
 $ N50_99  : int  35 1 1 1 1 1 0 0 0 0 ...
 $ N100_249: int  6 0 0 0 0 0 0 0 0 0 ...
 $ N250_499: int  2 0 0 0 0 0 0 0 0 0 ...
 $ N500_999: int  1 0 0 0 0 0 0 0 0 0 ...
 $ N1000   : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_1 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_2 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_3 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ N1000_4 : int  0 0 0 0 0 0 0 0 0 0 ...
 $ CENSTATE: int  63 63 63 63 63 63 63 63 63 63 ...
 $ CENCTY  : int  1 1 1 1 1 1 1 1 1 1 ...
 - attr(*, ".internal.selfref")=<externalptr> 
~~~
{:.output}


The CBP dataset includes NAICS (North American Industry Classification System) industry codes and the number of businesses or establishments of different employee sizes in each US county. States and counties are identified by Federal Information Processing System (FIPS) codes. See the [CBP dataset documentation] for an explanation of the variables we don't
discuss in this lesson.
{:.notes}

[CBP dataset documentation]: https://www2.census.gov/programs-surveys/rhfs/cbp/technical%20documentation/2015_record_layouts/county_layout_2015.txt

===

We need to modify the import to clean up this read. The data type for the state and city codes should be read in as a character type using `colClasses`. 



~~~r
cbp <- fread(
  'data/cbp15co.csv',
  colClasses = c(
    FIPSTATE='character',
    FIPSCTY='character'))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}


===

Next, load the ACS data. The ACS data we are using in this example includes the median income by industry sector for each US county.



~~~r
acs <- fread(
  'data/ACS/sector_ACS_15_5YR_S2413.csv',
  colClasses = c(FIPS='character'))
~~~
{:title="{{ site.data.lesson.handouts[0] }}" .text-document}



~~~r
> str(acs)
~~~
{:title="Console" .input}


~~~
Classes 'data.table' and 'data.frame':	59698 obs. of  4 variables:
 $ FIPS         : chr  "01001" "01003" "01005" "01007" ...
 $ County       : chr  "Autauga County, Alabama" "Baldwin County, Alabama" "Barbour County, Alabama" "Bibb County, Alabama" ...
 $ Sector       : chr  "agriculture forestry fishing and hunting" "agriculture forestry fishing and hunting" "agriculture forestry fishing and hunting" "agriculture forestry fishing and hunting" ...
 $ median_income: int  27235 40017 32260 22240 21260 30469 33300 39784 40417 20370 ...
 - attr(*, ".internal.selfref")=<externalptr> 
~~~
{:.output}




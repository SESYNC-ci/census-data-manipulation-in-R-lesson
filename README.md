[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://github.com/SESYNC-ci/sesync-ci.github.io/blob/master/lesson/lesson-lifecycle.md#stable)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5708314.svg)](https://doi.org/10.5281/zenodo.5708314)

## Manipulating Tabular Data in R

Clean and prepare tidy data with tidyr and dplyr. 

## Instructor Notes

* This lesson uses `fread` from the `data.table` package to read in 
spreadsheet files, rather than the tidyverse `read_csv` from `readr`. 
While there is little difference with the 60,000 row ACS table, there
is a notable improvement with the >2M row CBP table (0.5 vs 7 seconds). 
* Lesson should be updated to include [pivot_*](https://tidyr.tidyverse.org/dev/articles/pivot.html)
functions to replace `gather` and `spread`. 
* In `str_detect`, the regex `[0-9]` matches any number, `{2}` means
exactly 2 matches, and the `----` matches exactly. 
* In `str_remove`, the regex `-+` matches "1 or more `-`"
* For troubleshooting `select`, try specifying `dplyr::select` in 
case there are conflicting packages loaded. 

## Cyberhelp @SESYNC

The National Socio-Environmental Synthesis Center (SESYNC) curates and runs
tutorials on using cyberinfrastructure in pursuit of the Center's scientific
mission. Visit [www.sesync.org](https://www.sesync.org) to learn more about
SESYNC and [cyberhelp.sesync.org](https://cyberhelp.sesync.org) for more
tutorials and ideas.

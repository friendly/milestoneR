
<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Last
Commit](https://img.shields.io/github/last-commit/friendly/heplots)](https://github.com/friendly/heplots/)
<!-- badges: end -->

# milestoneR <img src="man/figures/logo.png" height="200" style="float:right; height:200px;"/>


The goal of the `milestoneR` package is to provide R access to the database tables used in the Milestones Project,
  reflecting the history of data visualization, as used in http://datavis.ca/milestones and other applications
  on this site, such as the [Milestones Calendar](http://www.datavis.ca/milestones-cal/).
  This project is described in Friendly et al. (2015).
  
  Another goal is to document what we have done to create a database comprised of important events in this
  history, combined with source images, external links, references, etc. to make this useful for further
  research.

## Installation

This package is not yet for public use. If you have access to this private repo, you can install it
with:

``` r
remotes::install_github("friendly/milestoneR")
```

<!--
You can install the released version of milestoneR from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("milestoneR")
```
-->

## Database schema

The milestones database was designed as a relational database (implemented in MySQL).
It consists of the tables shown in the figure below.

The main table
(`milestone`) contains information regarding each of the items considered a milestone in the history
of data visualization. These are linked
to other tables (e.g., `author`, `reference`, `mediaitem`) by unique (primary) keys: `mid` is the
key for a given milestones item. 

Each milestones item is coarsely classified in two tables: 

* `subject` indicates the substantive context of the milestones event, with categories "Physical",
"Mathematical", "Human", "Other".

* `aspect` indicates the role this event played in the history of data visualization, with categories
"Cartography", "Statistics & Graphics", "Technology", "Other".

In addition, there is a freeform `keyword` table listing keywords or terms attached to milestones items.

Other supporting tables (e.g., `milestones2subject`, `milestone2aspect`) provide for convenient lookups of descriptors of these
milestones items (subject, aspect, keyword) using the milestones id (`mid`) as the key.

![Milestones database schema](man/figures/database-schema.png)

## Example

This is a stub for a basic example which shows you how to solve a common problem:

``` r
library(milestoneR)
## basic example code
```

## References

Friendly, M., Sigal, M. & Harnanansingh, D. (2015).
"The Milestones Project: A Database for the History of Data Visualization."
In Kimball, M. & Kostelnick, C. (Eds.) 
_Visible Numbers: The History of Data Visualization_, Chapter 10.
London, UK: Ashgate Press.
[preprint](http://datavis.ca/papers/MilestonesProject.pdf)

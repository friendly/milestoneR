# milestoneR

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of the `milestoneR` package is to provide R access to the database tables used in the Milestones Project,
  reflecting the history of data visualization, as used in http://datavis.ca/milestones.
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

Other supporting tables (e.g., `milestone2aspect`) provide for convenient lookups of descriptors of these
milestones items (subject, aspect, keyword).

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

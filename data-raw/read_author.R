library(here)
library(readr)
library(dplyr)
library(data.table)

source(here("R", "html2latin1.R"))

aut <- read_csv("data-raw/author.csv")

aut <- aut |>
  slice(-1) |>
  mutate(givennames = html2latin1(givennames),
         lnames = html2latin1(lname),
         birthplace = html2latin1(birthplace),
         deathplace = html2latin1(deathplace))



# html2latin1(givennames),
# html2latin1(lname),
# html2latin1(birthplace),
# html2latin1(deathplace),
# html2latin1(Full_Name),
# html2latin1(Birth_Country),
# html2latin1(Death_Country)


library(here)
library(readr)
library(dplyr)
library(lubridate)
library(timeless)
#library(data.table)

source(here("R", "html2latin1.R"))

aut <- read_csv("data-raw/author.csv")

aut <- aut |>
  mutate(givennames = html2latin1(givennames),
         lnames = html2latin1(lname),
         birthplace = html2latin1(birthplace),
         deathplace = html2latin1(deathplace))
  # mutate(birthdate = ifelse(birthdate == "0000-00-00", NA, birthdate),
  #        deathdate = ifelse(deathdate == "0000-00-00", NA, deathdate))


# find errors in birth/death dates
bd <- aut$birthdate
which(is.na(bd)) |> length()

for (i in seq_along(bd)) {
  if (!is.na(bd[i])) bd[i] = chronos(bd[i])
}


bd <- bd[!is.na(bd)]
bd <- as_date(bd)
which(is.na(bd))
which(is.na(bd)) |> length()

as_Date <- function(x, format = c("ymd", "dmy", "mdy")){
  fmt <- lubridate::guess_formats(x, format)
  fmt <- unique(fmt)
  y <- as.Date(x, format = fmt[1])
  for(i in seq_along(fmt)[-1]){
    na <- is.na(y)
    if(!any(na)) break
    y[na] <- as.Date(x[na], format = fmt[i])
  }
  y
}

bd2 <- as_Date(bd)
which(is.na(bd2))
which(is.na(bd2)) |> length()

aut <- aut |>
  mutate(birthdate = as_date(birthdate),
         deathdate = as_date(deathdate))

# try timeless
#bd <- chronos(aut$birthdate)


author <- aut
save(author, file = here("data", "author.RData"))



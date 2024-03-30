library(here)
library(readr)
library(dplyr)
library(stringr)

source(here("R", "html2latin1.R"))

mstones <- read_csv("data-raw/milestone.csv")

mstones <- mstones |>
  select(-uid) |>
  filter(status != "draft") |>
  # cleanup description field
  mutate(description = html2latin1(description),
         description = gsub("&egrave;",	"è", description),
         note = html2latin1(note)) |>
  mutate(description = gsub("</?p>", "", description),
         location = gsub("</?p>", "", location))

mstones <- mstones |>
  rename(slug = title)
  #   |>
  # mutate(date = ifelse(date_from == date_to, date_from, paste0(date_from, "-", date_to)))


# TODO: Do we need to export both the date_from & date_from_numeric fields?

View(mstones)


milestone <- mstones
save(milestone, file = here("data", "milestone.RData"))




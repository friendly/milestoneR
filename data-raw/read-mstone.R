library(here)
library(readr)
library(dplyr)
library(stringr)

source(here("data-raw", "html2latin1.R"))

mstones <- read_csv("data-raw/milestone.csv")

mstones <- mstones |>
  select(-uid) |>
  filter(status != "draft") |>
  # FIRST convert HTML entities (CSV has &lt; &gt; not < >)
  # Note: some entities are double-encoded (e.g., &amp;egrave; instead of &egrave;)
  # so we run html2latin1() twice to handle this
  mutate(title = html2latin1(html2latin1(title)),
         tag = html2latin1(html2latin1(tag)),
         description = html2latin1(html2latin1(description)),
         location = html2latin1(html2latin1(location)),
         note = html2latin1(html2latin1(note)),
         extra = html2latin1(html2latin1(extra))) |>
  # THEN remove HTML tags
  mutate(description = gsub("<[^>]*>", "", description),
         location = gsub("<[^>]*>", "", location))

mstones <- mstones |>
  rename(slug = title)
  #   |>
  # mutate(date = ifelse(date_from == date_to, date_from, paste0(date_from, "-", date_to)))


# TODO: Do we need to export both the date_from & date_from_numeric fields?

# View(mstones)  # commented out for non-interactive use


milestone <- mstones
save(milestone, file = here("data", "milestone.RData"))




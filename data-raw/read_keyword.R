library(here)
library(readr)
library(dplyr)

source(here("data-raw", "html2latin1.R"))

# Read keyword lookup table
keyword <- read_csv("data-raw/keyword.csv", show_col_types = FALSE)

# Convert HTML entities in keyword names
keyword <- keyword |>
  mutate(name = html2latin1(name))

# Save to data/
save(keyword, file = here("data", "keyword.RData"))

cat("Created keyword.RData with", nrow(keyword), "rows\n")

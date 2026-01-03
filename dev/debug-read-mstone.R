library(here)
library(readr)
library(dplyr)
library(stringr)

source(here("data-raw", "html2latin1.R"))

mstones <- read_csv("data-raw/milestone.csv", show_col_types = FALSE)

cat("After reading CSV:\n")
cat("Description 2:", substr(mstones$description[2], 1, 100), "...\n")
cat("Has HTML tags?", grepl("<[^>]+>", mstones$description[2]), "\n\n")

mstones <- mstones |>
  select(-uid) |>
  filter(status != "draft")

cat("After filter:\n")
cat("Description 2:", substr(mstones$description[2], 1, 100), "...\n")
cat("Has HTML tags?", grepl("<[^>]+>", mstones$description[2]), "\n\n")

# Test the gsub directly
test_desc <- mstones$description[2]
cat("Testing gsub on description 2:\n")
cat("Before:", substr(test_desc, 1, 100), "...\n")
test_result <- gsub("<[^>]*>", "", test_desc)
cat("After:", substr(test_result, 1, 100), "...\n")
cat("Still has tags?", grepl("<[^>]+>", test_result), "\n\n")

# Now apply to whole dataframe
mstones <- mstones |>
  mutate(description = gsub("<[^>]*>", "", description),
         location = gsub("<[^>]*>", "", location))

cat("After HTML tag removal:\n")
cat("Description 2:", substr(mstones$description[2], 1, 100), "...\n")
cat("Has HTML tags?", grepl("<[^>]+>", mstones$description[2]), "\n\n")

library(here)
library(readr)

# Read subject lookup table
subject <- read_csv("data-raw/subject.csv", show_col_types = FALSE)

# Save to data/
save(subject, file = here("data", "subject.RData"))

cat("Created subject.RData with", nrow(subject), "rows\n")

library(readr)
library(dplyr)
library(here)

source(here::here("data-raw", "html2latin1.R"))

# read the linking files, sort out some joins

milestone2subject <- read_csv("data-raw/milestone2subject.csv")
subject <- read_csv("data-raw/subject.csv")

milestone2subject <- milestone2subject |>
  left_join(subject, by = "sid") |>
  rename(subject = name)

save(milestone2subject, file = here("data", "milestone2subject.RData"))

milestone2aspect <- read_csv("data-raw/milestone2aspect.csv")
aspect <- read_csv("data-raw/aspect.csv")

milestone2aspect <- milestone2aspect |>
  left_join(aspect, by = "asid") |>
  rename(aspect = name)
save(milestone2aspect, file = here("data", "milestone2aspect.RData"))


milestone2keyword <- read_csv("data-raw/milestone2keyword.csv")
keyword <- read_csv("data-raw/keyword.csv")
milestone2keyword <- milestone2keyword |>
  left_join(keyword, by = "kid") |>
  rename(keyword = name) |>
  mutate(keyword = html2latin1(keyword))
save(milestone2keyword, file = here("data", "milestone2keyword.RData"))


milestone2reference <- read_csv("data-raw/milestone2reference.csv")
save(milestone2reference, file = here("data", "milestone2reference.RData"))


milestone2author <- read_csv("data-raw/milestone2author.csv")

save(milestone2author, file = here("data", "milestone2author.RData"))




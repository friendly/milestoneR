library(readr)
library(dplyr)

# read the linking files, sort out some joins

milestone2subject <- read_csv("data-raw/milestone2subject.csv")
subject <- read_csv("data-raw/subject.csv")

milestone2subject <- milestone2subject |>
  left_join(subject, by = "sid") |>
  rename(subject = name)

milestone2aspect <- read_csv("data-raw/milestone2aspect.csv")
aspect <- read_csv("data-raw/aspect.csv")

milestone2aspect <- milestone2aspect |>
  left_join(aspect, by = "asid") |>
  rename(aspect = name)

milestone2keyword <- read_csv("data-raw/milestone2keyword.csv")
keyword <- read_csv("data-raw/keyword.csv")
milestone2keyword <- milestone2keyword |>
  left_join(keyword, by = "kid") |>
  rename(keyword = name)


milestone2reference <- read_csv("data-raw/milestone2reference.csv")


milestone2author <- read_csv("data-raw/milestone2author.csv")




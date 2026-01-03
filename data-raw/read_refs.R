library(here)
library(readr)
library(dplyr)

source(here("data-raw", "html2latin1.R"))

reference <- read_csv("data-raw/reference.csv")

# fix books that have a booktitle rather than title; booktitle should only be used for incollection.
# This is very messy, but it works.
# Should we also make booktitle NA for books?
fixtitle <- function(type, title, booktitle) {
  if(type != "book") return (title)
  if(is.na(title) & !is.na(booktitle)) return (booktitle)
  title
}

refs <- reference |>
  mutate(type = as.factor(type),
#         year = as.numeric(year),   # some years are ranges
         author = html2latin1(author),
         title = html2latin1(title),
         journal = html2latin1(journal),
         booktitle = html2latin1(booktitle),
         publisher = html2latin1(publisher),
         address = html2latin1(address),
         editor = html2latin1(editor),
         abstract = html2latin1(abstract),
         note = html2latin1(note) )

for (i in 1:nrow(refs)) {
  refs$title[i] = fixtitle(refs$type[i], refs$title[i], refs$booktitle[i])
}

reference <- refs
save(reference, file = here("data", "reference.RData"))






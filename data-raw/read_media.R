library(here)
library(readr)
library(dplyr)
library(lubridate)
library(stringr)
#library(data.table)

source(here("data-raw", "html2latin1.R"))

media <- read_csv("data-raw/mediaitem.csv")

media <- media |>
  mutate(title = html2latin1(title))

# resolve local links
prefix <- "http://datavis.ca/milestones/uploads/images/"
url <- media$url
media$url <- ifelse(str_detect(url, pattern = "^http"), url, paste0(prefix, url))

# make type=="image" refer to all images, not just local ones
imgpat <- "gif|GIF|png|jpg|JPG|jpeg"
type <- media$type
ext <- tools::file_ext(url)
type <- ifelse(str_detect(url, imgpat), "image", "link")
media$type <- type

mediaitem <- media
save(mediaitem, file = here("data", "mediaitem.RData"))


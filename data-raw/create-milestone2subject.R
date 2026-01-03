library(readr)
library(dplyr)

# Create milestone2subject
milestone2subject <- read_csv('data-raw/milestone2subject.csv', show_col_types = FALSE)
subject <- read_csv('data-raw/subject.csv', show_col_types = FALSE)

milestone2subject <- left_join(milestone2subject, subject, by = 'sid')
names(milestone2subject)[3] <- 'subject'

save(milestone2subject, file = 'data/milestone2subject.RData')
cat('Created milestone2subject.RData\n')

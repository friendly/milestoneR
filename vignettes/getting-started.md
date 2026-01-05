---
title: "Getting Started with milestoneR"
author: "Michael Friendly"
date: "2026-01-05"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Getting Started with milestoneR}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



## Introduction

The `milestoneR` package provides R access to the [Milestones Project](http://datavis.ca/milestones) database, a comprehensive collection of important events in the history of data visualization. This vignette demonstrates how to:

- Access milestone data
- Search and filter milestones
- Display results in various formats
- Explore relationships between milestones, authors, and references

## Loading the Package


``` r
library(milestoneR)
```

## Accessing Data

The package provides accessor functions for all main database tables:


``` r
# Get all milestones
ms <- milestone()
#> Error in milestone(): could not find function "milestone"
cat("Total milestones:", nrow(ms), "\n")
#> Error: object 'ms' not found

# Get all authors
aut <- authors()
cat("Total authors:", nrow(aut), "\n")
#> Total authors: 268

# Get all references
refs <- reference()
#> Error in reference(): could not find function "reference"
cat("Total references:", nrow(refs), "\n")
#> Error: object 'refs' not found

# Get keywords, subjects, and aspects
kw <- keyword()
#> Error in keyword(): could not find function "keyword"
subj <- subject()
#> Error in subject(): could not find function "subject"
asp <- aspect()
#> Error in aspect(): could not find function "aspect"

cat("Keywords:", nrow(kw), "\n")
#> Error: object 'kw' not found
cat("Subjects:", nrow(subj), "\n")
#> Error: object 'subj' not found
cat("Aspects:", nrow(asp), "\n")
#> Error: object 'asp' not found
```

## Exploring Milestones

Let's look at the structure of the milestone data:


``` r
# View column names
names(ms)
#> Error: object 'ms' not found

# Look at a few key fields
head(ms[, c("mid", "date_from", "tag", "location")], 10)
#> Error: object 'ms' not found
```

### Date Range Coverage


``` r
# Date range of milestones
cat("Earliest milestone:", min(ms$date_from_numeric, na.rm = TRUE), "\n")
#> Error: object 'ms' not found
cat("Most recent milestone:", max(ms$date_from_numeric, na.rm = TRUE), "\n")
#> Error: object 'ms' not found

# Count by century
ms$century <- (ms$date_from_numeric %/% 100) * 100
#> Error: object 'ms' not found
century_counts <- table(ms$century)
#> Error: object 'ms' not found
print(century_counts)
#> Error: object 'century_counts' not found
```

## Searching Milestones

The package provides three specialized search functions.

### Full-Text Search

Search across milestone fields (description, tag, note):


``` r
# Find milestones mentioning "statistical"
stat_ids <- search_milestones("statistical")
cat("Found", length(stat_ids), "milestones mentioning 'statistical'\n")
#> Found 51 milestones mentioning 'statistical'

# Show the first few
head(stat_ids)
#> [1] 36 38 55 76 94 99

# Use regex to find "chart" OR "graph"
chart_ids <- search_milestones("chart|graph", fields = c("description", "tag"))
cat("\nFound", length(chart_ids), "milestones with 'chart' or 'graph'\n")
#> 
#> Found 132 milestones with 'chart' or 'graph'

# Search only in tags for items marked as "1st" (first)
first_ids <- search_milestones("^1st", fields = "tag")
cat("\nFound", length(first_ids), "milestone tags starting with '1st'\n")
#> 
#> Found 24 milestone tags starting with '1st'
```

### Search by Keywords


``` r
# Find milestones tagged with "contour"
contour_ids <- search_keywords("contour")
cat("Milestones with 'contour' keyword:", paste(contour_ids, collapse = ", "), "\n")
#> Milestones with 'contour' keyword: 65, 117, 145, 83, 53

# Search for statistical keywords
stat_kw_ids <- search_keywords("statistic")
cat("\nMilestones with statistical keywords:", length(stat_kw_ids), "\n")
#> 
#> Milestones with statistical keywords: 10
```

### Search by Author


``` r
# Find William Playfair's milestones
playfair_ids <- search_authors("Playfair")
cat("William Playfair's milestones:", paste(playfair_ids, collapse = ", "), "\n")
#> William Playfair's milestones: 80, 89

# Find all authors named John
john_ids <- search_authors("John", name_fields = "givennames")
cat("\nMilestones by authors named John:", length(john_ids), "\n")
#> 
#> Milestones by authors named John: 20

# Search only last names
nightingale_ids <- search_authors("Nightingale", name_fields = "lname")
cat("\nMilestones by Nightingale:", paste(nightingale_ids, collapse = ", "), "\n")
#> 
#> Milestones by Nightingale: 129
```

## Filtering by Date and Category

Combine direct data frame operations with search functions:


``` r
# Milestones from the 1800s
ms_1800s <- ms[ms$date_from_numeric >= 1800 & ms$date_from_numeric < 1900, ]
#> Error: object 'ms' not found
cat("Milestones from 1800-1899:", nrow(ms_1800s), "\n")
#> Error: object 'ms_1800s' not found

# Early milestones (before 1700)
early <- ms[ms$date_from_numeric < 1700, ]
#> Error: object 'ms' not found
cat("Milestones before 1700:", nrow(early), "\n")
#> Error: object 'early' not found

# Milestones in France
france <- ms[!is.na(ms$location) & grepl("France", ms$location, ignore.case = TRUE), ]
#> Error: object 'ms' not found
cat("Milestones in France:", nrow(france), "\n")
#> Error: object 'france' not found
```

### Filtering by Subject and Aspect

Using the linking tables:


``` r
# Get milestones by subject
m2subj <- milestone2subject()
#> Error in milestone2subject(): could not find function "milestone2subject"

# Milestones with "Physical" subject
physical_mids <- m2subj[m2subj$subject == "Physical", "mid"]
#> Error: object 'm2subj' not found
cat("Milestones with 'Physical' subject:", length(physical_mids), "\n")
#> Error: object 'physical_mids' not found

# Get milestones by aspect
m2asp <- milestone2aspect()
#> Error in milestone2aspect(): could not find function "milestone2aspect"

# Milestones with "Cartography" aspect
carto_mids <- m2asp[m2asp$aspect == "Cartography", "mid"]
#> Error: object 'm2asp' not found
cat("Milestones with 'Cartography' aspect:", length(carto_mids), "\n")
#> Error: object 'carto_mids' not found

# Combine: Cartography AND Physical
combined <- intersect(physical_mids, carto_mids)
#> Error: object 'physical_mids' not found
cat("\nMilestones that are both Physical and Cartography:", length(combined), "\n")
#> Error: object 'combined' not found
```

## Displaying Results

The package provides several print functions with multiple output formats.

### Printing Individual Milestones


``` r
# Print Halley's 1701 contour map in text format
halley <- ms[ms$date_from_numeric == 1701, ]
#> Error: object 'ms' not found
print_milestone(halley$mid)
#> Error: object 'halley' not found
```

### Different Output Formats


``` r
# HTML format (useful for R Markdown documents)
print_milestone(53, result = "html")

# Markdown format
print_milestone(53, result = "md")

# Enhanced CLI format with clickable links (in modern terminals)
print_milestone_cli(53)
```

### Printing Multiple Milestones


``` r
# Print Playfair's milestones
print_milestone_cli(playfair_ids)
```

### Selective Sections

You can control which sections to display:


``` r
# Show only authors, media, and references
print_milestone(53, include = c("authors", "media", "references"))
```

### Search with Formatted Output

Combine search with immediate formatted display:


``` r
# Find and print Florence Nightingale's work
search_milestones("Florence Nightingale",
                  fields = "description",
                  output = "print")
#> [1829] Polar-area charts
#> Authors: André Michel Guerry
#> 
#> Polar-area charts (predating those by Florence Nightingale cite{Nightingale:1857}), showing frequency of events for cyclic phenomena
#> 
#> Location: France
#> Keywords: chart!polar, coxcomb
#> Subjects: Physical
#> Aspects: Statistics & Graphics
#> 
#> Media:
#>   - [image] Guerry's polar diagrams
#>   - [image] Guerry barcharts and polar diagrams
#> 
#> Note: The plate shows six polar diagrams for daily phenomena: direction of the wind in 8 sectors, births and deaths by hour of theday.
#> 
#> References:
#>   - Balbi, Adriano & Guerry, André-Michel. (1829). "Tableau des Variations météorologique comparées aux phénomènes physiologiques, d'aprés les observations faites à l'Obervatoire royal, et les recherches statistique les plus récentes". _Annales d'Hygiène Publique et de Médecine Légale_. 1. pp. 228-
```

## Working with Related Information

Use helper functions to get related data for milestones.

### Getting Authors


``` r
# Get authors for Halley's milestone
halley_authors <- get_milestone_authors(53)
print(halley_authors[, c("givennames", "lname", "birth_year", "death_year")])
#> Error in `[.data.frame`(halley_authors, , c("givennames", "lname", "birth_year", : undefined columns selected

# Get authors for multiple milestones
playfair_authors <- get_milestone_authors(playfair_ids)
print(playfair_authors[, c("givennames", "lname", "birth_year")])
#> Error in `[.data.frame`(playfair_authors, , c("givennames", "lname", "birth_year")): undefined columns selected
```

### Getting References


``` r
# Get references for a milestone
halley_refs <- get_milestone_references(53)
print(halley_refs[, c("rid", "author", "year", "title")])
#>   rid          author year
#> 1 290  Halley, Edmund 1701
#> 2 365 Abbott, Edwin A 1884
#>                                                                                                            title
#> 1 The Description and Uses of a New, and Correct Sea-Chart of the Whole World, Shewing Variations of the Compass
#> 2                                                                         Flatland: A Romance of Many Dimensions

# Print formatted reference
print_reference(halley_refs[1, ])
#> Halley, Edmund. (1701). "The Description and Uses of a New, and Correct Sea-Chart of the Whole World, Shewing Variations of the Compass"
```

### Getting Keywords


``` r
# Get keywords for a milestone
halley_kw <- get_milestone_keywords(53)
print(halley_kw)
#>     mid kid     keyword
#> 325  53  38 contour map
#> 324  53 128    isogonic

# Get all keywords for Playfair's work
playfair_kw <- get_milestone_keywords(playfair_ids)
print(table(playfair_kw$keyword))
#> 
#>    bar chart circle graph   line graph    pie chart 
#>            1            1            1            1
```

### Getting Media Items


``` r
# Get media items for a milestone
halley_media <- get_milestone_media(53)
print(halley_media[, c("miid", "type", "title")])
#>     miid  type                                                  title
#> 566 1339  link        National maritime museum, Halley magnetic chart
#> 567 1340 image                                    Halley isogonic map
#> 568 1341  link                                       Halley biography
#> 569 1342  link Geomagnetism: early concept of the North Magnetic Pole

# Check how many milestones have media
all_media <- get_milestone_media(ms$mid)
#> Error: object 'ms' not found
cat("Total media items:", nrow(all_media), "\n")
#> Error: object 'all_media' not found
cat("Milestones with media:", length(unique(all_media$mid)), "\n")
#> Error: object 'all_media' not found
```

## Printing References and Authors

### References


``` r
# Print a reference in text format
print_reference(halley_refs[1, ])
#> Halley, Edmund. (1701). "The Description and Uses of a New, and Correct Sea-Chart of the Whole World, Shewing Variations of the Compass"

# Print as BibTeX
cat("\nAs BibTeX:\n")
#> 
#> As BibTeX:
print_reference(halley_refs[1, ], bibtex = TRUE)
#> @article{Halley:1701,
#>   author = {Halley, Edmund},
#>   title = {The Description and Uses of a New, and Correct Sea-Chart of the Whole World, Shewing Variations of the Compass},
#>   year = {1701},
#>   publisher = {Author},
#>   address = {London}
#> }

# Print multiple references
print_reference(halley_refs)
#> Halley, Edmund. (1701). "The Description and Uses of a New, and Correct Sea-Chart of the Whole World, Shewing Variations of the Compass" 
#> 
#> Abbott, Edwin A. (1884). "Flatland: A Romance of Many Dimensions". Cutchogue, NY: Buccaneer Books. [(1976 reprint of the 1884 edition)]
```

### Authors


``` r
# Print author information
print_author(halley_authors[1, ])
#> Edmond Halley; born: Haggerston, Shoreditch, England (1656-11-08); died: Greenwich, England (1742-01-14)

# Get a specific author by name
playfair_aut <- aut[grepl("Playfair", aut$lname), ]
print_author(playfair_aut[1, ])
#> William Playfair; born: Dundee, Scotland (1759-09-22); died: London, England (1823-02-11); [
#> ]
```

## Example Workflow: Researching a Topic

Here's a complete example of researching "contour maps" in the history of data visualization:


``` r
# 1. Search for contour-related milestones
contour_text <- search_milestones("contour", fields = c("description", "tag"))
contour_kw <- search_keywords("contour")

# Combine results (union)
contour_all <- unique(c(contour_text, contour_kw))
cat("Found", length(contour_all), "contour-related milestones\n")
#> Found 6 contour-related milestones

# 2. Get the milestone data
contour_ms <- ms[ms$mid %in% contour_all, ]
#> Error: object 'ms' not found

# 3. Sort by date
contour_ms <- contour_ms[order(contour_ms$date_from_numeric), ]
#> Error: object 'contour_ms' not found

# 4. Display summary
cat("\nContour map milestones chronology:\n")
#> 
#> Contour map milestones chronology:
for (i in 1:nrow(contour_ms)) {
  cat(sprintf("[%s] %s\n",
              contour_ms$date_from[i],
              contour_ms$tag[i]))
}
#> Error: object 'contour_ms' not found

# 5. Get all authors involved
contour_authors <- get_milestone_authors(contour_all)
cat("\nAuthors involved in contour mapping:\n")
#> 
#> Authors involved in contour mapping:
unique_authors <- unique(contour_authors[, c("givennames", "lname", "birth_year")])
#> Error in `[.data.frame`(contour_authors, , c("givennames", "lname", "birth_year")): undefined columns selected
print(unique_authors[order(unique_authors$birth_year), ])
#> Error: object 'unique_authors' not found

# 6. Print detailed information for the earliest one
cat("\n--- Earliest Contour Map Milestone ---\n")
#> 
#> --- Earliest Contour Map Milestone ---
print_milestone(contour_ms$mid[1])
#> Error: object 'contour_ms' not found
```

## Combining Filters

Create complex queries by combining multiple search strategies:


``` r
# Find statistical graphics in the 1800s
stat_ids <- search_milestones("statistical")
ms_stat <- ms[ms$mid %in% stat_ids, ]
#> Error: object 'ms' not found
stat_1800s <- ms_stat[ms_stat$date_from_numeric >= 1800 &
                       ms_stat$date_from_numeric < 1900, ]
#> Error: object 'ms_stat' not found

cat("Statistical graphics milestones in the 1800s:", nrow(stat_1800s), "\n")
#> Error: object 'stat_1800s' not found

# Show them
print(stat_1800s[, c("mid", "date_from", "tag")][1:5, ])
#> Error: object 'stat_1800s' not found
```

## Summary Statistics

Get overview statistics about the database:


``` r
# Count by subject
m2subj <- milestone2subject()
#> Error in milestone2subject(): could not find function "milestone2subject"
subj_counts <- table(m2subj$subject)
#> Error: object 'm2subj' not found
cat("Milestones by Subject:\n")
#> Milestones by Subject:
print(subj_counts)
#> Error: object 'subj_counts' not found

# Count by aspect
m2asp <- milestone2aspect()
#> Error in milestone2aspect(): could not find function "milestone2aspect"
asp_counts <- table(m2asp$aspect)
#> Error: object 'm2asp' not found
cat("\nMilestones by Aspect:\n")
#> 
#> Milestones by Aspect:
print(asp_counts)
#> Error: object 'asp_counts' not found

# Most common keywords (top 10)
m2kw <- milestone2keyword()
#> Error in milestone2keyword(): could not find function "milestone2keyword"
kw_counts <- sort(table(m2kw$keyword), decreasing = TRUE)
#> Error: object 'm2kw' not found
cat("\nTop 10 Keywords:\n")
#> 
#> Top 10 Keywords:
print(head(kw_counts, 10))
#> Error: object 'kw_counts' not found

# Milestones per century
century_table <- table(ms$century)
#> Error: object 'ms' not found
cat("\nMilestones per Century:\n")
#> 
#> Milestones per Century:
print(century_table)
#> Error: object 'century_table' not found
```

## Next Steps

This vignette has covered the basics of accessing, searching, and displaying milestones data. For more advanced usage:

- See `vignette("visualizing-milestones")` for creating plots and visualizations
- Use `?search_milestones` for advanced search options
- Explore `?print_milestone_cli` for enhanced console output with clickable links
- Check the [package website](https://github.com/friendly/milestoneR) for updates

## References

Friendly, M., Sigal, M. & Harnanansingh, D. (2015).
"The Milestones Project: A Database for the History of Data Visualization."
In Kimball, M. & Kostelnick, C. (Eds.)
*Visible Numbers: The History of Data Visualization*, Chapter 10.
London, UK: Ashgate Press.
[preprint](http://datavis.ca/papers/MilestonesProject.pdf)

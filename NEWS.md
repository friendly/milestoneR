## Version 0.3.0

* Re-design to use the `.csv` files from the Milestones Project database directly in the package, rather than using any DBI stuff
* Fixed HTML entities to use latin1 / utf8 encoding in the Milestones .RData files.
* Added missing aspect/subject/keyword datasets
* All data tables now available via accessor functions like `authors()`, `milestone()`
* Added `print_reference()`, print_author()` w/ output to text, html, markdown, bibtex
* Implement `print_milestone()` method with helper functions
* Added search_* functions
* Display media items [link|image] in the print method
* Added CLI output support to `print_milestone()` via `result = "cli"` parameter for enhanced console output with clickable links
* `print_milestone_cli()` is now a convenience wrapper around `print_milestone(result = "cli")`
* Fixed NULL values in references and milestones tables: NULL -> NA
* Converted roxygen documentation to use markdown, via `roxygen2md::roxygen2md()`
* Added "Getting Started" vignette demonstrating search, filter, and print functions


## milestoneR 0.0.0.9000

* Initial package, with database files (`data-raw/`) and R datasets (`data/`)
* Added a `NEWS.md` file to track changes to the package.

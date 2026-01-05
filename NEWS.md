## Version 0.3.0

* Re-design to use the `.csv` files from the Milestones Project database directly in the package, rather than using any DBI stuff
* Fixed HTML entities to use latin1 / utf8 encoding in the Milestones .RData files.
* Added missing aspect/subject/keyword datasets
* All data tables now available via accessor functions like `authors()`, `milestone()`
* Added `print_reference()`, print_author()` w/ output to text, html, markdown, bibtex
* Implement `print_milestone()` method with helper functions

## milestoneR 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.

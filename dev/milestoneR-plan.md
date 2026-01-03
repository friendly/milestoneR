# milestoneR Fixes - 2026-01-03

## Problems Identified

The package had several critical issues preventing it from working:

1. **Broken Database Connection Code** - All accessor functions except `milestone()` tried to connect to a non-existent MySQL database instead of loading from package data files
2. **Variable Name Errors** - Multiple typos and undefined variables (e.g., `mstones_con`, `mitems_con`, `.mstone.env$connnection` with 3 n's)
3. **Inconsistent Implementation** - `authors()` used data.table syntax while the rest used dplyr/tibble
4. **Missing Dependencies** - data.table, DBI, RMySQL, tools were used but not in DESCRIPTION
5. **Missing Data File** - `milestone2subject.RData` was not present in data/

## Changes Made

### 1. Fixed R/author.R
- **Before**: Used `dbReadTable()` to connect to database, used data.table syntax extensively
- **After**: Simple function that loads `author.RData` from package data using `data()` function
- **Pattern**: Follows same approach as `milestone()` function
- **Code**:
  ```r
  authors <- function() {
    .author.env <- new.env()
    data(author, package = 'milestoneR', envir = .author.env)
    .author.env$author
  }
  ```

### 2. Fixed R/reference.R
- **Before**: Used undefined `.mstone.env$connnection` (typo), wrong variable names (`mstones` instead of `refs`)
- **After**: Simple function that loads `reference.RData` from package data
- **Note**: The `fixtitle()` processing is already done in `data-raw/read_refs.R`
- **Code**:
  ```r
  reference <- function() {
    .reference.env <- new.env()
    data(reference, package = 'milestoneR', envir = .reference.env)
    .reference.env$reference
  }
  ```

### 3. Fixed R/mediaitem.R
- **Before**: Used undefined `mstones_con` and `mitems_con` variables
- **After**: Simple function that loads `mediaitem.RData` from package data
- **Note**: URL processing and type detection already done in `data-raw/read_media.R`
- **Code**:
  ```r
  mediaitem <- function() {
    .mediaitem.env <- new.env()
    data(mediaitem, package = 'milestoneR', envir = .mediaitem.env)
    .mediaitem.env$mediaitem
  }
  ```

### 4. Created Missing Data File
- **File**: `data/milestone2subject.RData`
- **Script**: Created `data-raw/create-milestone2subject.R` to generate this file
- **Process**: Joins `milestone2subject.csv` with `subject.csv` to add subject names

## Architecture

The package now follows a clean separation:

1. **data-raw/*.csv** - Raw CSV files exported from MySQL database
2. **data-raw/*.R** - Processing scripts that clean/transform CSVs and save as .RData files
3. **data/*.RData** - Processed R data objects ready for use
4. **R/*.R** - Accessor functions that simply load and return the data objects

## Dependencies Removed

By fixing the accessor functions, we no longer need:
- data.table
- DBI
- RMySQL
- tools (except for data-raw processing)

Current dependencies (from DESCRIPTION):
- dplyr
- tibble
- lubridate
- textutils

## Testing

Run `dev/test-functions.R` to verify all accessor functions work:
```r
source("dev/test-functions.R")
```

This will test:
- `milestone()` ✓
- `authors()` ✓
- `reference()` ✓
- `mediaitem()` ✓

## Outstanding Issues (from original code TODOs)

1. **R/milestone.R:21-23** - Quoted string handling in descriptions
   - Issue: Patterns like `(\"star plot&#039;&#039;)` → `(\"star plot'')`
   - Need gsub to fix quotes after `\".*`

2. **R/milestone.R:25** - Should both `date_from` and `date_from_numeric` be exported?

3. **R/reference.R:28** - Need function to convert references back to BibTeX format

4. **R/html2latin1.R:74-87** - Bug in `latin12html()` where "number" type never executes (duplicate conditional)

## HTML Entity Conversion Functions

### Current Status

The package has two HTML entity conversion functions:
- **`html2latin1()`** (in R/html2latin1.R) - Main conversion function, works correctly
- **`html2utf8()`** (in R/html2utf8.R) - Deprecated, will be removed per documentation

### Where They're Used

1. **In data-raw scripts** (ACTIVE USE):
   - `read-mstone.R` - applies to `description` and `note` fields
   - `read_author.R` - applies to `givennames`, `lname`, `birthplace`, `deathplace`
   - `read_refs.R` - applies to `author`, `title`, `journal` **BUT INCOMPLETE**
   - `read_media.R` - applies to `title`
   - `resolve-links.R` - applies to `keyword`

2. **In R/ accessor functions** (NOT USED):
   - All accessor functions now load pre-processed .RData files
   - No HTML conversion happens at runtime
   - This is correct design - conversion should happen during data-raw processing

3. **Exported for users** (AVAILABLE):
   - Both functions are exported in NAMESPACE
   - Users can use them if needed for their own HTML-encoded data

### Problems Found

**Incomplete HTML conversion in reference.RData:**
Running `dev/check-html-entities.R` shows:
- `reference.RData` has 75 entries with HTML entities in `title`, `booktitle`, `publisher`, `editor`
- `milestone.RData` has 6 entries with `&amp;` and `&nbsp;` in `description`

**Root cause:** `data-raw/read_refs.R` only applies `html2latin1()` to 3 fields (`author`, `title`, `journal`) but entities exist in other fields too (`booktitle`, `publisher`, `editor`).

### Recommendation

1. **Keep html2latin1.R** - It's needed for data-raw processing and works correctly
2. **Remove html2utf8.R** - Already marked as deprecated in its documentation
3. **Fix data-raw/read_refs.R** - Apply html2latin1() to all character fields
4. **Regenerate reference.RData** - After fixing the script
5. **Consider** whether to keep these functions exported for users

## HTML Conversion Fixes - COMPLETED

### Changes Made (2026-01-03)

**IMPORTANT:** html2latin1.R and html2utf8.R have been moved from `R/` to `data-raw/` since they are only used during data processing, not at runtime.

1. **Enhanced .HTMLChars table** (data-raw/html2latin1.R)
   - Added smart quote entities: `&lsquo;`, `&rsquo;`, `&ldquo;`, `&rdquo;`
   - Used Unicode escape codes (\u2018, \u2019, \u201C, \u201D) to avoid syntax errors

2. **Fixed data-raw/read_refs.R**
   - Applied `html2latin1()` to ALL character fields: author, title, journal, booktitle, publisher, address, editor, abstract, note
   - Previously only converted 3 fields, leaving entities in booktitle, publisher, editor

3. **Fixed data-raw/read-mstone.R**
   - **Critical fix:** Changed order of operations - convert HTML entities FIRST, then strip tags
     - CSV has `&lt;p&gt;` not `<p>`, so tags must be decoded before stripping
   - **Double-encoding fix:** Run `html2latin1()` TWICE to handle double-encoded entities
     - CSV has `&amp;egrave;` which becomes `&egrave;` after first pass, then `è` after second
     - CSV has `&amp;nbsp;` which becomes `&nbsp;` after first pass, then space after second
   - Commented out `View(mstones)` which fails in non-interactive mode

4. **Regenerated all .RData files**
   - reference.RData - now has NO HTML entities
   - milestone.RData - HTML tags stripped, all entities converted

### Verification

Running `dev/check-html-entities.R` confirms:
- ✅ milestone.RData: NO HTML entities, NO HTML tags
- ✅ author.RData: NO HTML entities
- ✅ reference.RData: NO HTML entities
- ✅ mediaitem.RData: NO HTML entities

All .RData files are now clean!

## HTML Files Moved to data-raw/ - COMPLETED (2026-01-03)

### Files Moved
- `R/html2latin1.R` → `data-raw/html2latin1.R`
- `R/html2utf8.R` → `data-raw/html2utf8.R`

### Rationale
These functions are only used during data processing (in data-raw/ scripts), not at runtime by the package accessor functions. Moving them clarifies this and removes them from the package exports.

### Updated Scripts (8 files)
All `source()` calls updated from `here("R", "html2latin1.R")` to `here("data-raw", "html2latin1.R")`:

**data-raw/ scripts (5):**
1. read-mstone.R:6
2. read_author.R:8
3. read_media.R:8
4. read_refs.R:5
5. resolve-links.R:5

**dev/ test scripts (3):**
1. debug-read-mstone.R:6
2. test-html2latin1.R:1
3. test-specific-conversion.R:1

### Verification
All scripts tested and working correctly with html2latin1.R in its new location.

## Added Missing Lookup Tables - COMPLETED (2026-01-03)

### New Data Files Created
Created .RData files for three lookup tables that were missing:

1. **aspect.RData** (4 rows) - Aspect classifications: Cartography, Statistics & Graphics, Technology, Other
2. **subject.RData** (4 rows) - Subject classifications: Physical, Mathematical, Human, Other
3. **keyword.RData** (335 rows) - Keywords/terms for milestone items

### New R/ Documentation Files Created
Created 8 new accessor functions with full roxygen documentation:

**Lookup tables:**
1. `aspect()` - R/aspect.R
2. `subject()` - R/subject.R
3. `keyword()` - R/keyword.R

**Linking tables:**
4. `milestone2aspect()` - R/milestone2aspect.R
5. `milestone2subject()` - R/milestone2subject.R
6. `milestone2keyword()` - R/milestone2keyword.R
7. `milestone2author()` - R/milestone2author.R
8. `milestone2reference()` - R/milestone2reference.R

### Data Processing Scripts Created
Created in data-raw/:
1. `read_aspect.R` - Converts aspect.csv to aspect.RData
2. `read_subject.R` - Converts subject.csv to subject.RData
3. `read_keyword.R` - Converts keyword.csv to keyword.RData (with HTML entity conversion)

### NAMESPACE Updated
All 8 new functions exported:
```r
export(aspect)
export(keyword)
export(milestone2aspect)
export(milestone2author)
export(milestone2keyword)
export(milestone2reference)
export(milestone2subject)
export(subject)
```

### Verification
All data files tested and working correctly. See `dev/test-new-data-files.R` for verification.

## Next Steps

1. Run `devtools::check()` to verify package integrity
2. Test package installation with `devtools::install()`
3. Consider addressing the outstanding TODOs

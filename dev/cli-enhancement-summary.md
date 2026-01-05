# CLI Package Enhancement for print_milestone()

## Overview

Created a new `print_milestone_cli()` function that uses the {cli} package to provide enhanced console output with clickable hyperlinks, better formatting, and improved visual structure.

## Implementation

### New Function: `print_milestone_cli()`

**File:** `R/print_milestone_cli.R`

**Purpose:** Enhanced console printing using the {cli} package features

**Key Features:**

1. **Clickable Hyperlinks**
   - Media URLs are rendered as clickable links in modern terminals
   - Uses `{.href [text](url)}` syntax for hyperlinks
   - Example: `{.href [Halley isogonic map](http://datavis.ca/.../halley-map.jpg)}`

2. **Visual Structure**
   - `cli_h1()` for main milestone header with divider
   - `cli_h2()` for section headers (Media, References)
   - `cli_rule()` for visual separators between multiple milestones
   - `cli_ul()` and `cli_li()` for bulleted lists

3. **Text Formatting**
   - `{.strong text}` for bold labels (Authors, Keywords, etc.)
   - `{.emph text}` for italicized titles (journal names, book titles)
   - Enhanced readability with proper whitespace

4. **Special Character Handling**
   - Custom `.cli_escape()` helper function to escape curly braces
   - Prevents cli from parsing `{` and `}` in user text as inline markup
   - Critical for references with notes like "Loc{BL: 532.l.6}"

### Helper Functions

#### `.cli_escape(text)`
Escapes curly braces in text to prevent cli from interpreting them as inline markup:
```r
.cli_escape <- function(text) {
  if (is.na(text) || nchar(text) == 0) return(text)
  text <- gsub("\\{", "{{", text, fixed = FALSE)
  text <- gsub("\\}", "}}", text, fixed = FALSE)
  text
}
```

#### `.format_cli_milestone(ms, include, show_images)`
Main formatting function that:
- Escapes all text fields before passing to cli functions
- Builds structured output using cli_h1(), cli_h2(), cli_text(), cli_ul(), cli_li()
- Calls `.format_cli_reference()` for each reference

#### `.format_cli_reference(ref)`
Formats references with:
- Bold author names
- Quoted article titles, italicized book titles
- Italicized journal/book container names
- Proper handling of volume, number, pages, publisher
- Escaped note fields

### Package Dependencies

**Modified:** `DESCRIPTION`
```
Imports:
    cli
```

**Added imports:** `@importFrom cli cli_h1 cli_h2 cli_text cli_ul cli_li cli_rule cli_end`

## Output Examples

### Single Milestone
```
── [1701] 1st contour map? ─────────────────────────────────────────────────────
Authors: Edmond Halley

Contour maps showing curves of equal value (an isogonic map, lines of equal
magnetic declination for the world, possibly the first contour map of a
data-based variable)

Keywords: contour map, isogonic
Subjects: Physical
Aspects: Statistics & Graphics


── Media ──

• National maritime museum, Halley magnetic chart
(<http://www.nmm.ac.uk/collections/explore/object.cfm?ID=G201%3A1%2F1>) [link]
• Halley isogonic map
(<http://datavis.ca/milestones/uploads/images/palsky/halley-map.jpg>) [image]
• Halley biography (<http://galileo.rice.edu/Catalog/NewFiles/halley.html>)
[link]


── References ──

  • Halley, Edmund. (1701). "The Description and Uses of a New, and Correct
  Sea-Chart of the Whole World, Shewing Variations of the Compass". London:
  Author
  • Abbott, Edwin A. (1884). Flatland: A Romance of Many Dimensions. Cutchogue,
  NY: Buccaneer Books. [(1976 reprint of the 1884 edition)]
```

### Multiple Milestones
When multiple milestones are printed, they're separated by a visual rule:
```
── [1626] Sunspots ───────────────────────────────────────────────────────────
[... milestone content ...]

────────────────────────────────────────────────────────────────────────────────

── [1701] 1st contour map? ─────────────────────────────────────────────────────
[... milestone content ...]
```

## Usage

```r
# Load package
library(milestoneR)

# Print a single milestone
print_milestone_cli(53)

# Print multiple milestones
print_milestone_cli(c(53, 54, 55))

# Print with selected sections only
print_milestone_cli(53, include = c("authors", "media", "references"))

# Combine with search
nightingale_ids <- search_milestones("Nightingale", fields = "description")
print_milestone_cli(nightingale_ids[1])
```

## Technical Challenges Solved

### 1. Curly Brace Escaping
**Problem:** cli interprets `{text}` as inline markup, causing errors when milestone text contains braces.

**Example Error:**
```
Error in `cli::cli_li(ref_text)`:
! Could not parse cli `{}` expression: `BL: 532.l.6`.
```

**Solution:** Created `.cli_escape()` function that converts `{` to `{{` and `}` to `}}` before passing text to cli functions.

### 2. Reference Duplication
**Problem:** Some book references had identical `title` and `booktitle` fields, causing duplication like:
```
Abbott, Edwin A. (1884). Flatland: A Romance of Many Dimensions.
                        Flatland: A Romance of Many Dimensions. ...
```

**Solution:** Only include `booktitle` if it differs from `title`:
```r
if (is.na(ref$title) || ref$booktitle != ref$title) {
  parts <- c(parts, paste0("{.emph ", booktitle_safe, "}"))
}
```

### 3. Article vs. Book Formatting
**Problem:** Different citation styles for articles (quoted titles) vs. books (italicized titles).

**Solution:** Detect reference type and format accordingly:
```r
is_part <- !is.na(ref$type) && ref$type %in% c("article", "inproceedings", "incollection")

if (is_part) {
  # Article/chapter: "Title" in quotes
  parts <- c(parts, paste0('"', title_safe, '"'))
} else {
  # Book: Title in italics
  parts <- c(parts, paste0("{.emph ", title_safe, "}"))
}
```

## Comparison with Original `print_milestone()`

| Feature | `print_milestone()` | `print_milestone_cli()` |
|---------|---------------------|-------------------------|
| Output formats | text, html, md | console only |
| Clickable links | No | Yes (in modern terminals) |
| Visual structure | Plain text | Headers, rules, bullets |
| Text formatting | None | Bold, italics via cli |
| Media display | Plain list | Bulleted list with links |
| References | Plain text | Formatted with bold/italics |
| Dependencies | Base R | Requires {cli} package |

## Future Enhancements

Possible additions (not currently implemented):

1. **Color coding** - Use cli colors for different sections
2. **Progress indicators** - For multiple milestones, show progress bar
3. **Interactive selection** - Let users select which sections to display
4. **Link validation** - Check if URLs are accessible and mark broken links
5. **Citation export** - Add option to copy formatted citation to clipboard
6. **Image preview** - In terminals that support it, show image thumbnails
7. **Compact mode** - Option for single-line summary format

## Package Status

After implementation:
- ✅ `devtools::check()` passes with **0 errors, 0 warnings, 0 notes**
- ✅ All text fields properly escaped for cli
- ✅ References format correctly without duplication
- ✅ Media items show with clickable hyperlinks
- ✅ Visual structure improved with headers and lists
- ✅ Works with search functions for integrated workflow

## Design Decision

Created as a **separate function** (`print_milestone_cli()`) rather than modifying `print_milestone()` because:

1. **Testing** - Allows side-by-side comparison during development
2. **Compatibility** - Doesn't break existing code using `print_milestone()`
3. **Dependencies** - Users can choose whether to install {cli} package
4. **Flexibility** - Original function still supports HTML/markdown output formats

**Future:** Can replace `print_milestone()` after testing confirms stability, or keep both functions for different use cases.

## Documentation

- Full roxygen2 documentation with `@importFrom` directives
- Examples showing single and multiple milestone printing
- Usage notes about clickable links in modern terminals
- Cross-references to related functions

## References

- {cli} package documentation: https://cli.r-lib.org/
- cli inline markup: `?cli::inline-markup`
- cli themes and formatting: https://cli.r-lib.org/articles/semantic-cli.html

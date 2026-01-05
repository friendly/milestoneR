# Planning Document: print_milestone() Function

## Overview

Create a `print_milestone()` function to display milestone items with all associated information (authors, references, media items, keywords, subjects, aspects) in various formats (text, HTML, markdown).

## Current Site Structure (from screenshot)

Based on `dev/datavis-milestone-item.png`, the datavis.ca site displays:

1. **Header Line**
   - Date (left): "1701"
   - Author link (left): "Edmond Halley" (clickable)
   - Title/Tag (right): "1st contour map?"
   - Added date (top right): "Added: 2008-07-17"

2. **Main Description**
   - Full text description of the milestone
   - May contain embedded links to external resources

3. **External Links** (appear as separate blue links)
   - National maritime museum, Halley magnetic chart
   - Halley biography
   - Geomagnetism: early concept of the North Magnetic Pole
   - Followed by explanatory text

4. **Media Items**
   - Image displayed on right side
   - Caption: "Halley isogonic map"

5. **References Section**
   - "References:" header
   - Links to references: "Halley:1701" "Abbott:1884"

## Data Structure Analysis

### Main Table: milestone
- `mid` - milestone ID
- `slug` - URL slug
- `date_from`, `date_from_numeric` - start date
- `date_to`, `date_to_numeric` - end date (for ranges)
- `tag` - title/tag line (e.g., "1st contour map?")
- `description` - main text description
- `location` - geographic location
- `add_date`, `modified_date` - metadata
- `status` - publication status
- `note` - internal notes
- `extra` - additional information

### Linking Tables and Related Data
1. **Authors** via `milestone2author`
   - Links `mid` to `aid`
   - Need to join with `author` table for full names

2. **References** via `milestone2reference`
   - Links `mid` to `rid`
   - Need to join with `reference` table for citation info

3. **Media Items** via `milestone2mediaitem`
   - Links `mid` to `mediaid`
   - Need to join with `mediaitem` table for images/media

4. **Keywords** via `milestone2keyword`
   - Links `mid` to `kid`
   - Includes `keyword` field directly

5. **Subjects** via `milestone2subject`
   - Links `mid` to `sid`
   - Need to join with `subject` table

6. **Aspects** via `milestone2aspect`
   - Links `mid` to `aspectid`
   - Need to join with `aspect` table

## Implementation Approaches

### Approach 1: Single Function with Full Join
Create one function that performs all joins and returns a formatted output.

**Pros:**
- Single function call gives complete milestone
- Easier for users to understand and use
- Can cache all lookups internally

**Cons:**
- Complex internal logic
- Potentially slow for large datasets
- Hard to customize what information is included

### Approach 2: Helper Functions + Main Function
Create separate helper functions to get each piece, then assemble in main function.

**Pros:**
- Modular design - each component can be used independently
- Easier to test and maintain
- Users can call helpers for specific info (e.g., just get authors for a milestone)
- Can control which sections to include

**Cons:**
- More functions to document
- Potential for redundant data loading

### Approach 3: S3 Object Constructor
Create a `milestone_item` S3 class with all associated data, then a print method.

**Pros:**
- Clean OO design
- Can have multiple print methods for different formats
- Object can be passed around and inspected
- Can add other methods (summary, plot, etc.) later

**Cons:**
- More complex architecture
- Higher learning curve for users
- May be overkill for simple use case

## Recommended Approach: Approach 2 (Helper Functions)

Create modular helper functions that can be used independently or combined:

```r
# Helper functions (can be used directly)
get_milestone_authors(mid)     # Get authors for milestone(s)
get_milestone_references(mid)  # Get references for milestone(s)
get_milestone_media(mid)       # Get media items for milestone(s)
get_milestone_keywords(mid)    # Get keywords for milestone(s)
get_milestone_subjects(mid)    # Get subjects for milestone(s)
get_milestone_aspects(mid)     # Get aspects for milestone(s)

# Main print function
print_milestone(mid,
                result = c("text", "html", "md"),
                include = c("authors", "references", "media", "keywords", "subjects", "aspects"),
                show_images = TRUE)
```

## Output Format Specifications

### TEXT Format
```
[YEAR] Title/Tag
Author1, Author2

Description text here...

Location: Place
Keywords: keyword1, keyword2, keyword3
Subjects: subject1, subject2
Aspects: aspect1, aspect2

Media:
- [Image] Title (type)
- [Image] Title (type)

References:
- Author (Year). Title. Journal...
- Author (Year). Title. Journal...
```

### HTML Format
```html
<div class="milestone">
  <div class="milestone-header">
    <span class="date">1701</span>
    <span class="authors">
      <a href="#">Edmond Halley</a>
    </span>
    <span class="tag">1st contour map?</span>
  </div>

  <div class="description">
    <p>Description text...</p>
  </div>

  <div class="metadata">
    <p><strong>Location:</strong> Place</p>
    <p><strong>Keywords:</strong> keyword1, keyword2</p>
  </div>

  <div class="media">
    <h3>Media</h3>
    <img src="..." alt="...">
  </div>

  <div class="references">
    <h3>References</h3>
    <ul>
      <li>Citation 1</li>
      <li>Citation 2</li>
    </ul>
  </div>
</div>
```

### Markdown Format
```markdown
## [1701] 1st contour map?
**Authors:** Edmond Halley

Description text here...

**Location:** Place
**Keywords:** keyword1, keyword2, keyword3
**Subjects:** subject1, subject2

### Media
- ![Halley isogonic map](url)

### References
- Author (Year). Title. *Journal*...
- Author (Year). Title. *Journal*...
```

## Implementation Steps

1. **Create helper functions** (can be internal or exported)
   - `get_milestone_authors(mid)` - join milestone2author + author
   - `get_milestone_references(mid)` - join milestone2reference + reference
   - `get_milestone_media(mid)` - join milestone2mediaitem + mediaitem
   - `get_milestone_keywords(mid)` - get from milestone2keyword
   - `get_milestone_subjects(mid)` - join milestone2subject + subject
   - `get_milestone_aspects(mid)` - join milestone2aspect + aspect

2. **Create main print function**
   - Accept milestone ID(s) or data frame row(s)
   - Call helper functions to gather all related data
   - Format according to `result` parameter
   - Control what sections to include via `include` parameter

3. **Create formatting functions**
   - `.format_text_milestone(milestone_data)` - plain text
   - `.format_html_milestone(milestone_data)` - simple semantic HTML
   - `.format_markdown_milestone(milestone_data)` - markdown

## Open Questions

1. **Should helper functions be exported?**
   - Pro: Users can get just authors or just references for analysis
   - Con: More API surface to maintain
   - **Decision:** Export them - they're useful for data analysis

2. **How to handle missing data?**
   - Some milestones may have no authors, references, media, etc.
   - **Decision:** Only show sections that have data

3. **Should we create links in output?**
   - Text: No links possible
   - HTML: Could create anchor tags for authors/references
   - Markdown: Could create markdown links
   - **Decision:** Yes for HTML and markdown, use author IDs and reference IDs

4. **How to handle images in text output?**
   - Can't display images in console
   - **Decision:** Show filename/caption/description only

5. **Should we fetch external links from description/extra fields?**
   - Current data has links embedded in description text
   - **Decision:** Initial implementation just shows description as-is; could enhance later

6. **What about the PHP source code?**
   - Would be helpful to see how the site does it
   - **Decision:** Examine PHP if available, but R implementation will differ

## Testing Strategy

1. Test with simple milestone (minimal data)
2. Test with complex milestone (all sections populated)
3. Test with milestone ID vs data frame input
4. Test with multiple milestones
5. Test all output formats
6. Compare output to actual website display

## Future Enhancements

1. **Interactive output** - Use htmlwidgets for interactive HTML
2. **Image embedding** - Use base64 encoding to embed images in HTML
3. **Cross-references** - Link to other milestones mentioned
4. **Export to PDF** - Via markdown -> pandoc
5. **Timeline view** - Show multiple milestones chronologically
6. **Filtering** - Filter by keyword, subject, aspect, date range
7. ~~**Full-text search** - Search across descriptions~~ **✅ IMPLEMENTED**

## Search Functions Implementation

The following search functions have been implemented in `R/search_milestones.R`:

### `search_milestones(pattern, fields, output, ignore.case, ...)`

Primary full-text search function that searches across milestone fields.

**Features:**
- Regular expression support for flexible pattern matching
- Multiple field search with OR logic (matches if pattern appears in ANY field)
- Three output formats: "mid" (IDs), "print" (formatted), "data" (data frame)
- Case-insensitive by default
- Searchable fields: description, tag, note, slug, date_from, date_to, location, extra

**Examples:**
```r
# Find milestones mentioning "statistical"
search_milestones("statistical")

# Search in specific fields with regex
search_milestones("chart|graph", fields = "description")

# Get formatted output
search_milestones("contour", output = "print")

# Case-sensitive search
search_milestones("Map", ignore.case = FALSE)
```

### `search_keywords(pattern, ignore.case, output, ...)`

Convenience function to search by milestone keywords.

**Features:**
- Searches the keyword field in milestone2keyword table
- Returns milestones tagged with matching keywords
- Same output options as search_milestones()

**Examples:**
```r
# Find milestones with statistical keywords
search_keywords("statistic")

# Print results
search_keywords("visualization", output = "print")
```

### `search_authors(pattern, name_fields, ignore.case, output, ...)`

Search for milestones by author name.

**Features:**
- Searches across author name fields (givennames, lname, prefix, suffix)
- Returns milestones associated with matching authors
- Can search specific name fields or all of them

**Examples:**
```r
# Find Playfair's milestones
search_authors("Playfair")

# Find all authors named John
search_authors("John", name_fields = "givennames")

# Search only last names
search_authors("Nightingale", name_fields = "lname")
```

### Implementation Notes

- All search functions use `grepl()` for regex pattern matching
- Empty results return appropriate empty structures with informative messages
- Output formats are consistent across all search functions
- Additional arguments can be passed to `print_milestone()` when output = "print"

## PHP Source Code Analysis

Repository: https://github.com/friendly/milestones (now public)

### Key Files Examined

1. **index.php** - Main controller, handles URL routing and template loading
2. **includes/groups.php** - Retrieves and formats milestone data for display
3. **includes/templates/content/group.tpl.htm** - HTML template for milestone display

### Template Structure (from group.tpl.htm)

The PHP implementation uses the following structure for each milestone:

```html
<!-- BEGIN milestoneContainer -->
<div id="milestoneContainer{MID}">

  <!-- BEGIN milestoneHeader -->
  <div class="milestoneHeader">
    <span class="milestoneDates">{DATE}</span>
    <span class="milestoneAuthor">{AUTHORS}</span>
    <span class="milestoneTag">{TAG}</span>
    <p class="added">Added: {ADDED} {EDITLINK}</p>
  </div>
  <!-- END milestoneHeader -->

  <!-- BEGIN mediaItemImageContainer -->
  <div class="mediaItemImageContainer">
    <!-- BEGIN mediaItemImage (loop) -->
    <a href="{IMAGEURL}" rel="{IMAGEREL}" title="{IMAGETITLE}">
      <img src="{THUMB_URL}" alt="{IMAGECAPTION}"/>
    </a>
    <!-- END mediaItemImage -->
  </div>
  <!-- END mediaItemImageContainer -->

  <!-- BEGIN milestoneDetail -->
  <div class="milestoneDetail">
    <span class="description">{DESCRIPTION}</span>

    <!-- BEGIN mediaitemLink (loop) -->
    <a href="{LINKURL}" title="{LINKTITLE}">{LINKCAPTION}</a>
    <!-- END mediaitemLink -->

    <!-- BEGIN milestoneNotes -->
    <span class="note">{NOTES}</span>
    <!-- END milestoneNotes -->

    <!-- BEGIN milestoneRefs -->
    <p class="references">
      <strong>References:</strong>
      <!-- BEGIN milestoneRef (loop) -->
      <a href="{REFLINK}">{REFTEXT}</a>
      <!-- END milestoneRef -->
    </p>
    <!-- END milestoneRefs -->
  </div>
  <!-- END milestoneDetail -->

</div>
<!-- END milestoneContainer -->
```

### Data Retrieval Pattern (from groups.php)

The PHP code:

1. **Queries milestone table** filtered by:
   - `date_from_numeric` in group date range
   - `status = 'published'`
   - Ordered by `date_from_numeric`

2. **For each milestone, retrieves:**
   - **Authors**: JOIN through `milestone2author` → `author` table
     - Constructs searchable author links
     - Multiple authors shown comma-separated

   - **Media Items**: JOIN through `milestone2mediaitem` → `mediaitem` table
     - Images: Creates thumbnails (80x80), uses Fancybox lightbox
     - Non-images: Creates standard links with type icons

   - **References**: JOIN through `milestone2reference` → `reference` table
     - Uses bibtex keys for citation links
     - Links to reference detail page

   - **Keywords**: JOIN through `milestone2keyword` (not shown in visible template but in data)

3. **Field Processing:**
   - `description`: Decoded with `html_entity_decode()`
   - Date: Formatted via custom `dateAsString()` function
   - Author names: URL-encoded for search links

### Key Observations

- **Conditional sections**: Template only shows sections if data exists (authors, media, notes, references)
- **Media handling**: Separates images (thumbnail gallery) from other media (links)
- **References**: Shown as clickable links using bibtex keys
- **Authors**: Shown as searchable links at top of milestone
- **Date formatting**: Custom function handles date ranges
- **Edit links**: Only shown for authenticated users

## Notes

- The current `print_reference()` and `print_author()` functions can be reused
- Need to handle date ranges (some milestones span multiple years)
- The `slug` field could be used for creating URLs
- Should preserve the structure from the PHP site for consistency based on screenshot analysis

## Appendix: Data Example (Halley 1701 Milestone)

### Main Milestone Record (mid = 53)
```r
milestone[milestone$mid == 53, ]
  mid = 53
  date_from_numeric = 1701
  tag = "1st contour map?"
  description = "Contour maps showing curves of equal value (an isogonic map,
                 lines of equal magnetic declination for the world, possibly
                 the first contour map of a data-based variable)"
```

### Associated Data via Linking Tables

**Authors** (via milestone2author):
```r
milestone2author[milestone2author$mid == 53, ]
  mid = 53, aid = 126  →  Edmond Halley
```

**References** (via milestone2reference):
```r
milestone2reference[milestone2reference$mid == 53, ]
  mid = 53, rid = 290  →  Halley:1701
  mid = 53, rid = 365  →  Abbott:1884
```

**Keywords** (via milestone2keyword):
```r
milestone2keyword[milestone2keyword$mid == 53, ]
  mid = 53, kid = 128, keyword = "isogonic"
  mid = 53, kid = 38,  keyword = "contour map"
```

This shows the relational structure that needs to be joined to create a complete milestone display.

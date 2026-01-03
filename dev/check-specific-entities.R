# Find specific problematic HTML entities

cat("=== Checking milestone.RData ===\n")
load('data/milestone.RData')
desc_with_entities <- milestone$description[grepl("&[a-z]+;", milestone$description, ignore.case=TRUE)]
cat("Found", length(desc_with_entities), "descriptions with HTML entities\n\n")

# Show first 3 examples
for(i in 1:min(3, length(desc_with_entities))) {
  cat("Example", i, ":\n")
  cat(substr(desc_with_entities[i], 1, 200), "...\n\n")
}

# Check tag field too
tag_with_entities <- milestone$tag[grepl("&[a-z]+;", milestone$tag, ignore.case=TRUE)]
if(length(tag_with_entities) > 0) {
  cat("Found", length(tag_with_entities), "tags with HTML entities\n")
  print(head(tag_with_entities))
}

cat("\n=== Checking reference.RData ===\n")
load('data/reference.RData')

# Find the specific entry with &rsquo;
ref_with_rsquo <- reference[grepl("&rsquo;", reference$title, ignore.case=TRUE), ]
if(nrow(ref_with_rsquo) > 0) {
  cat("Found &rsquo; in reference titles:\n")
  print(ref_with_rsquo$title)
}

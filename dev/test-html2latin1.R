source('data-raw/html2latin1.R')

# Test if html2latin1 handles the entities we found
test_strings <- c(
  'Title &amp; Subtitle',
  'Müller',  # already converted
  'M&uuml;ller',  # HTML entity
  '&nbsp;text',
  'L&apos;hospital',
  'caf&eacute;',
  '&auml;&ouml;&Uuml;'
)

cat('Original strings:\n')
print(test_strings)

cat('\nAfter html2latin1:\n')
converted <- html2latin1(test_strings)
print(converted)

cat('\nStill has entities?\n')
still_has <- grepl('&[a-z]+;', converted, ignore.case=TRUE)
print(still_has)

if(any(still_has)) {
  cat('\nProblematic conversions:\n')
  for(i in which(still_has)) {
    cat('  Before:', test_strings[i], '\n')
    cat('  After: ', converted[i], '\n')
  }
}

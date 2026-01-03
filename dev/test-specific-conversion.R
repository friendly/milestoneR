source('data-raw/html2latin1.R')

test_strings <- c(
  'first route map ("carte routi&egrave;re\'\')',
  'StatUS)&nbsp;',
  'exports from 1855-1899.&nbsp; He presented',
  'bodies of text. &nbsp;Their purpose'
)

cat("Testing html2latin1() on problem strings:\n\n")

for(i in 1:length(test_strings)) {
  cat("Original:", test_strings[i], "\n")
  result <- html2latin1(test_strings[i])
  cat("Result:  ", result, "\n")
  cat("Still has entities?", grepl("&[a-z]+;", result, ignore.case=TRUE), "\n\n")
}

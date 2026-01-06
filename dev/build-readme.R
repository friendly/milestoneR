# Build README.md from README.Rmd
suppressMessages(devtools::load_all())
rmarkdown::render("README.Rmd", output_format = "github_document", quiet = TRUE)
cat("README.md successfully generated\n")

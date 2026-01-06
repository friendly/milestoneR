# Test different methods of extracting columns with native pipe
devtools::load_all()

m2subj <- milestone2subject()

cat("Testing getElement():\n")
physical_mids1 <- m2subj |>
  subset(subject == "Physical") |>
  getElement("mid")
cat("Result:", head(physical_mids1), "\n")
cat("Class:", class(physical_mids1), "\n")
cat("Length:", length(physical_mids1), "\n\n")

cat("Testing anonymous function:\n")
physical_mids2 <- m2subj |>
  subset(subject == "Physical") |>
  (\(x) x$mid)()
cat("Result:", head(physical_mids2), "\n")
cat("Class:", class(physical_mids2), "\n")
cat("Length:", length(physical_mids2), "\n\n")

cat("Results identical:", identical(physical_mids1, physical_mids2), "\n")

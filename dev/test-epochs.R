# Test script for epoch functions
# 2026-01-09

library(milestoneR)
devtools::load_all()

cat("=== Testing define_epochs() ===\n\n")

# Test 1: Default epochs
cat("Test 1: Default epochs\n")
epochs <- define_epochs()
print(epochs)
cat("\n")

# Test 2: Extended epochs (both)
cat("Test 2: Extended epochs (extend = TRUE)\n")
extended <- define_epochs(extend = TRUE)
print(extended)
cat("\n")

# Test 3: Extended epochs (before only)
cat("Test 3: Extended before only\n")
before <- define_epochs(extend = "before")
print(before)
cat("\n")

# Test 4: Extended epochs (after only)
cat("Test 4: Extended after only\n")
after <- define_epochs(extend = "after")
print(after)
cat("\n")

# Test 5: Custom epochs
cat("Test 5: Custom epochs\n")
custom <- define_epochs(
  breaks = c(1600, 1750, 1900, 2000),
  labels = c("Early Modern", "Enlightenment", "Industrial"),
  descriptions = c(
    "Early modern period",
    "Age of Enlightenment",
    "Industrial revolution"
  ),
  style = "custom"
)
print(custom)
cat("\n")

# Test 6: epoch_boundaries()
cat("Test 6: epoch_boundaries()\n")
bounds <- epoch_boundaries(epochs)
print(bounds)
cat("\n")

bounds_extended <- epoch_boundaries(extended)
cat("Extended boundaries:", bounds_extended, "\n\n")

# Test 7: get_epoch()
cat("Test 7: get_epoch()\n")
test_years <- c(1550, 1650, 1850, 1975, 2000)
for (y in test_years) {
  ep <- get_epoch(y, epochs)
  cat(sprintf("Year %d is in epoch: %s\n", y, ep))
}
cat("\n")

# Test 8: get_epoch() with multiple years
cat("Test 8: get_epoch() with vector\n")
years <- c(1550, 1700, 1825, 1900, 1975, 1999, 2000)
epoch_labels <- get_epoch(years, epochs)
epoch_ids <- get_epoch(years, epochs, label = FALSE)
result <- data.frame(
  year = years,
  epoch_id = epoch_ids,
  epoch_label = epoch_labels
)
print(result)
cat("\n")

# Test 9: Years outside range
cat("Test 9: Years outside epoch range\n")
out_of_range <- c(1400, 1500, 1850, 2000, 2025)
result2 <- data.frame(
  year = out_of_range,
  epoch = get_epoch(out_of_range, epochs)
)
print(result2)
cat("\n")

# Test 10: Error handling - wrong number of labels
cat("Test 10: Error handling - wrong number of labels\n")
tryCatch({
  bad <- define_epochs(
    breaks = c(1600, 1700, 1800),
    labels = c("Early"),  # Wrong: 3 breaks need 2 labels, not 1
    style = "custom"
  )
}, error = function(e) {
  cat("Expected error:", conditionMessage(e), "\n")
})
cat("\n")

# Test 11: Error handling - unsorted breaks
cat("Test 11: Error handling - unsorted breaks\n")
tryCatch({
  bad <- define_epochs(
    breaks = c(1600, 1800, 1700),
    labels = c("Early", "Late"),
    style = "custom"
  )
}, error = function(e) {
  cat("Expected error:", conditionMessage(e), "\n")
})
cat("\n")

# Test 12: Check data structure
cat("Test 12: Data structure validation\n")
cat("Class:", class(epochs), "\n")
cat("Column names:", names(epochs), "\n")
cat("Dimensions:", nrow(epochs), "rows x", ncol(epochs), "cols\n")
cat("\n")

# Test 13: Midpoint calculation
cat("Test 13: Verify midpoint calculation\n")
manual_midpoint <- (epochs$start[1] + epochs$end[1]) / 2
cat(sprintf("First epoch: start=%d, end=%d, midpoint=%g (expected %g)\n",
            epochs$start[1], epochs$end[1], epochs$midpoint[1], manual_midpoint))
stopifnot(epochs$midpoint[1] == manual_midpoint)
cat("OK\n\n")

# Test 14: epoch_boundaries() error handling
cat("Test 14: epoch_boundaries() with non-epoch object\n")
tryCatch({
  bad <- epoch_boundaries(data.frame(x = 1:10))
}, error = function(e) {
  cat("Expected error:", conditionMessage(e), "\n")
})
cat("\n")

# Test 15: Extended epochs with very early dates (BC)
cat("Test 15: Extended epochs with very early dates\n")
extended_both <- define_epochs(extend = TRUE)
early_years <- c(-6200, -1000, 1500, 2000, 2026)
early_epochs <- get_epoch(early_years, extended_both)
result3 <- data.frame(
  year = early_years,
  epoch = early_epochs
)
print(result3)
cat("\n")

# Test 16: Verify boundaries exclude -Inf
cat("Test 16: Verify epoch_boundaries() excludes -Inf\n")
boundaries_ext <- epoch_boundaries(extended_both)
cat("Boundaries:", boundaries_ext, "\n")
cat("Should NOT include -Inf\n")
stopifnot(!any(is.infinite(boundaries_ext)))
cat("OK - all boundaries are finite\n\n")

cat("=== All tests completed ===\n")

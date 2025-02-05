# CRAN resubmission

This is the second resubmission, addressing the ClonEvol dependency.

## Changes since last submission

1. Added 'clonevol' to the Suggests field in DESCRIPTION.
2. Added instructions for installing 'clonevol' in the Description field.
3. Wrapped the 'clonevol' example in `if (requireNamespace("clonevol", quietly = TRUE)) { ... }` to avoid errors when the package is not installed and to allow executing the example when the package is installed.

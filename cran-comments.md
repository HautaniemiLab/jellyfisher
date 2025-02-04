# CRAN resubmission

This is a resubmission.

## Changes since last submission

1. Removed single quotes around Jellyfish in the Title and Descrtiption in DESCRIPTION
2. Added a reference to Lahtinen et al. (2023) in DESCRIPTION
3. Added return value to `jellyfisher-shiny` functions

### Handling clonevol dependency in the example with `\dontrun`

The `extract_tables_from_clonevol` function provides additional functionality to
users of the 'clonevol' package. This function itself does not depend on 'clonevol',
but the example does.

Since 'clonevol' is not available on CRAN or Bioconductor and must be installed
directly from GitHub (https://github.com/hdng/clonevol), it cannot be in the
`Imports` or `Suggests` fields of the DESCRIPTION file. Because of this, I've
marked the example in `extract_tables_from_clonevol` with `\dontrun` to avoid
errors during checks.

`\donttest` appears to not work here, as examples with this tag are still run
during checks.

Conditional execution via `if(require("clonevol"))` is not possible either, as
it would require 'clonevol' to be in the `Suggests` field of the DESCRIPTION
file or the check fails.

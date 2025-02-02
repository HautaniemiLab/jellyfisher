## R CMD check results

0 errors | 0 warnings | 1 note

- This is a new release.

### Notes

#### Time check

```
❯ checking for future file timestamps ... NOTE
  unable to verify current time
```

If I've understood correctly, this check uses an external service to verify
something, and it's probably unavailable now. I think I cannot do anything about
this.

## Other

### dontrun in `extract_tables_from_clonevol`

This function depends on the `clonevol` package, which is not on CRAN. I've
marked the example in `extract_tables_from_clonevol` with `\dontrun` to avoid
errors during checks.

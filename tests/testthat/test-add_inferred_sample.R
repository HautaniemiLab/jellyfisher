library(testthat)
library(jellyfisher)

test_that("add_inferred_sample preserves NA ranks when rank column is all NA", {
  data("jellyfisher_example_tables", package = "jellyfisher")

  foo <- jellyfisher_example_tables |> select_patients("EOC948")

  # make the rank column present but entirely NA
  foo$samples$rank <- NA_real_

  res <- foo |> 
    add_inferred_sample("EOC948_Inf",
                        NULL,
                        samples = c("EOC948_iOvaR1_DNA1", "EOC948_iAdnL1_DNA1"))

  expect_true("rank" %in% colnames(res$samples))
  expect_true(all(is.na(res$samples$rank)))
})

test_that("add_inferred_sample sets parent, rank and patient for EOC153 example", {
  data("jellyfisher_example_tables", package = "jellyfisher")

  res <- jellyfisher_example_tables |>
    select_patients("EOC153") |>
    add_inferred_sample("EOC153_Inf",
                        2,
                        c("EOC153_iPer1_DNA4",
                          "EOC153_iOme1_DNA4",
                          "EOC153_iOvaR1_DNA1"))

  samples_df <- res$samples

  # Check that the inferred sample exists with correct patient and rank
  expect_true("EOC153_Inf" %in% samples_df$sample)
  inf_row <- samples_df[samples_df$sample == "EOC153_Inf", ]
  expect_equal(as.numeric(inf_row$rank), 2)
  expect_equal(as.character(inf_row$patient), "EOC153")

  # Check that the three target samples have parent set to the inferred sample
  targets <- c("EOC153_iPer1_DNA4", "EOC153_iOme1_DNA4", "EOC153_iOvaR1_DNA1")
  for (t in targets) {
    row <- samples_df[samples_df$sample == t, ]
    expect_equal(as.character(row$parent), "EOC153_Inf")
  }
})

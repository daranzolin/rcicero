context("get_upcoming_elections")

test_that("returns the correct", {

  a <- get_upcoming_elections(is_state = TRUE, elections = 2)
  b <- get_upcoming_elections(is_national = TRUE, elections = 5)

  # classes
  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")

  # columns
  expect_equal(names(a)[1], "election_label")
  expect_equal(names(b)[1], "election_label")

})

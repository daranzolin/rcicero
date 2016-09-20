context("get_legislative_district")

test_that("returns the correct", {

  a <- get_legislative_district(search_loc = "3175 Bowers Ave. Santa Clara, CA")
  b <- get_legislative_district(lat = 40, lon = -75.1)

  # classes
  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")

  # columns
  expect_equal(names(a)[5], "district_type")
  expect_equal(names(b)[1], "district_type")

  # values
  expect_equal(unique(a$state)[1], "CA")
  expect_equal(unique(b$state)[2], "PA")

})

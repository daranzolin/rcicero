context("get_nonlegislative_district")

test_that("returns the correct", {

  a <- get_nonlegislative_district(search_loc = "3175 Bowers Ave. Santa Clara, CA", type = "SCHOOL")
  b <- get_nonlegislative_district(lat = 40, lon = -75.1)

  # classes
  expect_is(a, "tbl_df")
  expect_is(b, "tbl_df")

  # columns
  expect_equal(names(a)[1], "address")
  expect_equal(names(b)[1], "district_type")

  # values
  expect_equal(unique(a$district_type), "SCHOOL")
  expect_equal(unique(b$district_type), "SCHOOL")

})

context("get_official")

test_that("returns the correct", {

  a <- get_official(lat = 40, lon = -75.1)
  b <- get_official(last_name = "Obama")

  # classes
  expect_is(a, "list")
  expect_is(a$gen_info, "tbl_df")
  expect_is(b, "list")
  expect_is(b$gen_info, "tbl_df")

  # columns
  expect_equal(names(a$gen_info)[1], "match_postal")
  expect_equal(names(b$gen_info)[1], "match_postal")

})

test_that("vectorizing works", {

  c <- get_official(search_loc = "3175 Bowers Ave. Santa Clara, CA", district_type = c("STATE_LOWER", "STATE_UPPER"))
  expect_is(c, "list")
  expect_is(c$gen_info, "tbl_df")
  expect_equal(unique(c$district_info$district_type), c("STATE_LOWER", "STATE_UPPER"))

})

context("Making an API call to get elected official data")

test_that("get_official returns data_frame", {
  x <- "3175 Bowers Ave. Santa Clara, CA"
  y <- c("")
  expect_identical(fbind(x, y), z)
  expect_identical(fbind(x_fact, y), z)
})

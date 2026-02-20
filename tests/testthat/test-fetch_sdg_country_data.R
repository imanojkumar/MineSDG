test_that("fetch returns data.table", {
  skip_on_cran()
  dt <- fetch_sdg_country_data(
    indicator = "15.3.1",
    country = "IND",
    year_range = c(2015, 2020)
  )

  expect_s3_class(dt, "data.table")
})

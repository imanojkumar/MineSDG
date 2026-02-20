test_that("fetch returns data.table", {
  skip_on_cran()
  dt <- fetch_sdg_country_data(
    indicator = "15.3.1",
    country = "IND",
    year_range = c(2015, 2020)
  )

  expect_s3_class(dt, "data.table")
})

test_that("invalid indicator stops execution", {
  skip_on_cran()
  expect_error(
    fetch_sdg_country_data(
      indicator = "15.3.X",
      country = "IND"
    )
  )
})

test_that("save option creates files", {
  skip_on_cran()

  temp_dir <- tempdir()

  dt <- fetch_sdg_country_data(
    indicator = "15.3.1",
    country = "IND",
    year_range = c(2015, 2015),
    save = TRUE,
    save_path = temp_dir
  )

  files <- list.files(temp_dir)

  expect_true(any(grepl("\\.csv$", files)))
  expect_true(any(grepl("\\.rds$", files)))
})


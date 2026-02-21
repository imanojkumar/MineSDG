# Fetch Country-Level SDG Data from UN SDG API

Retrieves Sustainable Development Goal (SDG) indicator data from the
official United Nations SDG API.

## Usage

``` r
fetch_sdg_country_data(
  goal = NULL,
  indicator = NULL,
  country = NULL,
  year_range = NULL,
  save = FALSE,
  save_path = "./data/sdg_downloads/",
  formats = c("csv", "rds")
)
```

## Arguments

- goal:

  Numeric (1-17). Optional SDG goal number.

- indicator:

  Character. SDG indicator code (e.g., "15.3.1").

- country:

  Character. ISO3 country code (e.g., "IND", "AUS").

- year_range:

  Numeric vector of length 2 (start_year, end_year).

- save:

  Logical. If TRUE, saves data to disk. Default FALSE.

- save_path:

  Character. Directory path for saving data. Default:
  "./data/sdg_downloads/".

- formats:

  Character vector. Any combination of "csv", "rds". Default c("csv",
  "rds").

## Value

A data.table containing SDG indicator data.

## Details

At least one of `goal` or `indicator` must be provided.

- If `indicator` is supplied → fetch that specific indicator.

- If only `goal` is supplied → fetch all indicators under that goal.

- If both are supplied → consistency is validated.

`country` and `year_range` act as filters.

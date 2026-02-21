# Summarize SDG Indicator Data

Generates descriptive statistics and data quality diagnostics for SDG
indicator datasets retrieved via
[`fetch_sdg_country_data()`](https://imanojkumar.github.io/MineSDG/reference/fetch_sdg_country_data.md).

## Usage

``` r
summarize_sdg_data(data, group_by = NULL, na.rm = TRUE)
```

## Arguments

- data:

  A data.table returned by
  [`fetch_sdg_country_data()`](https://imanojkumar.github.io/MineSDG/reference/fetch_sdg_country_data.md).

- group_by:

  Character vector of column names to group by. Allowed values:
  "indicator", "country", "year". Default NULL (overall summary).

- na.rm:

  Logical. Remove NA values when computing statistics. Default TRUE.

## Value

A data.table containing summary statistics.

## Details

Supports optional grouping by indicator, country, year, or combinations.

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- fetch_sdg_country_data(indicator = "15.3.1", country = "IND")
summarize_sdg_data(dt)
summarize_sdg_data(dt, group_by = "year")
summarize_sdg_data(dt, group_by = c("indicator", "country"))
} # }
```

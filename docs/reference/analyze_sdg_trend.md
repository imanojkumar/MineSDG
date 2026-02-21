# Analyze SDG Indicator Trend

Computes trend metrics for SDG indicator data including absolute change,
percentage change, CAGR, and linear trend slope.

## Usage

``` r
analyze_sdg_trend(data, group_by = c("indicator", "country"), min_points = 3)
```

## Arguments

- data:

  A data.table returned by fetch_sdg_country_data().

- group_by:

  Character vector of grouping columns. Default c("indicator",
  "country").

- min_points:

  Minimum number of time points required to compute trend. Default 3.

## Value

A data.table containing trend statistics.

## Details

Supports grouping by indicator, country, or combinations.

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- fetch_sdg_country_data(indicator = "15.3.1", country = "IND")
analyze_sdg_trend(dt)
} # }
```

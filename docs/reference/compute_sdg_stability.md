# Compute SDG Stability Metrics

Calculates variability and stability statistics for SDG indicator data.

## Usage

``` r
compute_sdg_stability(data, group_by = c("indicator", "country"))
```

## Arguments

- data:

  A data.table returned by fetch_sdg_country_data().

- group_by:

  Character vector of grouping columns.

## Value

A data.table containing stability metrics.

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- fetch_sdg_country_data(indicator = "15.3.1", country = "IND")
compute_sdg_stability(dt)
} # }
```

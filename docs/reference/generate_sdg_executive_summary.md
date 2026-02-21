# Generate Executive Summary for SDG Performance

Creates an executive-ready narrative summary based on SDG trend analysis
and optional benchmark comparison.

## Usage

``` r
generate_sdg_executive_summary(trend_data, benchmark_data = NULL, digits = 2)
```

## Arguments

- trend_data:

  Output from analyze_sdg_trend().

- benchmark_data:

  Optional output from benchmark_sdg_performance().

- digits:

  Number of digits for rounding values. Default 2.

## Value

Character vector containing executive summary text.

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- fetch_sdg_country_data(indicator = "15.3.1", country = "IND")
trend <- analyze_sdg_trend(dt)
summary_text <- generate_sdg_executive_summary(trend)
cat(summary_text)
} # }
```

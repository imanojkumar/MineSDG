# Benchmark SDG Performance

Compares SDG indicator performance against a benchmark (global mean or
user-supplied dataset).

## Usage

``` r
benchmark_sdg_performance(
  data,
  benchmark_data = NULL,
  year = NULL,
  higher_is_better = TRUE
)
```

## Arguments

- data:

  A data.table returned by fetch_sdg_country_data().

- benchmark_data:

  Optional data.table with columns: indicator, year, value. If NULL,
  benchmark is computed as mean of provided data.

- year:

  Optional numeric year. If NULL, most recent year is used.

- higher_is_better:

  Logical. TRUE if higher values indicate better performance. Default
  TRUE.

## Value

A data.table with benchmark comparison statistics.

## Examples

``` r
if (FALSE) { # \dontrun{
dt <- fetch_sdg_country_data(goal = 15)
benchmark_sdg_performance(dt)
} # }
```

# Analyze SDG Convergence

Tests beta-convergence across countries for an SDG indicator.

## Usage

``` r
analyze_sdg_convergence(data, base_year = NULL, final_year = NULL)
```

## Arguments

- data:

  A data.table returned by fetch_sdg_country_data().

- base_year:

  Optional base year. If NULL, earliest year is used.

- final_year:

  Optional final year. If NULL, latest year is used.

## Value

A data.table with convergence statistics per indicator.

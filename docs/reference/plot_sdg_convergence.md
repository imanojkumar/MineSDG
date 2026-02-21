# Plot SDG Convergence

Creates a convergence scatter plot showing initial value vs growth rate.

## Usage

``` r
plot_sdg_convergence(data, base_year = NULL, final_year = NULL)
```

## Arguments

- data:

  A data.table returned by fetch_sdg_country_data().

- base_year:

  Optional base year. If NULL, earliest year is used.

- final_year:

  Optional final year. If NULL, latest year is used.

## Value

A ggplot object.

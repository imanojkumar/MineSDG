# Plot SDG Indicator Trend

Creates a publication-ready time-series plot for SDG indicator data.

## Usage

``` r
plot_sdg_trend(data, indicator = NULL, country = NULL)
```

## Arguments

- data:

  A data.table returned by fetch_sdg_country_data().

- indicator:

  Optional indicator code to filter.

- country:

  Optional ISO3 country code to filter.

## Value

A ggplot object.

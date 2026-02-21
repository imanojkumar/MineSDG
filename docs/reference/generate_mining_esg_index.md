# Generate Composite Mining ESG Index

Builds a composite Mining ESG Risk Index by aggregating multiple SDG
indicators using flexible weighting schemes.

## Usage

``` r
generate_mining_esg_index(
  data,
  indicators,
  weighting_method = "equal",
  custom_weights = NULL
)
```

## Arguments

- data:

  data.table returned by fetch_sdg_country_data().

- indicators:

  Character vector of SDG indicator codes.

- weighting_method:

  Character. One of: "equal", "domain_weighted", "custom".

- custom_weights:

  Named numeric vector of weights (required if weighting_method =
  "custom").

## Value

A data.table containing:

- country:

  Country ISO3

- composite_score:

  Aggregated ESG risk score

- risk_category:

  Overall risk classification

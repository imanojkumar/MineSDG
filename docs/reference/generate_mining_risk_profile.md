# Generate Mining SDG Risk Profile

Integrates SDG trend, stability, benchmarking, and mining-sector
relevance to produce a structured ESG risk assessment.

## Usage

``` r
generate_mining_risk_profile(data, indicator)
```

## Arguments

- data:

  data.table returned from fetch_sdg_country_data()

- indicator:

  Character. SDG indicator code.

## Value

A structured list containing:

- indicator:

  SDG indicator

- domain:

  Mining domain

- risk_score:

  Numeric weighted risk score

- risk_category:

  Risk classification

- executive_summary:

  Narrative explanation

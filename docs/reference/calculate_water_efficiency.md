# Calculate Water Use Efficiency (SDG 6.4)

Computes water use efficiency and recycling rates in alignment with
Global Reporting Initiative (GRI 303) standards and SDG Target 6.4.

## Usage

``` r
calculate_water_efficiency(withdrawal_m3, discharge_m3, recycled_m3)
```

## Arguments

- withdrawal_m3:

  Numeric. Total water withdrawn from all sources (in cubic meters).
  Must be a non-negative number.

- discharge_m3:

  Numeric. Total water discharged to all destinations (in cubic meters).
  Must be a non-negative number.

- recycled_m3:

  Numeric. Total water recycled or reused (in cubic meters). Must be a
  non-negative number.

## Value

A named list containing:

- metric:

  Character string. "SDG 6.4 - Water Efficiency"

- net_consumption_m3:

  Numeric. Net water consumed (Withdrawal - Discharge).

- recycling_rate_percent:

  Numeric. Percentage of total water use that is recycled, rounded to 2
  decimal places.

## Details

The function calculates the "Recycling Rate" as: \$\$(recycled\\m3 /
(withdrawal\\m3 + recycled\\m3)) \* 100\$\$

And "Net Water Consumption" (GRI 303-5) as: \$\$withdrawal\\m3 -
discharge\\m3\$\$

## Examples

``` r
# Standard mining operation example
calculate_water_efficiency(
  withdrawal_m3 = 50000,
  discharge_m3 = 10000,
  recycled_m3 = 20000
)
#> $metric
#> [1] "SDG 6.4 - Water Efficiency"
#> 
#> $net_consumption_m3
#> [1] 40000
#> 
#> $recycling_rate_percent
#> [1] 28.57
#> 

# Zero discharge example (Closed loop)
calculate_water_efficiency(1000, 0, 500)
#> $metric
#> [1] "SDG 6.4 - Water Efficiency"
#> 
#> $net_consumption_m3
#> [1] 1000
#> 
#> $recycling_rate_percent
#> [1] 33.33
#> 

# Edge case: No water used
calculate_water_efficiency(0, 0, 0)
#> $metric
#> [1] "SDG 6.4 - Water Efficiency"
#> 
#> $net_consumption_m3
#> [1] 0
#> 
#> $recycling_rate_percent
#> [1] 0
#> 
```

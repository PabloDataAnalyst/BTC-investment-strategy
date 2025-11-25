############################################################
# INVESTMENT STRATEGY ANALYSIS — KPI CALCULATION SCRIPT
# Author: Pablo Martínez
# Description:
#   - Load & process backtest data
#   - Build equity curve
#   - Compute performance, risk & stability KPIs
#   - Add advanced quantitative metrics
#   - Benchmark vs major indices
#   - Export results for reporting (Excel / Power BI)
#
# Data Pipeline:
#   Backtest CSV → R script → KPIs → Monte Carlo → Export CSV → Power BI Dashboard
#   Yahoo Finance (getSymbols) → Benchmark KPIs
############################################################


##############################
# 1. LOAD LIBRARIES
##############################

library(tidyverse)
library(janitor)
library(lubridate)
library(TTR)
library(zoo)        # for rollapply
library(moments)    # for skewness & kurtosis
library(quantmod)   # for benchmark assets


##############################
# 2. IMPORT & CLEAN DATA
##############################

strategy_results <- read.csv(
  "data/data.csv",
  sep = ";"
)

strategy_results <- strategy_results |>
  clean_names() |>
  rename(return_pct = return_pct_risk) |>
  mutate(date = as.Date(date, format = "%d/%m/%Y"))


##############################
# 3. EQUITY CURVE & DRAWDOWNS
##############################

strategy_results <- strategy_results |>
  mutate(
    equity = cumprod(iv),
    high_watermark = cummax(equity),
    drawdown = (equity - high_watermark) / high_watermark
  )

calculative_return <- last(strategy_results$equity) - 1
max_drawdown <- min(strategy_results$drawdown)


##############################
# 4. CORE KPIs
##############################

total_trades <- nrow(strategy_results)

win_rate <- strategy_results |>
  summarise(rate = mean(return_pct > 0)) |>
  pull(rate)

avg_win <- strategy_results |>
  filter(return_pct > 0) |>
  summarise(val = mean(return_pct)) |>
  pull()

avg_loss <- strategy_results |>
  filter(return_pct < 0) |>
  summarise(val = mean(return_pct)) |>
  pull()

profit_factor <- sum(strategy_results$return_pct[strategy_results$return_pct > 0]) /
  abs(sum(strategy_results$return_pct[strategy_results$return_pct < 0]))

expectancy <- win_rate * avg_win + (1 - win_rate) * avg_loss

volatility_d <- sd(strategy_results$return_pct)
volatility_annualized <- volatility_d * sqrt(365)

sharpe_daily <- mean(strategy_results$return_pct) / sd(strategy_results$return_pct)
sharpe_annualized <- sharpe_daily * sqrt(365)

downside_returns <- strategy_results$return_pct[strategy_results$return_pct < 0]
sortino_daily <- mean(strategy_results$return_pct) / sd(downside_returns)
sortino_annualized <- sortino_daily * sqrt(365)

largest_win <- max(strategy_results$return_pct)
largest_loss <- min(strategy_results$return_pct)


##############################
# 5. BEHAVIOR KPIs
##############################

strategy_results <- strategy_results |>
  mutate(loss = return_pct < 0)

rle_loss <- rle(strategy_results$loss)
longest_losing_streak <- max(rle_loss$lengths[rle_loss$values == TRUE])

mean_stoploss <- mean(strategy_results$stop_loss_pct)


##############################
# 6. ADVANCED RISK METRICS
##############################

# Calmar Ratio
annualized_return <- calculative_return
calmar_ratio <- annualized_return / abs(max_drawdown)

# Ulcer Index
dd_positive <- -strategy_results$drawdown[strategy_results$drawdown < 0]
ulcer_index <- sqrt(mean(dd_positive^2))

# Ulcer Performance Index (UPI)
risk_free <- 0
ulcer_performance_index <- (annualized_return - risk_free) / ulcer_index

# CAGR
initial_equity <- 1
final_equity   <- last(strategy_results$equity)

years_total <- 1

cagr <- (final_equity / initial_equity)^(1 / years_total) - 1


##############################
# 7. SUMMARY KPI TABLE
##############################

kpis_df <- tibble(
  total_trades            = total_trades,
  win_rate                = win_rate,
  avg_win                 = avg_win,
  avg_loss                = avg_loss,
  profit_factor           = profit_factor,
  expectancy              = expectancy,
  total_return            = calculative_return,
  cagr                    = cagr,
  max_drawdown            = max_drawdown,
  volatility_daily        = volatility_d,
  volatility_annualized   = volatility_annualized,
  sharpe_daily            = sharpe_daily,
  sharpe_annualized       = sharpe_annualized,
  sortino_daily           = sortino_daily,
  sortino_annualized      = sortino_annualized,
  largest_win             = largest_win,
  largest_loss            = largest_loss,
  longest_losing_streak   = longest_losing_streak,
  mean_stoploss           = mean_stoploss,
  calmar_ratio            = calmar_ratio,
  ulcer_index             = ulcer_index,
  ulcer_performance_index = ulcer_performance_index
)

print(kpis_df)


##############################
# 8. EXPORT CORE RESULTS
##############################

write.csv(kpis_df, "kpis.csv", row.names = FALSE, quote = FALSE)


##############################
# 9. ADVANCED QUANT METRICS
##############################

# Rolling windows
rolling_window <- 30

strategy_results <- strategy_results |>
  arrange(date) |>
  mutate(
    roll_vol = rollapply(return_pct, rolling_window, sd, fill = NA, align = "right"),
    roll_sharpe = rollapply(return_pct, rolling_window,
                            function(x) mean(x) / sd(x), fill = NA, align = "right"),
    roll_dd = rollapply(drawdown, rolling_window, min, fill = NA, align = "right")
  )

# Higher moments
skewness_ret <- skewness(strategy_results$return_pct)
kurtosis_ret <- kurtosis(strategy_results$return_pct)

# Autocorrelation
acf_1 <- acf(strategy_results$return_pct, plot = FALSE)$acf[2]

# Monte Carlo Stress Test
set.seed(123)
mc_runs <- 5000
n <- nrow(strategy_results)

sim_results <- replicate(mc_runs, {
  sim <- sample(strategy_results$iv, n, replace = TRUE)
  prod(sim) - 1
})

mc_5pct <- quantile(sim_results, 0.05)
mc_1pct <- quantile(sim_results, 0.01)
mc_median <- median(sim_results)

##############################
# 10. BENCHMARK DATA & KPIs
##############################

# Symbols: S&P500, NASDAQ100, MSCI WORLD (URTH), BTC
symbols <- c("^GSPC", "^NDX", "URTH", "BTC-USD")

start_date <- as.Date("2021-11-15")
end_date   <- as.Date("2022-11-15")

# Download
getSymbols(symbols, from = start_date, to = end_date, auto.assign = TRUE)

# Convert each symbol to tidy format
to_tibble <- function(symbol_xts, colname){
  tibble(
    date = as.Date(index(symbol_xts)),
    price = as.numeric(Cl(symbol_xts))
  ) |> rename(!!colname := price)
}

sp500_df  <- to_tibble(`GSPC`, "sp500")
nasdaq_df <- to_tibble(`NDX`,  "nasdaq")
msci_df   <- to_tibble(URTH,    "msci_world")
btc_df    <- to_tibble(`BTC-USD`, "btc")

# Merge all series by date
benchmark_prices <- sp500_df |>
  full_join(nasdaq_df, by = "date") |>
  full_join(msci_df, by = "date") |>
  full_join(btc_df, by = "date") |>
  arrange(date)

# Keep only dates in strategy sample
benchmark_prices <- benchmark_prices |>
  filter(date >= start_date, date <= end_date)

# Compute daily returns
benchmark_returns <- benchmark_prices |>
  arrange(date) |>
  mutate(
    ret_sp500 = sp500 / lag(sp500) - 1,
    ret_nasdaq = nasdaq / lag(nasdaq) - 1,
    ret_msci = msci_world / lag(msci_world) - 1,
    ret_btc = btc / lag(btc) - 1
  ) |>
  drop_na()

# Equity curves
benchmark_equity <- benchmark_returns |>
  mutate(
    eq_sp500 = cumprod(1 + ret_sp500),
    eq_nasdaq = cumprod(1 + ret_nasdaq),
    eq_msci = cumprod(1 + ret_msci),
    eq_btc = cumprod(1 + ret_btc)
  )

# KPI function
calc_kpis <- function(ret){
  eq <- cumprod(1 + ret)
  tibble(
    return = last(eq) - 1,
    sharpe = mean(ret) / sd(ret) * sqrt(365),
    volatility = sd(ret) * sqrt(365),
    max_dd = min((eq - cummax(eq)) / cummax(eq))
  )
}

# Compute benchmark KPIs
kpi_sp500  <- calc_kpis(benchmark_returns$ret_sp500)
kpi_nasdaq <- calc_kpis(benchmark_returns$ret_nasdaq)
kpi_msci   <- calc_kpis(benchmark_returns$ret_msci)
kpi_btc    <- calc_kpis(benchmark_returns$ret_btc)  # BUY & HOLD

benchmark_kpis <- bind_rows(
  mutate(kpi_sp500,  asset = "S&P500"),
  mutate(kpi_nasdaq, asset = "NASDAQ100"),
  mutate(kpi_msci,   asset = "MSCI WORLD"),
  mutate(kpi_btc,    asset = "BTC (Buy & Hold)")
) |>
  select(asset, everything())

print(benchmark_kpis)

# Export KPIs
write.csv(benchmark_kpis, "benchmark_kpis.csv", row.names = FALSE)

##############################
# 11. EXPORT STRATEGY & BENCHMARK EQUITY FOR POWER BI
##############################

# Create vector with all dates from the period analyzed
all_dates <- tibble(date = seq(as.Date("2021-11-15"), as.Date("2022-11-15"), by="day"))

# Trading strategy
strategy_eq <- strategy_results %>%
  select(date, equity) %>%
  right_join(all_dates, by="date") %>%
  arrange(date) %>%
  fill(equity, .direction = "down")  # rellena con último valor conocido

write.csv(strategy_eq, "strategy_eq_full.csv", row.names = FALSE)

# BTC (benchmark)
btc_eq <- benchmark_equity %>%
  select(date, eq_btc) %>%
  right_join(all_dates, by="date") %>%
  arrange(date) %>%
  fill(eq_btc, .direction = "down")  # rellena con último valor conocido

write.csv(btc_eq, "btc_eq_full.csv", row.names = FALSE)

# Export complete strategy results table
write.csv(strategy_results, "strategy_results_full.csv", row.names = FALSE)

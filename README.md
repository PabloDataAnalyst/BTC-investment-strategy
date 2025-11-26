# 📈 BTC Investment Strategy — Risk, Performance & Benchmark Analysis

**Created:** 2025\
**Last updated:** 25/11/2025

------------------------------------------------------------------------

## 🖼️ Preview

![Dashboard Preview](dashboards/Dashboard.png)

**Dashboard Files:**

-   [Download `.pbix` file](dashboards/Dashboard.pbix)

------------------------------------------------------------------------

## 🎯 Goal

Evaluate how a Bitcoin investment strategy based on trends performs under real market conditions, using a clear and professional analytics workflow.

This project aims to:

-   Measure the strategy’s **returns, stability, and risk profile**.
-   Compare it against **Bitcoin buy-and-hold** and **global equities**.
-   Analyze **drawdowns, volatility**, and **rolling performance**.
-   Test robustness through **Monte Carlo simulations**.
-   Present insights in an **executive-friendly Power BI dashboard**.

------------------------------------------------------------------------

## 📊 Results

-   The strategy achieves a **better risk–return profile** than BTC buy & hold in the period analyzed, especially during **clear trending moments**.
-   Performance **weakens in sideways periods**, showing lower operational efficiency.
-   Drawdown analysis indicates a **controlled downside** relative to the asset’s high volatility.
-   The equity curve shows **consistent behavior**, though sensitive to market structure.
-   **Monte Carlo stress testing** shows a 5% worst-case annual return of **–2.6%**, and a 1% extreme tail of **–20.1%**, indicating controlled downside risk under the fixed 5% risk-per-trade rule.

📌 The focus of this project is to demonstrate a **professional quantitative analysis workflow**, not to validate the strategy as a commercial product.

------------------------------------------------------------------------

## ⚙️ Process

### 🔄 Pipeline Overview

Backtest CSV\
↓\
R Script (processing)\
↓\
KPIs & Risk Metrics\
↓\
Monte Carlo Stress Test\
↓\
Export CSV Outputs\
↓\
Power BI Dashboard

**Benchmarks:**

Yahoo Finance Data\
↓\
Benchmark KPIs\
↓\
Power BI

------------------------------------------------------------------------

### 1. Data Sources

**Backtest CSV (own data)**

-   Real dataset generated from the strategy.
-   Includes: trade id, type of operation, stoploss pct, date, returns, iv(variation index, used for equity curve calculation and Monte Carlo Stress Test).
-   For **educational/analytical use only**.

**Yahoo Finance – Benchmarks**

-   BTC-USD
-   Additional Benchmark Data (not displayed in dashboard):
-   Downloaded S&P500, NASDAQ100, MSCI World from Yahoo Finance
-   Used for KPI comparison and internal validation of methodology

------------------------------------------------------------------------

### 2. Processing Pipeline (R)

**Data Loading & Cleaning**

-   Date normalization
-   NA cleaning
-   Standardization of return formats
-   Temporal alignment across datasets

**Equity Curve Construction**

-   Daily return
-   Cumulative product
-   High watermark
-   Drawdown & Max Drawdown

**Performance KPIs**

-   Total Return
-   CAGR
-   Annualized volatility
-   Sharpe & Sortino
-   Profit Factor
-   Recovery ratio

**Risk Metrics**

-   Max Drawdown
-   Ulcer Index
-   Ulcer Performance Index (UPI)
-   Winning / losing streaks
-   Volatility clustering

**Rolling Metrics (key for senior level)**

-   Rolling Sharpe
-   Rolling volatility
-   Rolling drawdown

**Monte Carlo Stress Test**

-   Resampling of `iv` returns
-   5000 simulated paths
-   Tail risk evaluation (1% and 5% quantiles)

**Benchmark Integration**

-   Base 100 equity curves
-   Equivalent KPIs for S&P500 / BTC
-   Direct equity curve comparison (only BTC used in dashboard)

------------------------------------------------------------------------

### 3. Output Layer

-   `kpis.csv`
-   `benchmark_kpis.csv`
-   `btc_eq_full.csv`
-   `strategy_eq_full.csv`
-   `strategy_results_full.csv`
-   Final export to Power BI

------------------------------------------------------------------------

## 🧰 Tools & Technologies

-   **R** → quantitative processing, KPIs, simulations
-   **Excel** → quick validations, ad hoc monthly calculations
-   **Power BI** (Power Query + DAX) → final modeling, executive visualization

------------------------------------------------------------------------

## 📉 Limitations

-   One-year analysis period, limited but sufficient to assess stability and methodology.
-   Does not include commissions, slippage, or execution costs.
-   Strategy has a low number of trades due to its conservative nature.
-   Dataset is specific → not generalizable to all market conditions.

------------------------------------------------------------------------

## 🚀 Next Steps

-   Incorporate commissions and slippage
-   Multi-period analysis (2020–2024)
-   Testing by market regimes (trending, sideways, high volatility)
-   Out-of-sample testing and walk-forward
-   Higher temporal granularity (4h / 1h)
-   Risk sensitivity testing (3% / 5% / 7%)

------------------------------------------------------------------------

## 📁 Project Files

-   [`code.R`](/code.R)
-   [`data.csv`](/data/data.csv)
-   [`Dashboard.pbix`](/dashboards/Dashboard.pbix)
-   [`Dashboard.png`](/dashboards/Dashboard.png)
-   [`kpis.csv`](/kpis/kpis.csv)
-   [`monthly_return.csv`](/data/monthly_return.csv)
-   [`benchmark_kpis.csv`](/kpis/benchmark_kpis.csv)
-   [`btc_eq_full.csv`](/equity/btc_eq_full.csv)
-   [`strategy_eq_full.csv`](/equity/strategy_eq_full.csv)
-   [`strategy_results_full.csv`](/data/strategy_results_full.csv)
-   [`dataset_dictionary.md`](/data/dataset_dictionary.md)

------------------------------------------------------------------------

**Author:** [Pablo](https://github.com/PabloDataAnalyst) © 2025 Published for portfolio purposes.\
**License:** MIT License
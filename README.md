# 📈 BTC Investment Strategy — Risk, Performance & Benchmark Analysis

**Created:** 2025  
**Last updated:** 22/11/2025  

Hybrid project aimed at consulting firms, senior Analytics teams, and recruiters.  
The strategy is trend-following, based on trendline breakouts, and managed with a fixed 5% risk per trade.

---

## 🎯 Goal

This project evaluates the performance, stability, and risk of a quantitative Bitcoin strategy, comparing it with global benchmarks.

The main objective is to demonstrate a professional quantitative analysis pipeline, including:

- Data engineering
- Advanced financial KPI calculation
- Rolling metrics
- Drawdown analysis
- Benchmarking
- Monte Carlo simulation
- Executive dashboard in Power BI  

➡️ The dashboard is in Spanish and designed for executive analysis.

---

## 🖼️ Preview

![Dashboard Preview](dashboards/Dashboard.png)

**Dashboard Files:**  
- [Download `.pbix` file](dashboards/Dashboard.pbix)

---

## 📊 Key Results

- The strategy achieves better risk-adjusted performance than BTC buy & hold in certain periods.  
- Shows more stable behavior in trending environments, deteriorating in sideways markets.  
- Risk analysis shows a controlled drawdown for a highly volatile asset.  
- Monte Carlo simulations confirm a manageable tail risk under a fixed 5% risk per trade.  

📌 This project emphasizes professional quantitative methodology rather than commercial validation.

---

## 🧱 Data & Methodology Architecture

The project follows a modular, reproducible architecture typical of senior teams.

### 1. Data Sources

**Backtest CSV (own data)**  
- Real dataset generated from the strategy.  
- Includes: date, returns, equity curve, signals, drawdowns.  
- For **educational/analytical use only**.

**Yahoo Finance – Benchmarks**  
- BTC-USD  
- Other global indices for comparative context.

---

### 2. Processing Pipeline (R)

**Data Loading & Cleaning**
- Date normalization
- NA cleaning
- Standardization of return formats
- Temporal alignment across datasets

**Equity Curve Construction**
- Daily return
- Cumulative product
- High watermark
- Drawdown & Max Drawdown

**Performance KPIs**
- Total Return
- CAGR
- Annualized volatility
- Sharpe & Sortino
- Profit Factor
- Recovery ratio

**Risk Metrics**
- Max Drawdown
- Ulcer Index
- Ulcer Performance Index (UPI)
- Winning / losing streaks
- Volatility clustering

**Rolling Metrics (key for senior level)**
- Rolling Sharpe
- Rolling volatility
- Rolling drawdown

**Monte Carlo Stress Test**
- Return resampling
- Simulated paths
- Extreme risk percentiles

**Benchmark Integration**
- Base 100
- Equivalent KPIs for S&P500 / BTC
- Direct equity curve comparison

---

### 3. Output Layer

- `strategy_results.csv`
- `benchmark_equity.csv`
- `kpis.csv`
- `montecarlo.csv`
- Final export to Power BI

---

## 🧰 Tools & Technologies

- **R** → quantitative processing, KPIs, simulations  
- **Excel** → quick validations, ad hoc monthly calculations  
- **Power BI** (Power Query + DAX) → final modeling, executive visualization  

---

## 📁 Dataset Dictionary

| Field                  | Description                                                                                                                                            |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| `trade_id`             | Unique identifier for the trade or operation.                                                                                                          |
| `type`                 | Type of trade (e.g., buy/sell or long/short depending on the strategy).                                                                                |
| `stop_loss_pct`        | Stop loss percentage set for the trade.                                                                                                                |
| `date`                 | Date when the trade was executed.                                                                                                                      |
| `return_pct_absolute`  | Absolute return of the trade (%), calculated as if **all available capital** had been used, without adjusting for fixed risk.                           |
| `return_pct_risk`      | Risk-adjusted return (%), standardized to a **5% risk per trade**, considering leverage and uniform position sizing.                                   |
| `iv`                   | Variation index used to calculate the strategy's cumulative return, reflecting the relative volatility of each trade.                                   |

---

## 📉 Limitations

- One-year analysis period, limited but sufficient to assess stability and methodology.  
- Does not include commissions, slippage, or execution costs.  
- Strategy has a low number of trades due to its conservative nature.  
- Dataset is specific → not generalizable to all market conditions.  

---

## 🚀 Next Steps

- Incorporate commissions and slippage  
- Multi-period analysis (2020–2024)  
- Testing by market regimes (trending, sideways, high volatility)  
- Out-of-sample testing and walk-forward  
- Higher temporal granularity (4h / 1h)  
- Risk sensitivity testing (3% / 5% / 7%)  

---

## 📁 Project Files

- `code.R`  
- `data.csv`  
- `Dashboard.pbix`  
- `Dashboard.png`  
- `kpis.csv`  
- `monthly_return`  
- `benchmark_kpis`  
- `btc_eq_full`  
- `strategy_eq_full`  
- `dataset_dictionary.md`  

---

**Author:** [Pablo](https://github.com/PabloDataAnalyst) © 2025 Published for portfolio purposes.  
**License:** MIT License
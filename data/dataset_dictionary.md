# 📁 Dataset Dictionary

| Field                  | Description                                                                                                                                            |
|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| `trade_id`             | Unique identifier for the trade or operation.                                                                                                          |
| `type`                 | Type of trade (e.g., buy/sell or long/short depending on the strategy).                                                                                |
| `stop_loss_pct`        | Stop loss percentage set for the trade.                                                                                                                |
| `date`                 | Date when the trade was executed.                                                                                                                      |
| `return_pct_absolute`  | Absolute return of the trade (%), calculated as if **all available capital** had been used, without adjusting for fixed risk.                           |
| `return_pct_risk`      | Risk-adjusted return (%), standardized to a **5% risk per trade**, considering leverage and uniform position sizing.                                   |
| `iv`                   | Variation index used to calculate the strategy's cumulative return, reflecting the relative volatility of each trade.                                   |

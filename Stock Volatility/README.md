## **What does the project do?**
This project analyzes and forecasts the realized volatility of a financial asset (Asset 12) using 1,500 daily observations from January 2010 to January 2016. It implements and compares six volatility models — AR, HAR, HAR-RS (with semi-volatility), HAR-RS-RK (with realized skewness and kurtosis), Realized GARCH, and ARMA-GARCH — evaluating them both in-sample (R², coefficient significance) and out-of-sample (MSE, MAE, Diebold-Mariano tests, Mincer-Zarnowitz regressions) under expanding and rolling window schemes. The analysis is written in R as a Jupyter Notebook.

## **Why the project is useful?**
It provides a practical, end-to-end framework for comparing realized volatility forecasting models - from data exploration and descriptive statistics through model estimation, diagnostic testing, and rigorous out-of-sample evaluation. It demonstrates how incorporating higher-frequency information (semi-volatility, skewness, kurtosis) improves forecasts over standard return-based GARCH models, which is relevant for risk management, portfolio allocation, and derivative pricing. The project also illustrates important econometric practices like Newey-West standard error correction, forecast efficiency testing, and formal model comparison via the Diebold-Mariano test.

## **How users can get started?**
Users need R with the following packages: xts, forecast, rugarch, lmtest, and sandwich. The dataset (12.RData) should be placed in a data_project/ subdirectory. The notebook can be run cell-by-cell in Jupyter with an R kernel (IRkernel), or the code can be extracted and run in RStudio. No additional configuration is needed; all model estimation, evaluation, and visualization is self-contained in the notebook.

## **Where users can get help?**
Users can open an issue on the GitHub repository for questions or bug reports. For methodological background, the notebook references key academic papers: Corsi (2009) on the HAR model, Hansen, Huang & Shek (2012) on Realized GARCH, Patton & Sheppard (2015) on signed jumps and semivariance decomposition, and Todorova (2017) on asymmetric volatility. The rugarch package documentation is also a useful resource for the GARCH-family implementations.

## **Who maintains and contributes?**
The project is authored and maintained by Zahid Pashayev.

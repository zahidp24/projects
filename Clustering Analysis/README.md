## Clustering Analysis of 2020 Daily Stock Returns
 
How do stocks move together during a crisis? This project uses cluster analysis to group 22 publicly traded stocks based on how their daily returns co-moved throughout 2020 — a year shaped by the COVID-19 pandemic, vaccine races, and some truly wild one-off events (looking at you, Kodak).
 
## What This Project Does
 
Starting from 251 trading days of daily return data, the project computes pairwise Pearson correlations between all 22 stocks and converts them into a dissimilarity matrix. Five different clustering methods are then applied to see which stocks naturally group together:
 
- **Average, Complete, and Single Linkage** — using correlation-based dissimilarity (1 − r)
- **Ward's Method** — using chord distance to satisfy its Euclidean requirement
- **PAM (Partitioning Around Medoids)** — a non-hierarchical method used to cross-validate the hierarchical results
The analysis walks through choosing the right number of clusters (silhouette analysis), evaluating how well each method preserves the original distance structure (cophenetic correlations), and visualizing the results with dendrograms, heatmaps, and multidimensional scaling (MDS) plots.
 
The punchline: all five methods converge on the same five-cluster solution — cyclical/industrial stocks (banking, energy, chemicals), large pharma, big tech, and two singleton outliers (Moderna and Kodak), each driven by its own idiosyncratic story.
 
## Why This Project Is Useful
 
- It's a clean, end-to-end example of unsupervised learning applied to real financial data — from raw returns to interpretable clusters.
- It shows how to properly handle correlation-based distances in clustering, including why Ward's method needs the chord distance transformation rather than raw (1 − r).
- The COVID-19 context makes the results intuitive: you can see how pandemic dynamics (market-wide sell-offs, vaccine speculation, a meme-stock-style event) show up in the correlation structure.
- It compares multiple clustering approaches side by side and demonstrates how to use silhouette widths, cophenetic correlations, and MDS to validate and communicate your results.
 
## Author
 
**Zahid Pashayev** — project author and maintainer.

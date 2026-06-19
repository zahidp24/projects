library(cluster)

# Load data
d <- read.table("stocknew.d", header = TRUE)
stock_labels <- c("JPM","Citi","WF","Shell","Exxon","Chev","Dow","East",
                  "Lyond","DuPont","Honey","Pfiz","JnJ","Mod","Merck",
                  "Lilly","AAPL","NVDA","MSFT","Google","Kodak","Adobe")

# Correlation matrix and dissimilarity
cor_mat <- cor(d)
dist_cor <- as.dist(1 - cor_mat)
chord_dist <- as.dist(sqrt(2 * (1 - cor_mat)))  #used for Ward

# Standard deviations of daily returns
sds <- apply(d, 2, sd)
sort(round(sds, 4), decreasing = TRUE)

# top correlated pairs 
upper_pairs <- which(upper.tri(cor_mat), arr.ind = TRUE)
top <- data.frame(s1 = rownames(cor_mat)[upper_pairs[, 1]],
  s2 = colnames(cor_mat)[upper_pairs[, 2]],
  corr = cor_mat[upper_pairs])

head(top[order(-top$corr), ], 8)

# Avg correlation of each stock with others
avg_cor <- (rowSums(cor_mat) - 1)/(ncol(cor_mat) - 1)
sort(round(avg_cor, 3))  # Moderna and Kodak near zero

#  Hierarchical clustering
hc_avg  <- hclust(dist_cor, method = "average")
hc_comp <- hclust(dist_cor, method = "complete")
hc_sing <- hclust(dist_cor, method = "single")
hc_ward <- hclust(chord_dist, method = "ward.D2")

# Cophenetic correlations
sapply(list(avg = hc_avg, comp = hc_comp,
            sing = hc_sing, ward = hc_ward),
       function(h) round(cor(dist_cor, cophenetic(h)), 4))

# Silhouette analysis (k = 2..7)
sils_avg <- sapply(2:7, function(k) mean(silhouette(cutree(hc_avg,  k), dist_cor)[, 3]))
sils_ward <- sapply(2:7, function(k) mean(silhouette(cutree(hc_ward, k), dist_cor)[, 3]))
names(sils_avg) <- names(sils_ward) <- 2:7

round(rbind(average = sils_avg, ward = sils_ward), 3)
# k = 5 is the sweet spot: good silhouette and interpretable sectors

# PAM
pm <- pam(dist_cor, k = 5, diss = TRUE)
stock_labels[pm$id.med]
mean(pm$silinfo$widths[,3])

# final clusters from Ward
ccol <- c("red","blue","darkgreen","purple","orange")
cl <- cutree(hc_ward, k = 5)
split(stock_labels, cl)

## plots

# Fig 1 - heatmap
ord <- hc_avg$order
par(mar = c(6,6,3,2))
image(1:22, 1:22, cor_mat[ord, rev(ord)],
      col = hcl.colors(50, "RdBu", rev=TRUE), zlim = c(-0.2, 1),
      axes = FALSE, xlab = "", ylab = "",
      main = "Correlation matrix (avg linkage order)")
axis(1, 1:22, stock_labels[ord], las=2, cex.axis=0.6)
axis(2, 1:22, rev(stock_labels[ord]), las=2, cex.axis=0.6)
box()

# Fig 2 - dendrograms
par(mfrow=c(2,2), mar=c(4,4,2,1))
for(hc in list(hc_avg, hc_comp, hc_sing, hc_ward)) {
  nm <- c(average="Average", complete="Complete",
          single="Single", ward.D2="Ward (chord)")[hc$method]
  yl <- if(hc$method == "ward.D2") "Criterion" else "1 - r"
  plot(hc, labels=stock_labels, main=nm, xlab="", sub="", ylab=yl, cex=0.7, hang=-1)
  rect.hclust(hc, k=5, border=ccol)}

# Fig 3 - silhouette
par(mfrow=c(1,2), mar=c(4,4,2,1))
plot(2:7, sils_avg, type="b", pch=19, col="navy", ylim=c(0.2, 0.6),
     xlab="k", ylab="Mean silhouette", main="Silhouette vs k")
lines(2:7, sils_ward, type="b", pch=17, col="darkred")
abline(v=5, lty=2, col="gray50")
legend("topright", c("Average","Ward"), col=c("navy","darkred"),
       pch=c(19,17), lty=1, cex=0.8, bty="n")
par(mar=c(4,8,2,1))
sil_obj <- silhouette(cl, dist_cor)
rownames(sil_obj) <- stock_labels
plot(sil_obj, main="Silhouette - Ward k=5",
     col=ccol, border=NA, cex.names=0.6, do.clus.stat=FALSE, do.n.k=FALSE)

# Fig 4 - MDS
mds <- cmdscale(dist_cor, k=2)
par(mfrow=c(1,1), mar=c(4,4,2,1))
plot(mds[,1], mds[,2], col=ccol[cl], pch=19, cex=1.4,
     main="MDS of correlation distance", xlab="Dim 1", ylab="Dim 2")
text(mds[,1], mds[,2], stock_labels, cex=0.65, pos=3)
legend("bottomleft",
       c("Cyclical","Pharma","Moderna","Tech","Kodak"),
       col=ccol, pch=19, cex=0.7, bty="n")


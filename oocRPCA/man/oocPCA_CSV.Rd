% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/oocRPCAWrappers.R
\name{oocPCA_CSV}
\alias{oocPCA_CSV}
\title{Perform out-of-core SVD for a matrix in CSV format}
\usage{
oocPCA_CSV(inputFile, k = 5, l, mem = 2e+09, its = 2, diffsnorm = FALSE,
  centeringRow = FALSE, centeringColumn = FALSE)
}
\arguments{
\item{inputFile}{csv containing matrix to decompose}

\item{k}{Rank of decomposition. Default: 5}

\item{l}{Block size. Default k+2}

\item{mem}{Amount of memory the algorithm is allowed to use in bytes.  Must be greater than the number of columns * 8 (i.e. the memory to store one row).}

\item{its}{Number of normalized power iterations. Default: 2}

\item{diffsnorm}{Calculate 2-norm accuracy, i.e. ||A-USV||_2.}

\item{centeringRow}{Center the rows prior to decomposition.}

\item{centeringColumn}{Center the columns prior to decomposition.}
}
\value{
A list containing the decomposition.
}
\description{
This function performs a nearly optimal rank-k approximation to the singular value decomposition inputMatrix = USV' on a matrix that is passed via CSV format.  Please see references for explanation of 'nearly optimal.'
}
\examples{

k_ <- 10;
m = 30;
n = 40;
B <- matrix(rexp(m*k_), m)
C <- matrix(rexp(k_*n), k_)
D <- B \%*\%C;
dim(D)
fn = "test_csv.csv"
write.table(D,file=fn,sep=',',col.names=FALSE, row.names=FALSE)
library(oocRPCA);
fastDecomp <- oocPCA_CSV(fn, k=k_, mem=n*8*100, diffsnorm=TRUE)
norm( D - fastDecomp$U \%*\% fastDecomp$S \%*\% t(fastDecomp$V))
unlink(fn)
}

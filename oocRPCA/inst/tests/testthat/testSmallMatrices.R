require(oocRPCA)

context("Small CSV matrices")
testDim <- c(50, 100)
for (m in testDim){
	for (n in testDim){
		k_ <- 20;
		B <- matrix(rexp(m*k_), m)
		C <- matrix(rexp(k_*n), k_)
		for (logT in c(FALSE,TRUE)) {
			Dt <- B%*%C;
			if (logT) {
				D <-exp( Dt) -1;
			}else{
				D <- Dt;
			}
			fn = "test_csv.csv"
			write.table(D,file=fn,sep=',',col.names=FALSE, row.names=FALSE)

			memories <- c(5*n*8 +2342 , 100*n*8, 1E9)

			for (centering in c(0,1,2)){

				if (centering == 0 ){
					rowCentering_ <- FALSE;
					colCentering_ <- FALSE;
					Dtt <- Dt;
				}else if (centering ==1){
					rowCentering_ <- TRUE;
					colCentering_ <- FALSE;
					Dtt <- t(scale(t(Dt), center=TRUE, scale=FALSE));
				}else {
					rowCentering_ <- FALSE;
					colCentering_ <- TRUE;
					Dtt <- scale(Dt, center=TRUE, scale=FALSE);
				}

				for (mem in memories) {
					fastDecomp <- oocPCA_CSV(fn, k=k_, mem=mem, diffsnorm=TRUE, centeringColumn = colCentering_, centeringRow = rowCentering_, logTransform = logT)
					diffNorm <- norm(Dtt - fastDecomp$U %*% fastDecomp$S %*%t(fastDecomp$V), type='2')
					test_that( sprintf("CSV - m: %d, n: %d, k: %d, mem %d, centeringRow :%d, centeringCol: %d, logTransform: %s", fastDecomp$dims[1], fastDecomp$dims[2], k_, mem, rowCentering_, colCentering_, ifelse(logT, "TRUE", "FALSE")), {
							  expect_that(diffNorm,equals(0));
})
				}
			}
		}
		unlink(fn)
	}
}

context("Binary matrices")
testDim <- c(1e2, 1e3)
for (m in testDim){
	for (n in testDim){
		k_ <- 20;
		B <- matrix(rexp(m*k_), m)
		C <- matrix(rexp(k_*n), k_)
		Dt <- B%*%C;
		for (logT in c(FALSE,TRUE)) {
			if (logT) {
				D <-exp( Dt) -1;
			}else{
				D <- Dt;
			}
			fn = "test_csv.csv"
			fnb = "test_csv.binmatrix"
			write.table(D,file=fn,sep=',',col.names=FALSE, row.names=FALSE)
			oocPCA_csv2binary(fn, fnb);
			memories <- c(m*n*8/2, m*n*8/10, 1E9)
			for (centering in c(0,1,2)){
				if (centering == 0 ){
					rowCentering_ <- FALSE;
					colCentering_ <- FALSE;
					Dtt <- Dt;
				}else if (centering ==1){
					rowCentering_ <- TRUE;
					colCentering_ <- FALSE;
					Dtt <- t(scale(t(Dt), center=TRUE, scale=FALSE));
				}else {
					rowCentering_ <- FALSE;
					colCentering_ <- TRUE;
					Dtt <- scale(Dt, center=TRUE, scale=FALSE);
				}

				for (mem in memories) {
					fastDecomp <- oocPCA_BIN(fnb,m,n, k=k_, mem=mem, centeringColumn = colCentering_, centeringRow = rowCentering_, logTransform = logT)
					diffNorm <- norm(Dtt - fastDecomp$U %*% fastDecomp$S %*%t(fastDecomp$V), type='2')
					test_that( sprintf("Binary - m: %d, n: %d, k: %d, mem %d, centeringRow :%d, centeringCol: %d, logTransform: %s", fastDecomp$dims[1], fastDecomp$dims[2], k_, mem, rowCentering_, colCentering_, ifelse(logT, "TRUE", "FALSE")), {
							  expect_that(diffNorm,equals(0));
	})
				}
			}
			unlink(fn)
			unlink(fnb)
		}
	}
}




#context("Small BED/BIM/FAM  matrices")
#D <- matrix(c(1,1,1,2,2,2,1,0,1,0,0,1,1,2,1,2,2,1,0,0,0,1,1,2,2,2,2,1,1,1,0,0,1,1,2),nrow=7,ncol=5, byrow=TRUE);
#fn <- "/Users/george/Research_Local/FastPCA4/FastPCA/fastRPCA/inst/tests/example";
#fn <-sprintf("%s/example", system.file("tests", package="fastRPCA")) ;
#for (centering in c(0,1,2)){
#	k_ = 5;
#	l_ =5;
#	n = 5;
#	memories <- c(2*n*8,3*n*8, 4*n*8, 1E9 )
#	if (centering == 0 ){
#		rowCentering_ <- FALSE;
#		colCentering_ <- FALSE;
#		Dt <- D;
#	}else if (centering ==1){
#		rowCentering_ <- TRUE;
#		colCentering_ <- FALSE;
#		Dt <- t(scale(t(D), center=TRUE, scale=FALSE));
#	}else {
#		rowCentering_ <- FALSE;
#		colCentering_ <- TRUE;
#		Dt <- scale(D, center=TRUE, scale=FALSE);
#	}
#
#	for (mem in memories) {
#		fastDecomp <- fastPCA_BED(fn, k=k_,l=l_, mem=mem, diffsnorm=TRUE, centeringColumn = colCentering_, centeringRow = rowCentering_)
#		diffNorm <- norm(Dt - fastDecomp$U %*% fastDecomp$S %*%t(fastDecomp$V), type='2')
#		test_that( sprintf("BED - m: %d, n: %d, k: %d, mem %d, centeringRow :%d, centeringCol: %d", fastDecomp$dims[1], fastDecomp$dims[2], k_, mem, rowCentering_, colCentering_), {
#				  expect_that(diffNorm,equals(0));
#})
#	}
#}
#
#
#context("Small BED/BIM/FAM matrices with imputation")
#Dm <- matrix(c( 1,1,1,NA,2,2, 1, 0,NA,0, 0,1,1,2,1,2,2,1,0,0,0,1,1,2,2,1,1,NA,1,2,2,2,NA,1,1),nrow=7,ncol=5, byrow=TRUE);
#D <- Dm;
#k <- which(is.na(D), arr.ind=TRUE)
#D[k] <- rowMeans(D, na.rm=TRUE)[k[,1]]
#
##fn <- "/Users/george/Research_Local/FastPCA4/FastPCA/fastRPCA/inst/tests/example";
#fn <-sprintf("%s/example_with_impute", system.file("tests", package="fastRPCA")) ;
#for (centering in c(0,1,2)){
#	k_ = 5;
#	l_ =5;
#	n = 5;
#	memories <- c(2*n*8,3*n*8, 4*n*8, 1E9 )
#	if (centering == 0 ){
#		rowCentering_ <- FALSE;
#		colCentering_ <- FALSE;
#		Dt <- D;
#	}else if (centering ==1){
#		rowCentering_ <- TRUE;
#		colCentering_ <- FALSE;
#		Dt <- t(scale(t(D), center=TRUE, scale=FALSE));
#	}else {
#		rowCentering_ <- FALSE;
#		colCentering_ <- TRUE;
#		Dt <- scale(D, center=TRUE, scale=FALSE);
#	}
#
#	for (mem in memories) {
#		fastDecomp <- fastPCA_BED(fn, k=k_,l=l_, mem=mem, diffsnorm=TRUE, centeringColumn = colCentering_, centeringRow = rowCentering_)
#		diffNorm <- norm(Dt - fastDecomp$U %*% fastDecomp$S %*%t(fastDecomp$V), type='2')
#		test_that( sprintf("BED - m: %d, n: %d, k: %d, mem %d, centeringRow :%d, centeringCol: %d", fastDecomp$dims[1], fastDecomp$dims[2], k_, mem, rowCentering_, colCentering_), {
#				  expect_that(diffNorm,equals(0));
#})
#	}
#}



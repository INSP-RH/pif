% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pif_kernel.R
\name{pif.kernel}
\alias{pif.kernel}
\title{Kernel-based estimate of Potential Impact Fraction}
\usage{
pif.kernel(X, thetahat, rr, cft = NA, weights = rep(1/nrow(as.matrix(X)),
  nrow(as.matrix(X))), adjust = 1, n = 512, ktype = c("gaussian",
  "epanechnikov", "rectangular", "triangular", "biweight", "cosine",
  "optcosine"), bw = c("SJ", "nrd0", "nrd", "ucv", "bcv"),
  check_exposure = TRUE, check_rr = TRUE, check_integrals = TRUE,
  is_paf = FALSE)
}
\arguments{
\item{X}{Random sample (\code{data.frame}) which includes exposure and 
covariates. or sample mean if approximate method is selected.}

\item{thetahat}{Estimator (\code{vector}) of \code{theta} for the Relative
Risk function.}

\item{rr}{Function for Relative Risk which uses parameter \code{theta}.
The order of the parameters shound be \code{rr(X, theta)}.


**Optional**}

\item{cft}{Function \code{cft(X)} for counterfactual. Leave empty for 
the Population Attributable Fraction \code{\link{paf}} where counterfactual 
is 0 exposure.}

\item{weights}{Normalized survey \code{weights} for the sample \code{X}.}

\item{adjust}{Adjust bandwith parameter from density from 
\code{\link[stats]{density}}.}

\item{n}{Number of equally spaced points at which the density is to be 
estimated (see \code{\link[stats]{density}}).}

\item{ktype}{\code{kernel} type:  \code{"gaussian"}, \code{"epanechnikov"},
\code{"rectangular"}, \code{"triangular"}, \code{"biweight"},
\code{"cosine"}, \code{"optcosine"}. Additional information on kernels in
\code{\link[stats]{density}}}

\item{bw}{Smoothing bandwith parameter from density from 
\code{\link[stats]{density}}. Default \code{"SJ"}}

\item{check_exposure}{Check that exposure \code{X} is positive and numeric.}

\item{check_rr}{Check that Relative Risk function \code{rr} equals 
\code{1} when evaluated at \code{0}.}

\item{check_integrals}{Check that counterfactual and relative risk's expected
values are well defined for this scenario.}

\item{is_paf}{Boolean forcing evaluation of \code{\link{paf}}.}
}
\value{
pif      Estimate of Potential Impact Fraction
}
\description{
Function for estimating the Potential Impact Fraction \code{\link{pif}}
 from a cross-sectional sample of the exposure \code{X} with a known Relative
 Risk function \code{rr} with parameters \code{theta} using kernels.
}
\note{
In practice \code{\link{pif.empirical}} should be prefered as
 convergence is faster than \code{\link{pif.kernel}} for most functions. In
 addition, the scope of \code{\link{pif.kernel}} is limited as it does not
 work with multivariate exposure data \code{X}.
}
\examples{

#Example 1: Relative risk given by exponential
#--------------------------------------------
set.seed(18427)
X        <- data.frame(rnorm(100,3,.5))
thetahat <- 0.12
rr       <- function(X, theta){exp(theta*X)}
pif.kernel(X, thetahat, rr, cft = function(X){ 0.5*X })

#Choose a different kernel
pif.kernel(X, thetahat, rr, cft = function(X){ 0.5*X }, ktype = "gaussian")

#Specify kernel options
pif.kernel(X, thetahat, rr, cft = function(X){ 0.5*X }, ktype = "gaussian", 
bw = "nrd", adjust = 0.5, n = 1100)

#Without counterfactual estimates PAF
pif.kernel(X, thetahat, rr) 
 
#Example 2: Linear relative risk
#--------------------------------------------
pif.kernel(X, thetahat, rr = function(X, theta){theta*X + 1}, 
               cft = function(X){ 0.5*X })

#Example 3: More complex counterfactual
#--------------------------------------------
set.seed(18427)
X       <- data.frame(rnorm(100,4,1))
thetahat <- c(0.12, 0.03)
rr       <- function(X, theta){1 + theta[1]*X + theta[2]*X^2}

#Creating a counterfactual. As rr requires a bivariate input, cft should 
#return a two-column matrix
cft  <- function(X){
   X[which(X > 4)] <- 1
   return(X)
}
pif.kernel(X, thetahat, rr, cft) 

}
\seealso{
\code{\link{pif}} which is a wrapper for all pif methods 
 (\code{\link{pif.empirical}}, \code{\link{pif.approximate}}, 
 \code{\link{pif.kernel}}).
 
 For estimation of the Population Attributable Fraction see
 \code{\link{paf}}.
 
 For more information on kernels see \code{\link[stats]{density}}
}
\author{
Rodrigo Zepeda-Tello \email{rzepeda17@gmail.com}

Dalia Camacho-García-Formentí \email{daliaf172@gmail.com}
}
\keyword{internal}

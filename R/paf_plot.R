#' @title Plot of Population Attributable Fraction under different values of 
#'   Relative Risk's parameter theta
#'   
#' @description Function that plots the \code{\link{paf}} under different values
#'   of a univariate parameter \code{theta} of the Relative Risk function \code{rr} 
#'   which depends on the exposure \code{X} and a \code{theta} parameter 
#'   (\code{rr(X, theta)})
#'   
#' @param X         Random sample (\code{data.frame}) which includes exposure 
#'   and covariates or sample \code{mean} if \code{"approximate"} method is 
#'   selected.
#'   
#' @param thetalow  Minimum of \code{theta} (parameter of relative risk 
#'   \code{rr}) for plot.
#'   
#' @param thetaup   Maximum of \code{theta} (parameter of relative risk 
#'   \code{rr}) for plot.
#'   
#' @param rr        \code{function} for Relative Risk which uses parameter 
#'   \code{theta}. The order of the parameters should be \code{rr(X, theta)}.
#'   
#'  \strong{ **Optional**}
#'   
#' @param weights   Normalized survey \code{weights} for the sample \code{X}.
#'   
#' @param method    Either \code{"empirical"} (default), \code{"kernel"} or 
#'   \code{"approximate"}. For details on estimation methods see 
#'   \code{\link{pif}}.
#'   
#' @param confidence Confidence level \% (default \code{95}).
#'   
#' @param confidence_method  Either \code{bootstrap} (default) \code{inverse}, 
#'   \code{one2one}, \code{linear}, \code{loglinear}. See \code{\link{paf}} 
#'   details for additional information.
#'   
#' @param Xvar      Variance of exposure levels (for \code{"approximate"} 
#'   method).
#'   
#' @param deriv.method.args \code{method.args} for 
#'   \code{\link[numDeriv]{hessian}} (for \code{"approximate"} method).
#'   
#' @param deriv.method      \code{method} for \code{\link[numDeriv]{hessian}}. 
#'   Don't change this unless you know what you are doing (for 
#'   \code{"approximate"} method).
#'   
#' @param ktype    \code{kernel} type:  \code{"gaussian"}, 
#'   \code{"epanechnikov"}, \code{"rectangular"}, \code{"triangular"}, 
#'   \code{"biweight"}, \code{"cosine"}, \code{"optcosine"} (for \code{"kernel"}
#'   method). Additional information on kernels in \code{\link[stats]{density}}.
#'   
#' @param bw        Smoothing bandwith parameter (for 
#'   \code{"kernel"} method) from \code{\link[stats]{density}}. Default 
#'   \code{"SJ"}.
#'   
#' @param adjust    Adjust bandwith parameter (for \code{"kernel"} 
#'   method) from \code{\link[stats]{density}}.
#'   
#' @param n   Number of equally spaced points at which the density (for 
#'   \code{"kernel"} method) is to be estimated (see 
#'   \code{\link[stats]{density}}).
#'   
#' @param nsim Number of simulations to generate confidence intervals.   
#'   
#' @param mpoints Number of points in plot.
#'   
#' @param colors \code{vector} Colors of plot.
#'   
#' @param xlab \code{string} Label of x-axis in plot.
#'   
#' @param ylab \code{string} Label of y-axis in plot.
#'   
#' @param title \code{string} Title of plot.
#'   
#' @param check_integrals \code{boolean}  Check that counterfactual \code{cft} 
#'   and relative risk's \code{rr} expected values are well defined for this 
#'   scenario.
#'   
#' @param check_exposure  \code{boolean}  Check that exposure \code{X} is 
#'   positive and numeric.
#'   
#' @param check_rr        \code{boolean} Check that Relative Risk function
#'   \code{rr} equals \code{1} when evaluated at \code{0}.
#'   
#' @return paf.plot       \code{\link[ggplot2]{ggplot}} object with plot of 
#'   Population Attributable Fraction as function of \code{theta}.
#'   
#' @author Rodrigo Zepeda-Tello \email{rzepeda17@gmail.com}
#' @author Dalia Camacho-García-Formentí \email{daliaf172@gmail.com}
#'   
#' @import ggplot2
#'   
#' @examples 
#' 
#' \dontrun{
#' #Example 1: Exponential Relative Risk empirical method
#' #-----------------------------------------------------
#' set.seed(18427)
#' X <- data.frame(Exposure = rbeta(25, 4.2, 10))
#' paf.plot(X, thetalow = 0, thetaup = 2, function(X, theta){exp(theta*X)})
#' 
#' 
#' #Same example with kernel method
#' paf.plot(X, 0, 2, function(X, theta){exp(theta*X)}, method = "kernel",
#' title = "Kernel method example") 
#'  
#' #Same example for approximate method
#' Xmean <- data.frame(mean(X[,"Exposure"]))
#' Xvar  <- var(X)
#' paf.plot(Xmean, 0, 2, function(X, theta){exp(theta*X)}, 
#' method = "approximate", Xvar = Xvar, title = "Approximate method example")
#' }
#' 
#' @seealso 
#' 
#' See \code{\link{paf}} for Population Attributable Fraction estimation 
#'   with confidence intervals \code{\link{paf.confidence}}.
#'   
#' See \code{\link{pif.plot}} for same plot with Potential Impact Fraction 
#'   \code{\link{pif}}.
#'   
#' @export

paf.plot <- function(X, thetalow, thetaup, rr,         
                     method  = "empirical",
                     confidence_method = "bootstrap",
                     confidence = 95,
                     nsim    = 100,
                     weights =  rep(1/nrow(as.matrix(X)),nrow(as.matrix(X))), 
                     mpoints = 100,
                     adjust = 1, n = 512, 
                     Xvar    = var(X), 
                     deriv.method.args = list(), 
                     deriv.method      = "Richardson",
                     ktype  = "gaussian", 
                     bw     = "SJ",
                     colors = c("deepskyblue", "gray25"), xlab = "Theta", 
                     ylab = "PAF",
                     title = "Population Attributable Fraction (PAF) under different values of theta",
                     check_exposure = TRUE, check_rr = TRUE, check_integrals = TRUE){
  
  pif.plot(X = X, thetalow = thetalow, thetaup = thetaup, rr = rr, 
           cft=NA,  method = method, confidence_method = confidence_method,
           confidence = confidence,  nsim = nsim, weights = weights, mpoints = mpoints,
           adjust = adjust, n = n, Xvar = Xvar,
           deriv.method.args = deriv.method.args, deriv.method = deriv.method,
           ktype = ktype, bw = bw, colors = colors, xlab = xlab, ylab = ylab,
           title = title, check_exposure = check_exposure, check_rr = check_rr,
           check_integrals = check_integrals, is_paf = TRUE)
  
}

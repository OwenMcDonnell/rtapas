% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tapas_train.R
\name{tapas_train}
\alias{tapas_train}
\title{TAPAS Model Training}
\usage{
tapas_train(data, dsc_cutoff = 0.03, verbose = TRUE)
}
\arguments{
\item{data}{Data resulting from \code{\link{tapas_data}}. The \code{data} should be a \code{tibble} or
\code{data.frame} containing binded subject data or a \code{list} object with subject data in each element.
Data from these subjects will be used for model training.}

\item{dsc_cutoff}{The Sørensen's–Dice coefficient (DSC) value to use as a cutoff for training inclusion.
By default 0.03 is used. This must be a single value between 0 and 1. Only training subjects with a subject-specific
threshold estimate resulting in Sørensen's–Dice coefficient (DSC) greater than or equal to the \code{dsc_cutoff}
will be included in training the TAPAS model.}

\item{verbose}{A \code{logical} argument to print messages. Set to \code{TRUE} by default.}
}
\value{
A \code{list} with the TAPAS model (\code{tapas_model}) of class \code{gam} and
a \code{tibble} with the clamp information (\code{clamp_data}). The clamp information contains the
TAPAS-predicted smallest and largest threshold to be applied by using estimates related to the volume at the
10th and 90th percentile.
}
\description{
This function trains the TAPAS model using all binded subject-level \code{tibble}s produced
from the \code{\link{tapas_data}} function. The TAPAS model is fit and clamp data is calculated. The clamp data
contains the predicted threshold when using the 10th and 90th percentile volume from training data.
}
\examples{
\dontrun{
# Data is provided in the rtapas package as arrays. Below we will convert them to nifti objects.
# Before we can implement the train_tapas function we have to generate the training data
library(oro.nifti)
# Create a list of gold standard manual segmentation
train_gold_standard_masks = list(gs1 = gs1,
                                 gs2 = gs2,
                                 gs3 = gs3,
                                 gs4 = gs4,
                                 gs5 = gs5,
                                 gs6 = gs6,
                                 gs7 = gs7,
                                 gs8 = gs8,
                                 gs9 = gs9,
                                 gs10 = gs10)
# Convert the gold standard masks to nifti objects
train_gold_standard_masks = lapply(train_gold_standard_masks, oro.nifti::nifti)

# Make a list of the training probability maps
train_probability_maps = list(pmap1 = pmap1,
                             pmap2 = pmap2,
                             pmap3 = pmap3,
                             pmap4 = pmap4,
                             pmap5 = pmap5,
                             pmap6 = pmap6,
                             pmap7 = pmap7,
                             pmap8 = pmap8,
                             pmap9 = pmap9,
                             pmap10 = pmap10)

# Convert the probability maps to nifti objects
train_probability_maps = lapply(train_probability_maps, oro.nifti::nifti)
# Make a list of the brain masks
train_brain_masks = list(brain_mask1 = brain_mask,
                         brain_mask2 = brain_mask,
                         brain_mask3 = brain_mask,
                         brain_mask4 = brain_mask,
                         brain_mask5 = brain_mask,
                         brain_mask6 = brain_mask,
                         brain_mask7 = brain_mask,
                         brain_mask8 = brain_mask,
                         brain_mask9 = brain_mask,
                         brain_mask10 = brain_mask)

# Convert the brain masks to nifti objects
train_brain_masks = lapply(train_brain_masks, oro.nifti::nifti)

# Specify training IDs
train_ids = paste0('subject_', 1:length(train_gold_standard_masks))

# The function below runs on 2 cores. Be sure your machine has 2 cores available or switch to 1.
# Run tapas_data_par function
# You can also use the tapas_data function and generate each subjects data
data = tapas_data_par(cores = 2,
                      thresholds = seq(from = 0, to = 1, by = 0.01),
                      pmap = train_probability_maps,
                      gold_standard = train_gold_standard_masks,
                      mask = train_brain_masks,
                      k = 0,
                      subject_id = train_ids,
                      ret = TRUE,
                      outfile = NULL,
                      verbose = TRUE)

# We can now implement the train_tapas function using the data from tapas_data_par
tapas_model = tapas_train(data = data,
                          dsc_cutoff = 0.03,
                          verbose = TRUE)
# The TAPAS GAM model
summary(tapas_model$tapas_model)
# The threshold that optimizes group-level DSC
tapas_model$group_threshold
# The lower and upper bound clamps to avoid extrapolation
tapas_model$clamp_data
}
}


##################
# load libraries #
##################

lbs <- c("optparse", "AeRobiology", "readxl", "tidyverse")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)


#######################
# Command line config #
#######################
option_list = list(
  make_option(
    c("-i", "--input"),
    type = "character",
    default = NULL,
    help = "Input file path",
    metavar = "character"
  ),
  make_option(
    c("--interpolation"),
    type = "logical",
    default = TRUE,
    help = "A logical value specifying if the visualization shows the gaps in 
    the inputs data (interpolation = FALSE) or if an interpolation method is 
    used for filling the gaps (interpolation = TRUE).",
    metavar = "logical"
  ),
  make_option(
    c("--intMethod"),
    type = "character",
    default = "lineal",
    help = "A character string with the name of the interpolation method 
    to be used. The implemented methods that may be used are: 
    'lineal', 'movingmean', 'tseries' or 'spline'.",
    metavar = "character"
  ),
  make_option(
    c("--exportPlot"),
    type = "logical",
    default = TRUE,
    help = "A logical value specifying if a plot will be exported or not. 
    If FALSE graphical results will only be displayed in the active graphics 
    window. If TRUE graphical results will be displayed in the active graphics 
    window and also one pdf/png file will be saved within the plot_AeRobiology 
    directory automatically created in the working directory.",
    metavar = "logical"
  ),
  make_option(
    c("--exportFormat"),
    type = "character",
    default = "pdf",
    help = "A character string specifying the format selected to save the plot. 
    The implemented formats that may be used are: 'pdf' or 'png'.",
    metavar = "character"
  ),
  make_option(
    c("--exportResult"),
    type = "logical",
    default = TRUE,
    help = "A logical value. If export.result = TRUE, a table is exported 
    with the extension .xlsx, in the directory table_AeRobiology. This table 
    has the information about the slope 'beta coefficient of a lineal model 
    using as predictor the year and as dependent variable one of the main pollen 
    season indexes'. The information is referred to the main pollen season 
    indexes: Start Date, Peak Date, End Date and Pollen Integral.",
    metavar = "logical"
  ),
  make_option(
    c("--method"),
    type = "character",
    default = "percentage",
    help = "A character string specifying the method applied to calculate the 
    pollen season and the main seasonal parameters. The implemented methods 
    that can be used are: 'percentage', 'logistic', 'moving', 'clinical' 
    or 'grains'.",
    metavar = "character"
  ),
  make_option(
    c("--quantil"),
    type = "numeric",
    default = 0.75,
    help = "A numeric value (between 0 and 1) indicating the quantile 
    of data to be displayed in the graphical output of the function. 
    quantil = 1 would show all the values, however a lower quantile will exclude
    the most extreme values of the sample. To split the parameters using a 
    different sampling units (e.g. dates and pollen concentrations) can be used 
    low vs high values of quantil argument (e.g. 0.5 vs 1). Also can be used 
    an extra argument: split.",
    metavar = "numeric"
  ),
  make_option(
    c("--significant"),
    type = "numeric",
    default = 0.05,
    help = "A numeric value indicating the significant level to be considered 
    in the linear trends analysis. This p level is displayed in the graphical 
    output of the function.",
    metavar = "numeric"
  ),
  make_option(
    c("--split"),
    type = "logical",
    default = TRUE,
    help = "A logical argument. If split = TRUE, the plot is separated in 
    two according to the nature of the variables (i.e. dates or pollen 
    concentrations).",
    metavar = "logical"
  ),
  make_option(
    c("--result"),
    type = "character",
    default = "plot",
    help = "A character object with the definition of the object to be 
    produced by the function. If result == 'plot', the function returns a 
    list of objects of class ggplot2; if result == 'table', 
    the function returns a data.frame.",
    metavar = "character"
  ),
  make_option(
    c("--delimiter"),
    type="character",
    default=",",
    help="Dataframe delimiter",
    metavar="character"
  )
)


opt_parser = OptionParser(option_list = option_list)
opt = parse_args(opt_parser)


###########################
# End command line config #
###########################

#############
# Functions #
#############
readFile <- function (file){
  if(is.null(file)){
    stop("File path is mandatory")
  }
  data <- read.csv(file, sep=opt$delimiter)
  data <- data[,c(2:ncol(data))]
  data$date <- as.Date(data$date)
  
  return(data)
}
#################
# End Functions #
#################

#############
# Variables #
#############
data <- readFile(opt$input)
interpolation <- as.logical(opt$interpolation)
int.method <- opt$intMethod
export.plot <- as.logical(opt$exportPlot)
export.format <- opt$exportFormat
export.result <- opt$exportResult
method <- opt$method
significant <-as.numeric(opt$significant)
split <- as.logical(opt$split)
result <- opt$result
#################
# End variables #
#################

########
# MAIN #
########

setwd("data")

analyse_trend(data = data,
              interpolation = interpolation,
              int.method = int.method,
              export.plot = export.plot,
              export.format = export.format,
              export.result = export.result,
              method = method,
              significant = significant,
              split = split,
              result = result)

##################
# load libraries #
##################

ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg,dependencies = TRUE, 
                     quiet = TRUE, 
                     repos = "https://cran.r-project.org/")
  sapply(pkg, 
         require, 
         character.only = TRUE)
}

ipak(c("AeRobiology","tidyverse","optparse"))


#######################
# Command line config #
#######################
option_list = list(
  make_option(
    c("-i", "--input"),
    type = "character",
    default = NULL,
    help = "Input file name",
    metavar = "character"
  ),
  make_option(
    c("--nTypes"),
    type = "numeric",
    default = 15,
    help = "A numeric (integer) value specifying the number of the most 
    abundant pollen types that must be represented in the plot of the 
    relative abundance.",
    metavar = "numeric"
  ),
  make_option(
    c("--yStart"),
    #type = "numeric",
    default = NULL,
    help = "A numeric (integer) value specifying the period selected to 
    calculate relative abundances of the pollen types (start year _ end year). 
    If y.start and y.end are not specified (NULL), the entire database will be 
    used to generate the pollen calendar.",
    #metavar = "numeric"
  ),
  make_option(
    c("--yEnd"),
    #type = "numeric",
    default = NULL,
    help = "A numeric (integer) value specifying the period selected to 
    calculate relative abundances of the pollen types (start year _ end year). 
    If y.start and y.end are not specified (NULL), the entire database will be 
    used to generate the pollen calendar.",
    #metavar = "numeric"
  ),
  make_option(
    c("--interpolation"),
    type = "logical",
    default = TRUE,
    help = "A logical value. If FALSE the interpolation of the pollen data is 
    not applicable. If TRUE an interpolation of the pollen series will be 
    applied to complete the gaps with no data before the calculation of 
    the pollen season.",
    metavar = "logical"
  ),
  make_option(
    c("--intMethod"),
    type = "character",
    default = "lineal",
    help = "A character string specifying the method selected to apply the 
    interpolation method in order to complete the pollen series. 
    The implemented methods that may be used are: 'lineal', 'movingmean', 
    'spline' or 'tseries'.",
    metavar = "character"
  ),
  make_option(
    c("--colBar"),
    type = "character",
    default = "#E69F00",
    help = "A character string specifying the color of the bars to generate 
    the graph showing the relative abundances of the pollen types.",
    metavar = "character"
  ),
  make_option(
    c("--typePlot"),
    type = "character",
    default = "static",
    help = "A character string specifying the type of plot selected to show 
    the plot showing the relative abundance of the pollen types. 
    The implemented types that may be used are: static generates a static 
    ggplot object and dynamic generates a dynamic plotly object.",
    metavar = "character"
  ),
  make_option(
    c("--result"),
    type = "character",
    default = "plot",
    help = "A character string specifying the output for the function. 
    The implemented outputs that may be obtained are: 'plot' and 'table'.",
    metavar = "character"
  ),
  make_option(
    c("--exportPlot"),
    type = "logical",
    default = FALSE,
    help = "A logical value specifying if a plot saved in the working directory 
    will be required or not. If FALSE graphical results will only be displayed 
    in the active graphics window. If TRUE graphical results will be displayed 
    in the active graphics window and also a pdf or png file (according to 
    the export.format argument) will be saved within the plot_AeRobiology 
    directory automatically created in the working directory.",
    metavar = "logical"
  ),
  make_option(
    c("--exportFormat"),
    type = "character",
    default = "pdf",
    help = "A character string specifying the format selected to save the plot 
    showing the relative abundance of the pollen types. The implemented 
    formats that may be used are: 'pdf' and 'png'. This argument is applicable 
    only for 'static' plots.",
    metavar = "character"
  ),
  make_option(
    c("--exclude"),
    type = "character",
    default="",
    help = "A character string vector with the names of the pollen types 
    to be excluded from the plot.",
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
n.types <- as.numeric(opt$nTypes)
y.start <- opt$yStart
y.end <- opt$yEnd
interpolation <- as.logical(opt$interpolation)
int.method <- opt$intMethod
col.bar <- opt$colBar
type.plot <- opt$typePlot
result <- opt$result
export.plot <- as.logical(opt$exportPlot)
export.format <- opt$exportFormat
exclude <- opt$exclude
#################
# End variables #
#################


########
# MAIN #
########

if(y.start=="None" | y.start==""){
  y.start <- NULL
} else {
  y.start <- as.numeric(opt$yStart)
}

if(y.end=="None" | y.end==""){
  y.end <- NULL
} else {
  y.end <- as.numeric(opt$yEnd)
}

if(is.numeric(y.start) & is.numeric(y.end)){
  if(y.end < y.start){
    stop("y.start must be lower than y.end")
    
  }
}

setwd("data")

iplot_abundance(data = data,
                n.types = n.types,
                y.start = y.start,
                y.end = y.end,
                interpolation = interpolation,
                int.method = int.method,
                col.bar = col.bar,
                type.plot = type.plot,
                result = result,
                export.plot = export.plot,
                export.format = export.format,
                exclude = exclude
                )

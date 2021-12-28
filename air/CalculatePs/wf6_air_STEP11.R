
##################
# load libraries #
##################

ipak <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg,dependencies = TRUE, 
                     quiet = TRUE, 
                     repos = "http://cran.us.r-project.org")
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
    c("-i","--input"),
    type = "character",
    default = NULL,
    help = "Input file name",
    metavar = "character"
  ),
  make_option(
    c("--method"),
    type = "character",
    default = NULL,
    help = "A character string specifying the method applied to calculate 
    the pollen season and the main parameters.
    Options:percentage, logistic, moving, clinical or grains",
    metavar = "character"
  ),
  make_option(
    c("--thDay"),
    type = "integer",
    default = 100,
    help = "A numeric value (integer). The number of days whose 
    pollen concentration is bigger than this threshold is calculated for 
    each year and pollen type.",
    metavar = "integer"
  ),
  make_option(
    c("--perc"),
    type = "double",
    default = 95,
    help="This argument is valid only for method = 'percentage'. This value 
    represents the percentage of the total annual pollen included in the pollen 
    season, removing (100_perc)/2% of the total pollen before and after of
    the pollen season.",
    metavar = "double"
  ),
  make_option(
    c("--defSeason"),
    type = "character",
    default = "natural",
    help = "A character string specifying the method for selecting 
    the best annual periodto calculate the pollen season.
    Options: 'natural', 'interannual' or 'peak' ",
    metavar = "character"
  ),
  make_option(
    c("--reduction"),
    type = "logical",
    default = FALSE,
    help = "This argument is valid only for the 'logistic' method. If
            FALSE the reduction of the pollen data is not applicable. 
            If TRUE a reduction of the peaks above a certain level 
            (red.level argument) will be carried out before
            the definition of the pollen season.",
    metavar = "logical"
  ),
  make_option(
    c("--redLevel"),
    type = "double",
    default = 0.9,
    help= "A numeric value ranging 0_1 specifying the percentile used as 
    level to reduce the peaks of the pollen series before the definition of the
    pollen season. This argument is valid only for the 'logistic' method.",
    metavar = "double"
  ),
  make_option(
    c("--derivative"),
    type = "integer",
    default = 5,
    help = "A numeric (integer) value belonging to options of 4, 5 or 6 
    specifying the derivative that will be applied to calculate the asymptotes
    which determines the pollen season using the 'logistic' method. 
    This argument is valid only for the 'logistic' method.",
    metavar = "integer"
  ),
  make_option(
    c("--man"),
    type = "integer",
    default = 11,
    help = "A numeric (integer) value specifying the order of the moving 
    average applied to calculate the pollen season using the 'moving' 
    method. This argument is valid only for the 'moving' method.",
    metavar = "integer"
  ),
  make_option(
    c("--thMa"),
    type = "double",
    default = 5,
    help = "A numeric value specifying the threshold used for the 'moving' 
    method for defining the beginning and the end of the pollen season.",
    metavar = "double"
    ),
  make_option(
    c("--nClinical"),
    type = "integer",
    default = 5,
    help = "A numeric (integer) value specifying the number of days which 
    must exceed a given threshold (th.pollen argument) for defining the 
    beginning and the end of the pollen season. This argument is valid only 
    for the 'clinical' method.",
    metavar = "integer"
  ),
  make_option(
    c("--windowClinical"),
    type = "integer",
    default = 7,
    help = "A numeric (integer) value specifying the time window during which 
    the conditions must be evaluated for defining the beginning and the end of 
    the pollen season using the 'clinical' method. This argument 
    is valid only for the 'clinical' method.",
    metavar = "integer"
  ),
  make_option(
    c("--windowGrains"),
    type = "integer",
    default = 5,
    help = "A numeric (integer) value specifying the time window during which 
    the conditions must be evaluated for defining the beginning and the end of 
    the pollen season using the 'grains' method. 
    This argument is valid only for the 'grains'",
    metavar = "integer"
  ),
  make_option(
    c("--thPollen"),
    type = "double",
    default = 10,
    help  = "A numeric value specifying the threshold that must be exceeded 
    during a given number of days (n.clinical or window.grains arguments) for 
    defining the beginning and the end of the pollen season using the 
    'clinical' or 'grains' methods.",
    metavar = "double"
  ),
  make_option(
    c("--thSum"),
    type = "double",
    default = 100,
    help = "A numeric value specifying the pollen threshold that must be 
    exceeded by the sum of daily pollen during a given number of days 
    (n.clinical argument) exceeding a given daily threshold (th.pollen argument) 
    for defining the beginning and the end of the pollen season using the 
    'clinical' method",
    metavar = "double"
  ),
  make_option(
    c("--type"),
    type = "character",
    default = "none",
    help = "A character string specifying the parameters considered according to 
    a specific pollen type for calculating the pollen season using the 'clinical' 
    method. The implemented pollen types that may be used are: 'birch', 
    'grasses', 'cypress', 'olive' or 'ragweed'. As result for selecting any 
    of these pollen types the parameters n.clinical, window.clinical,
    th.pollen and th.sum will be automatically adjusted for the 'clinical' 
    method. If no pollen types are specified (type = 'none'), 
    these parameters will be considered by the user",
    metavar = "character"
  ),
  make_option(
    c("--interpolation"),
    type = "logical",
    default = TRUE,
    help = "A logical value. If FALSE the interpolation of the pollen data is 
    not applicable. If TRUE an interpolation of the pollen series will be 
    applied to complete the gaps with no data before the calculation of the 
    pollen season.",
    metavar = "logical"
  ),
  make_option(
    c("--intMethod"),
    type = "character",
    default = "lineal",
    help = "A character string specifying the method selected to apply the 
    interpolation method in order to complete the pollen series. 
    The implemented methods that may be used are: 'lineal', 
    'movingmean', 'spline' or 'tseries'.",
    metavar = "character"
  ),
  make_option(
    c("--maxDays"),
    type = "integer",
    default = 30,
    help = "A numeric (integer value) specifying the maximum number 
    of consecutive days with missing data that the algorithm is going 
    to interpolate. If the gap is bigger than the argument value, 
    the gap will not be interpolated.",
    metavar = "integer"
  ),
  make_option(
    c("--result"),
    type = "character",
    default = "table",
    help = "A character string specifying the output for the function. 
    The implemented outputs that may be obtained are: 'table' and 'list'.",
    metavar = "character"
  ),
  make_option(
    c("--plot"),
    type = "logical",
    default = TRUE,
    help = "A logical value specifying if a set of plots based on the 
    definition of the pollen season will be shown in the plot history or not. 
    If FALSE graphical results will not be shown. If TRUE a set of plots 
    will be shown in the plot history.",
    metavar = "logical"
  ),
  make_option(
    c("--exportPlot"),
    type = "logical",
    default = FALSE,
    help = "A logical value specifying if a set of plots based on the 
    definition of the pollen season will be saved in the workspace. 
    If TRUE a pdf file for each pollen type showing graphically the 
    definition of the pollen season for each studied year will be saved 
    within the plot_AeRobiology directory created in the working directory.",
    metavar = "logical"
  ),
  make_option(
    c("--exportResult"),
    type = "logical",
    default = TRUE,
    help = "A logical value specifying if a excel file including all 
    parameters for the definition of the pollen season saved in the 
    working directoty will be required or not. If FALSE the results 
    will not exported. If TRUE the results will be exported as xlsx file 
    including all parameters calculated from the definition of the pollen 
    season within the table_AeRobiology directory created in 
    the working directory.",
    metavar = "logical"
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
# Arguments #
#############
data <- readFile(opt$input)
method <- opt$method
th.day <- as.numeric(opt$thDay)
perc <- as.numeric(opt$perc)
def.season <- opt$defSeason
reduction <- as.logical(opt$reduction)
red.level <- as.numeric(opt$redLevel)
derivative <- as.numeric(opt$derivative)
man <- as.numeric(opt$man)
th.ma <- as.numeric(opt$thMa)
n.clinical <- as.numeric(opt$nClinical)
window.clinical <- as.numeric(opt$windowClinical)
window.grains <- as.numeric(opt$windowGrains)
th.pollen <- as.numeric(opt$thPollen)
th.sum <- as.numeric(opt$thSum)
type <- opt$type
interpolation <- as.logical(opt$interpolation)
int.method <- opt$intMethod
maxdays <- as.numeric(opt$maxDays)
result <- opt$result
plot <- as.logical(opt$plot)
export.plot <- as.logical(opt$exportPlot)
export.result <- as.logical(opt$exportResult)
#################
# End Arguments #
#################


if(is.null(method)){
  stop("Method is mandatory")
}


setwd("data")

calculate_ps(data = data,
            method = method,
            th.day = th.day,
            perc = perc,
            def.season = def.season,
            reduction = reduction,
            red.level = red.level,
            derivative = derivative,
            man = man,
            th.ma = th.ma,
            n.clinical = n.clinical,
            window.clinical = window.clinical,
            window.grains = window.grains,
            th.pollen = th.pollen,
            th.sum = th.sum,
            type = type,
            interpolation = interpolation,
            int.method = int.method,
            maxdays = maxdays,
            result = result,
            plot = plot,
            export.plot = export.plot,
            export.result = export.result
            )

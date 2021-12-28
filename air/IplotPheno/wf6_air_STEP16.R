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
    c("-i","--input"),
    type = "character",
    default = NULL,
    help ="Inptu file path",
    metavar = "character"
  ),
  make_option(
    c("--method"),
    type = "character",
    default = "percentage",
    help = 'A character string specifying the method applied to calculate the pollen season
and the main parameters. The implemented methods that can be used are:
"percentage", "logistic", "moving", "clinical" or "grains". Default method is "percentage"'
  , metavar = "character"
    ),
  make_option(
    c("--nTypes"),
    type = "numeric",
    default = 15,
    help = "A numeric (integer) value specifying the number of the most 
    abundant pollen types that must be represented in the pollen calendar.",
    metavar = "numeric"
  ),
  make_option(
    c("--thDay"),
    type = "numeric",
    default = 100,
    help = "A numeric value in order to calculate the number of days when 
    this level is exceeded for each year and each pollen type. This value 
    will be obtained in the results of the function.",
    metavar = "numeric"
  ),
  make_option(
    c("--perc"),
    type = "numeric",
    default = 95,
    help = "A numeric value ranging 0_100. This argument is valid only for 
    method = 'percentage'. This value represents the percentage of the total 
    annual pollen included in the pollen season, removing (100_perc)/2% of 
    the total pollen before and after of the pollen season."
    , metavar = "numeric"
    ),
  make_option(
    c("--defSeason"),
    type = "character",
    default = "natural",
    help = "Acharacterstring  specifying  the  method  for  selecting  the  best  annual  pe-riod to calculate the pollen season.  The pollen seasons may occur within thenatural year or otherwise may occur between two years which determines thebest annual period considered.  The implemented options that can be used are:'natural','interannual' or 'peak'. "
    , metavar = "character"
    ),
  make_option(
    c("--reduction"),
    type = "logical",
    default = FALSE,
    help = "logicalvalue.  This argument is valid only for the 'logistic' method.  IfFALSEthe reduction of the pollen data is not applicable.  IfTRUEa reduction ofthe peaks above a certain level (red.levelargument) will be carried out beforethe  definition  of  the  pollen  season.  "
    , metavar = "logical"
    ),
  make_option(
    c("--redLevel"),
    type = "numeric",
    default = 0.90,
    help =  "Anumericvalue ranging0_1specifying the percentile used as level to reducethe peaks of the pollen series before the definition of the pollen season.  Thisargument is valid only for the 'logistic' method."
    , metavar = "numeric"
    ),
  make_option(
    c("--derivative"),
    type = "numeric",
    default = 5,
    help = "Anumeric(integer) value belonging to options of4,5or6specifying thederivative that will be applied to calculate the asymptotes which determines thepollen season using the 'logistic' method. "
  , metavar = "numeric"
    ),
  make_option(
    c("--man"),
    type = "numeric",
    default = 11,
    help = "Anumeric(integer) value specifying the order of the moving average appliedto calculate the pollen season using the 'moving' method. This argument isvalid only for the 'moving' method. "
  , metavar = "numeric"
    ),
  make_option(
    c("--thMa"),
    type = "numeric",
    default = 5,
    help = 'A numeric value specifying the threshold used for the"moving"method fordefining the beginning and the end of the pollen season. This argument is validonly for the"moving"method.'
  , metavar = "numeric"
    ),
  make_option(
    c("--nClinical"),
    type = "numeric",
    default = 5,
    help = 'Anumeric(integer) value specifying the number of days which must exceeda given threshold (th.pollenargument) for defining the beginning and the end of the pollen season. This argument is valid only for the "clinical" method'
  , metavar = "numeric"
    ),
  make_option(
    c("--windowClinical"),
    type = "numeric",
    default = 7,
    help = 'A numeric (integer) value specifying the time window during which the conditions
must be evaluated for defining the beginning and the end of the pollen
season using the "clinical" method. This argument is valid only for the
"clinical" method.',
    metavar = "numeric"
  ),
  make_option(
    c("--windowGrains"),
    type = "numeric",
    default = 5,
    help = 'A numeric (integer) value specifying the time window during which the conditions
must be evaluated for defining the beginning and the end of the pollen
season using the "grains" method. This argument is valid only for the "grains"
method.'
    ,metavar = "numeric"
  ),
  make_option(
    c("--thPollen"),
    type = "numeric",
    default = 10,
    help = 'A numeric value specifying the threshold that must be exceeded during a given
number of days (n.clinical or window.grains arguments) for defining the
beginning and the end of the pollen season using the "clinical" or "grains"
methods. This argument is valid only for the "clinical" or "grains" methods.'
  , metavar = "numeric"
    ),
  make_option(
    c("--thSum"),
    type = "numeric",
    default = 100,
    help = 'A numeric value specifying the pollen threshold that must be exceeded by the
sum of daily pollen during a given number of days (n.clinical argument)
exceeding a given daily threshold (th.pollen argument) for defining the beginning
and the end of the pollen season using the "clinical" method. This
argument is valid only for the "clinical" method.'
  , metavar = "numeric"
    ),
  make_option(
    c("--type"),
    type = "character",
    default = "none",
    help = 'A character string specifying the parameters considered according to a specific
pollen type for calculating the pollen season using the "clinical" method.
The implemented pollen types that may be used are: "birch", "grasses",
"cypress", "olive" or "ragweed". As result for selecting any of these pollen
types the parameters n.clinical, window.clinical, th.pollen and th.sum
will be automatically adjusted for the "clinical" method. If no pollen types
are specified (type = "none"), these parameters will be considered by the user.
This argument is valid only for the "clinical" method.'
  , metavar = "character"
    ),
  make_option(
    c("--interpolation"),
    type = "logical",
    default = TRUE,
    help = 'A logical value. If FALSE the interpolation of the pollen data is not applicable.
If TRUE an interpolation of the pollen series will be applied to complete the gaps
with no data before the calculation of the pollen season. The interpolation
argument will be TRUE by default.'
  , metavar = "logical"
    ),
  make_option(
    c("--intMethod"),
    type = "character",
    default = "lineal",
    help = 'A character string specifying the method selected to apply the interpolation
method in order to complete the pollen series. The implemented methods that
may be used are: "lineal", "movingmean", "spline" or "tseries". The
int.method argument will be "lineal" by default'
  , metavar = "character"
    ),
  make_option(
    c("--typePlot"),
    type = "character",
    default = "static",
    help = 'A character string specifying the type of plot selected to show the phenological
plot. The implemented types that may be used are: "static" generates a static
ggplot object and "dynamic" generates a dynamic plotly object.'
  , metavar = "character"
    ),
  make_option(
    c("--exportPlot"),
    type = "logical",
    default = FALSE,
    help = 'logical value specifying if a phenological plot saved in the working directory
will be required or not. If FALSE graphical results will only be displayed in the
active graphics window. If TRUE graphical results will be displayed in the active graphics window and also a pdf or png file (according to the export.format
argument) will be saved within the plot_AeRobiology directory automatically
created in the working directory. This argument is applicable only for "static"
plots.'
    , metavar = "logical"
  ),
  make_option(
    c("--exportFormat"),
    type = "character",
    default = "pdf",
    help = 'A character string specifying the format selected to save the phenological plot.
The implemented formats that may be used are: "pdf" and "png". This argument
is applicable only for "static" plots. The export.format will be "pdf"
by default.'
    , metavar = "character"
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
method <- opt$method
n.types <- as.numeric(opt$nTypes)
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
type.plot <- opt$typePlot
export.plot <- as.logical(opt$exportPlot)
export.format <- opt$exportFormat

#################
# End variables #
#################
########
# MAIN #
########

setwd("data")

iplot_pheno(
    data = data,
    method = method,
    n.types = n.types,
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
    type.plot = type.plot,
    export.plot = export.plot,
    export.format = export.format)
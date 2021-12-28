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
    c("-i", "--input"),
    type = "character",
    default = NULL,
    help = "Input file name",
    metavar = "character"
  ),
  make_option(
    c("--method"),
    type = "character",
    default = "heatplot",
    help = "A character string specifying the method applied to calculate 
    and generate the pollen calendar. The implemented methods that can 
    be used are: 'heatplot', 'violinplot' or 'phenological'.",
    metavar = "character"
  ),
  make_option(
    c("--nTypes"),
    type = "integer",
    default = 15,
    help = "A numeric (integer) value specifying the number of the most 
    abundant pollen types that must be represented in the pollen calendar",
    metavar = "integer"
  ),
  make_option(
    c("--startMonth"),
    type = "integer",
    default = 1,
    help = "A numeric (integer) value ranging 1_12 specifying the number of the 
    month (January_December) when the beginning of the pollen calendar must be 
    considered. This argument is only applicable for the 'heatplot' method with
    'daily' period, for the 'phenological' method with 'avg_before' 
    average.method, and for the 'violinplot' method, and the rest of 
    methods only may be generatedfrom the January",
    metavar = "integer"
  ),
  make_option(
    c("--yStart"),
    #type = "integer",
    default = NULL,
    help = "A numeric (integer) value specifying the period selected to 
    calculate the pollen calendar (start year _ end year). If y.start and 
    y.end are not specified (NULL), the entire database will be used to 
    generate the pollen calendar.",
    #metavar = "integer"
  ),
  make_option(
    c("--yEnd"),
    #type = "integer",
    default = NULL,
    help = "A numeric (integer) value specifying the period selected to 
    calculate the pollen calendar (start year _ end year). If y.start and 
    y.end are not specified (NULL), the entire database will be used to 
    generate the pollen calendar.",
    #metavar = "integer"
  ),
  make_option(
    c("--perc1"),
    type = "double",
    default = 80,
    help = "A numeric value ranging 0_100. These arguments are valid only 
    for the 'phenological' method. These values represent the percentage of 
    the total annual pollen included in the pollen season, removing 
    (100_percentage)/2% of the total pollen before and after of the pollen 
    season. Two percentages must be specified because of the definition of the 
    'main pollination period' (perc1) and 'early/late pollination' (perc2) 
    based on the 'phenological' method proposed by Werchan et al. (2018).",
    metavar = "double"
  ),
  make_option(
    c("--perc2"),
    type = "double",
    default = 99,
    help = "A numeric value ranging 0_100. These arguments are valid only 
    for the 'phenological' method. These values represent the percentage of 
    the total annual pollen included in the pollen season, removing 
    (100_percentage)/2% of the total pollen before and after of the pollen 
    season. Two percentages must be specified because of the definition of the 
    'main pollination period' (perc1) and 'early/late pollination' (perc2) 
    based on the 'phenological' method proposed by Werchan et al. (2018).",
    metavar = "double"
  ),
  make_option(
    c("--thPollen"),
    type = "double",
    default = 1,
    help = "A numeric value specifying the minimum threshold of the average 
    pollen concentration which will be used to generate the pollen calendar. 
    Days below this threshold will not be considered. For the 'phenological' 
    method this value limits the 'possible occurrence' period as proposed 
    by Werchan et al. (2018).",
    metavar = "double"
  ),
  make_option(
    c("--averageMethod"),
    type = "character",
    default = "avg_before",
    help = "A character string specifying the moment of the application of 
    the average. This argument is valid only for the 'phenological' method. 
    The implemented methods that can be used are: 'avg_before' or 'avg_after'. 
    'avg_before' produces the average to the daily concentrations and then 
    pollen season are calculated for all pollen types, this method is 
    recommended as it is a more concordant method with respect to the rest 
    of implemented methods. Otherwise, 'avg_after' determines the pollen season 
    for all years and all pollen types, and then a circular average is 
    calculated for the start_dates and end_dates",
    metavar = "character"
  ),
  make_option(
    c("--period"),
    type = "character",
    default = "daily",
    help = "A character string specifying the interval time considered to 
    generate the pollen calendar. This argument is valid only for the 'heatplot' 
    method. The implemented periods that can be used are: 'daily' or 'weekly'. 
    'daily' selection produces a pollen calendar using daily averages during 
    the year and 'weekly' selection produces a pollen calendar using weekly 
    averages during the year.",
    metavar = "character"
  ),
  make_option(
    c("--methodClasses"),
    type = "character",
    default = "exponential",
    help = "A character string specifying the method to define the classes 
    used for classifying the average pollen concentrations to generate the 
    pollen calendar. This argument is valid only for the 'heatplot' method.",
    metavar = "character"
  ),
  make_option(
    c("--nClasses"),
    type = "integer",
    default = 5,
    help = "A numeric (integer) value specifying the number of classes that 
    will be used for classifying the average pollen concentrations to 
    generate the pollen calendar. This argument is valid only for the 'heatplot'
    method and the classification by method.classes = 'custom'.",
    metavar = "integer"
  ),
  make_option(
    c("--classes"),
    type = "character",
    default = NULL,
    help = "A numeric vector specifying the threshold established to define 
    the different classes that will be used for classifying the average pollen 
    concentrations to generate the pollen calendar. This argument is valid only 
    for the 'heatplot' method and the classification by 
    method.classes = 'custom'",
    metavar = "character"
  ),
  make_option(
    c("--color"),
    type = "character",
    default = "green",
    help = "A character string specifying the color to generate the graph 
    showing the pollen calendar. This argument is valid only for the 'heatplot' 
    method. The implemented color palettes to generate the pollen calendar are: 
    'green', 'red', 'blue', 'purple' or 'black'.",
    metavar = "character"
  ),
  make_option(
    c("--interpolation"),
    type = "logical",
    default = TRUE,
    help = "A logical value. If FALSE the interpolation of the pollen data is 
    not applicable. If TRUE an interpolation of the pollen series will be 
    applied to complete the gaps before the calculation of the pollen calendar.",
    metavar = "logical"
  ),
  make_option(
    c("--intMethod"),
    type = "character",
    default = "lineal",
    help = "A character string specifying the method selected to apply the 
    interpolation method in order to complete the pollen series. The 
    implemented methods that may be used are: 'lineal', 'movingmean', 'spline' 
    or 'tseries'.",
    metavar = "character"
  ),
  make_option(
    c("--naRemove"),
    type = "logical",
    default = TRUE,
    help = "A logical value specifying if na values must be remove for the 
    pollen calendar or not.",
    metavar = "logical"
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
    help = "A logical value specifying if a plot with the pollen calendar saved 
    in the working directory will be required or not. If FALSE graphical 
    results will only be displayed in the active graphics window. If TRUE 
    graphical results will be displayed in the active graphics window and also 
    a pdf file will be saved within the plot_AeRobiology directory automatically
    created in the working directory",
    metavar = "logical"
  ),
  make_option(
    c("--exportFormat"),
    type = "character",
    default = "pdf",
    help = "A character string specifying the format selected to save the 
    pollen calendar plot. The implemented formats that may be 
    used are: 'pdf' and 'png'.",
    metavar = "character"
  ),
  make_option(
    c("--legendName"),
    type = "character",
    default = "Pollen / m3",
    help = "A character string specifying the title of the legend.",
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
# Arguments #
#############

data <- readFile(opt$input)
method <- opt$method
n.types <- as.numeric(opt$nTypes)
start.month <- as.numeric(opt$startMonth)
y.start <- opt$yStart
y.end <- opt$yEnd
perc1 <- as.numeric(opt$perc1)
perc2 <- as.numeric(opt$perc2)
th.pollen <- as.numeric(opt$thPollen)
average.method <- opt$averageMethod
period <- opt$period
method.classes <- opt$methodClasses
n.classes <- as.numeric(opt$nClasses)
classes <- substr(opt$classes, 2, nchar(opt$classes)-1)
classes <- as.numeric(unlist(strsplit(classes, ",")))
color <- opt$color
interpolation <- as.logical(opt$interpolation)
int.method <- opt$intMethod
na.remove <- as.logical(opt$naRemove)
result <- opt$result
export.plot <- as.logical(opt$exportPlot)
export.format <- opt$exportFormat
legendname <- opt$legendName
################
# En Arguments #
################

########
# MAIN #
########

if(is.null(data)){
  stop("Input file is mandatory")
}

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

#data <- readFile(data_path)

setwd("data")

pollen_calendar(data = data,
                method = method,
                n.types = n.types,
                start.month = start.month,
                y.start = y.start,
                y.end = y.end,
                perc1 = perc1,
                perc2 = perc2,
                th.pollen = th.pollen,
                average.method = average.method,
                period = period,
                method.classes = method.classes,
                n.classes = n.classes,
                classes = classes,
                color = color,
                interpolation = interpolation,
                int.method = int.method,
                na.remove = na.remove,
                result = result,
                export.plot = export.plot,
                export.format = export.format,
                legendname = legendname
                )

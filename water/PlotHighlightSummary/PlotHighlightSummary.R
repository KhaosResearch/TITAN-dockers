# Install (and load) kableExtra library

lbs <- c("kableExtra", "optparse")
not_installed <- lbs[!(lbs %in% installed.packages()[ , "Package"])]
if(length(not_installed)) install.packages(not_installed, repos = "http://cran.us.r-project.org")
sapply(lbs, require, character.only=TRUE)

# Read command line arguments

option_list = list(
  make_option(c("-i", "--input"), type = "character", default = NA,
              help = "Dataset file",
  ),
  make_option(c("--delimiter"), type = "character", default = ",",
              help = "Dataset delimiter",
  )
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Extract data frame from input file

csv_data <- read.csv(opt$input, sep = opt$delimiter)

# Select the relevant columns

rel_columns <- c("Hidrologic.Year", "Station", "Sum.of.the.Year")
if (all(rel_columns %in% colnames(csv_data))){
  csv_data <- csv_data[, rel_columns]
} else {
  stop("The input file does not contain the required columns")
}

# Change data frame distribution

stations <- unique(csv_data[,2])
list_df <- lapply(stations, FUN = function(st){
  data_st <- csv_data[csv_data[,2] == st, c(1,3)]
  colnames(data_st) <- c("Hidrologic Year", st)
  return(data_st)
  })
data <- Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = 1, all = TRUE), list_df)

# Calculate the annual average

data <- cbind(data, round(rowMeans(data[,-1], na.rm = TRUE),1))
colnames(data)[length(colnames(data))] <- "Average Annual Precipitation (mm)"

# Highlight the wettest and driest year

wet_year <- which(data[,ncol(data)] == max(data[,ncol(data)]))
data[wet_year, 1] <- cell_spec(data[wet_year, 1], background = "#9ab3d4")

dry_year <- which(data[,ncol(data)] == min(data[,ncol(data)]))
data[dry_year, 1] <- cell_spec(data[dry_year, 1], background = "#fffea6")

# Calculate the maximum, the mean and the minimum of each station

list_measures <- lapply(2:ncol(data), FUN = function(col) c(max(na.omit(data[,col])), round(mean(na.omit(data[,col])),1), min(na.omit(data[,col])), round(1.15 * mean(na.omit(data[,col])),1), round(0.85 * mean(na.omit(data[,col])),1)))
df_measures <- cbind(paste("<b>", c("Max", "Mean", "Min", "Mean * 1.15", "Mean * 0.85"), "</b>"), do.call(cbind, list_measures))

# Count the number of wet, medium and dry years for each station

df_years <- paste("<b>", c("Wet years", "Middle years", "Dry years"), "</b>")
for (col in 2:ncol(data)){
  wet_years <- which(data[,col] > as.numeric(df_measures[4, col]))
  dry_years <- which(data[,col] < as.numeric(df_measures[5, col]))
  data[wet_years, col] <- cell_spec(data[wet_years, col], background = "#9ab3d4")
  data[dry_years, col] <- cell_spec(data[dry_years, col], background = "#fffea6")
  df_years <- cbind(df_years, c(length(wet_years), length(na.omit(data[,col])) - (length(wet_years) + length(dry_years)), length(dry_years)))
}

# Add the information to the main data frame

colnames(df_measures) <- colnames(data)
data <- rbind(data, df_measures)
colnames(df_years) <- colnames(data)
data <- rbind(data, df_years)

# Stylize and export the data frame to an html file

options(knitr.kable.NA = '')
kable(data, "html", escape = F, align = "c", ) %>%
  kable_paper("striped", full_width = F, html_font = "American Typewriter") %>%
  column_spec(1:ncol(data), background = "white") %>%
  row_spec(0, bold = T, color = "black", hline_after = T) %>%
  pack_rows("", nrow(data) - 7, nrow(data) - 5, background = "white") %>%
  pack_rows("", nrow(data) - 4, nrow(data) - 3, background = "white") %>%
  pack_rows("", nrow(data) - 2, nrow(data), background = "white") %>%
  row_spec(nrow(data) - 4, background = "#9ab3d4") %>%
  row_spec(nrow(data) - 3, background = "#fffea6") %>%
  column_spec(1, border_right = T, background = "white") %>%
  column_spec(ncol(data), border_left = T) %>%
  save_kable(file = "data/summary_table.html")

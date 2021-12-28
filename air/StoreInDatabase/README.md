## NAME
StoreInDatabase

## TAG
1.0.0

## AUTHOR
Khaos Research Group

Daniel Doblas Jimenez

## DATE
23-09-2021 12:39

## DESCRIPTION
Stores the summary of an xlsx template file into a xlsx databse

summary_sheet (str): Name of the xlsx sheet that includes the summay. Defaults to 'Resumen'

data_columns (str): Range of columns to include in format <initial>:<end> using excel column names. Defaults to 'B:AQ'

# DOCKER

## Build

```
docker build -t enbic2lab/air/store_in_database -f storeInDatabase.dockerfile .
```

## Run

```
docker run -v $(pwd)/data:/usr/local/src/data/ docker.io/enbic2lab/air/store_in_database --filepath1 "PlantillaMalaga.xlsx" --filepath2 "month_may_malaga.xlsx" --summary-sheet "Resumen" --data-columns "B:AQ" 
```

## Submit

```
docker ... --tag 1.0.0
```


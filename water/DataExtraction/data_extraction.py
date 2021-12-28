import datetime
import os
from functools import partial
from pathlib import Path

import pandas as pd
import typer


def dataExtraction(
    file_path: str = typer.Option(..., help="Path of Time Series CSV file"),
    delimiter: str = typer.Option(..., help="Delimiter of CSV"),
):

    os.chdir("data")

    # create dataframe
    df = pd.read_csv(file_path, sep=delimiter)

    # format to datetime
    df["DATE"] = pd.to_datetime(df["DATE"], format="%Y-%m-%d")
    stations = df.columns.drop("DATE")

    # statistical data of interest
    interest = [
        "Hidrologic Year",
        "Station",
        "Year Mean",
        "Year Maximum",
        "Year minimum",
        "Year Collected Data",
        "Year Empty Data",
        "Year Collected Data (Percentage)",
        "Year Empty Data (Percentage)",
    ]

    # create output dataframe
    output_df = pd.DataFrame(columns=interest)

    i = 1
    for station in stations:
        min_year = df["DATE"].min().year
        max_year = df["DATE"].max().year

        # Filtering for hidrologic year
        for year in range(min_year, max_year):
            start = f"{year}-10-1"
            end = f"{year + 1}-9-30"
            filtered_df = df.loc[(df["DATE"] >= start) & (df["DATE"] <= end)]

            # Calculating the total value of the year
            year_total = filtered_df[station].sum()
            # Calculating the year mean
            year_mean = filtered_df[station].mean()
            # Calculating the year minimum
            year_min = filtered_df[station].min()
            # Calculating the year maximum
            year_max = filtered_df[station].max()
            # Counting the number of rows
            n_rows = len(filtered_df.index)
            # Counting the number of empty rows
            empty_rows = filtered_df[station].isnull().sum()
            # Calculating the percentage of empty rows
            empty_per = (empty_rows / n_rows) * 100

            # Updating dataframe for each hidrologic year
            output_df.loc[i, "Station"] = station
            output_df.loc[i, "Hidrologic Year"] = f"{year}/{year + 1}"
            if year_total == 0:
                output_df.loc[i, "Sum of the Year"] = ""
            else:
                output_df.loc[i, "Sum of the Year"] = year_total
            output_df.loc[i, "Year Mean"] = year_mean
            output_df.loc[i, "Year Maximum"] = year_max
            output_df.loc[i, "Year minimum"] = year_min
            output_df.loc[i, "Year Collected Data"] = n_rows - empty_rows
            output_df.loc[i, "Year Empty Data"] = empty_rows
            output_df.loc[i, "Year Empty Data (Percentage)"] = empty_per
            output_df.loc[i, "Year Collected Data (Percentage)"] = 100 - empty_per
            i += 1

    output_df.to_csv("StatisticalData.csv", index=False, sep=delimiter)


if __name__ == "__main__":
    typer.run(dataExtraction)

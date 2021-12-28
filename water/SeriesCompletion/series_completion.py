import datetime
import os
import re
from typing import List, Optional

import numpy as np
import pandas as pd
import pyhomogeneity
import typer
from numpy import NaN
from pyhomogeneity.pyhomogeneity import buishand_range_test, pettitt_test, snht_test
from sklearn.linear_model import LinearRegression


def SeriesCompletion(
    file_path: str = typer.Option(..., help="Path of AEMET Test file"),
    start_date: str = typer.Option(..., help="Start Date"),
    end_date: str = typer.Option(..., help="End Date"),
    target_station: str = typer.Option(..., help="Target station"),
    analysis_stations: Optional[List[str]] = typer.Option(
        ...,
        help="List of stations that will be used to complete the target station. As many --analysis-stations as you want to use must be passed.",
    ),
    completion_criteria: str = typer.Option(..., help="r2, slope, intercept or pair"),
    tests: Optional[List[str]] = typer.Option(
        ...,
        help="Homogeneity tests to perform. Values that can be included in the list are 'pettit','snht','buishand'. As many --tests as you want to perform must be passed.",
    ),
    delimiter: str = typer.Option(..., help="Delimiter of CSV"),
):

    os.chdir("data")

    # checking errors
    if (
        completion_criteria != "r2"
        and completion_criteria != "slope"
        and completion_criteria != "intercept"
        and completion_criteria != "pair"
    ):
        raise ValueError("Enter a valid criterion to completion_criteria the completion")

    if "pettit" not in tests and "snht" not in tests and "buishand" not in tests:
        raise ValueError("Enter a valid homogeneity test")

    # create dataframe
    df = pd.read_csv(file_path, sep=delimiter)

    # format to datetime
    df["DATE"] = pd.to_datetime(df["DATE"], format="%Y-%m-%d")

    df_filter = df.iloc[:, 1 : df.shape[1]]

    df_filter = df_filter.dropna(how="all")

    df_filter["index"] = df_filter.index

    df["index"] = df.index

    first_element = df_filter.iloc[
        0,
    ]["index"]

    last_element = df_filter.iloc[
        -1,
    ]["index"]

    date = df.iloc[
        int(first_element) : int(last_element) + 1,
    ]["DATE"]

    df_filter["DATE"] = date

    df_filter = df_filter.drop(["index"], axis=1)

    start_date_datetime = datetime.datetime.strptime(start_date, "%Y-%m-%d")
    end_date_datetime = datetime.datetime.strptime(end_date, "%Y-%m-%d")

    if (start_date_datetime > end_date_datetime or df_filter.iloc[0,]["DATE"] > start_date_datetime) or (
        df_filter.iloc[
            -1,
        ]["DATE"]
        < end_date_datetime
    ):
        raise ValueError(
            "Enter a valid range of dates. Values are stored between "
            + df_filter.iloc[0,][
                "DATE"
            ].strftime("%Y-%m-%d")
            + " and "
            + df_filter.iloc[-1,][
                "DATE"
            ].strftime("%Y-%m-%d")
            + "."
        )

    # Checking station name
    columns = list(df.columns)
    columns.remove("DATE")
    columns.remove("index")
    aux_names = ""

    for name in columns:
        aux_names += name + ", "
    aux_names = aux_names[0 : len(aux_names) - 2]

    if target_station not in columns:
        raise ValueError(target_station + " is not a valid column name, valid names: " + aux_names)

    if len(df[target_station].dropna()) == 0:
        raise ValueError("All the stations must contain at least a value")

    for station in analysis_stations:
        if station not in columns:
            raise ValueError(station + " is not a valid column name, valid names: " + aux_names)
        if len(df[station].dropna()) == 0:
            raise ValueError("All the stations must contain at least a value")

    filtered_df = df.loc[(df["DATE"] >= start_date) & (df["DATE"] <= end_date)]

    analysis_df = pd.DataFrame(index=["R2", "Slope", "Intercept", "Pair of data"], columns=analysis_stations)

    series_completion = pd.DataFrame(columns=["DATE"])
    series_completion["DATE"] = filtered_df["DATE"]
    series_completion = series_completion.set_index("DATE")

    # Linear regression between the stations
    for station in analysis_stations:
        join_df = df[[target_station, station]]

        shared_data = len(join_df.dropna())
        if len(join_df.dropna()) == 0:
            y = join_df[station].values.reshape(-1, 1)
        else:
            join_df = join_df.dropna()
            y = join_df[target_station].values.reshape(-1, 1)

        X = join_df[station].values.reshape(-1, 1)
        regr = LinearRegression()

        regr.fit(X, y)

        # We store the different regression coefficients between the target station
        # and the stations used to complete the series
        analysis_df.loc["R2", station] = regr.score(X, y)
        analysis_df.loc["Slope", station] = regr.coef_[0][0]
        analysis_df.loc["Intercept", station] = regr.intercept_[0]
        analysis_df.loc["Pair of data", station] = shared_data

        # Then, we take the values of each station
        completion = df[["DATE", station]].dropna()
        completion = completion.set_index("DATE")
        station_fit = completion[station].values.reshape(-1, 1)
        station_pred = regr.predict(station_fit)
        completion[station] = station_pred
        series_completion = series_completion.join(completion)

    # Sort stations according to the prioritization criteria
    if completion_criteria == "r2":
        analysis_df = analysis_df.sort_values("R2", axis=1, ascending=False)
    elif completion_criteria == "slope":
        analysis_df = analysis_df.sort_values("Slope", axis=1, ascending=False)
    elif completion_criteria == "intercept":
        analysis_df = analysis_df.sort_values("Intercept", axis=1, ascending=False)
    elif completion_criteria == "pair":
        analysis_df = analysis_df.sort_values("Pair of Data", axis=1, ascending=False)

    best_stations = list(analysis_df.columns)

    # dataframe to store the best completed values
    target_completion = filtered_df[["DATE", target_station]]
    target_completion = target_completion.set_index("DATE")
    
    completed_data = target_completion[target_completion[target_station].isna()]
    
    # completing the target station, but empty values remain
    rows_to_complete = target_completion[target_station].isna().sum().tolist()

    if rows_to_complete != 0:
        for station in best_stations:
            target_completion.loc[target_completion[target_station].isna(), target_station] = series_completion.loc[
                target_completion[target_station].isna(), station
            ].values
            
            completed_data = completed_data.fillna(target_completion)

    completed_data = completed_data.round(3)

    if completion_criteria == "intercept":
        intercepts = analysis_df.loc["Intercept"].values

        # completion error correction
        for num in intercepts:
            target_completion = target_completion.replace(num, 0)

    target_completion = target_completion.round(3)

    # values for the different homogeneity tests
    tests_out = [
        "Homogeneity",
        "Change Point Location",
        "P-value",
        "Maximum test Statistics",
        "Average between change point",
    ]

    # dataframe for the homogeneity tests
    tests_df = pd.DataFrame(index=tests_out)

    # computing the homogeneity tests
    if "pettit" in tests:
        [homogeneity, change_point, p_value, U, mu] = pyhomogeneity.pettitt_test(
            target_completion, alpha=0.5, sim=10000
        )
        tests_df.loc["Homogeneity", "Pettit Test"] = homogeneity
        tests_df.loc["Change Point Location", "Pettit Test"] = change_point
        tests_df.loc["P-value", "Pettit Test"] = p_value
        tests_df.loc["Maximum test Statistics", "Pettit Test"] = U
        tests_df.loc["Average between change point", "Pettit Test"] = mu

    if "snht" in tests:
        [homogeneity, change_point, p_value, T, mu] = pyhomogeneity.snht_test(target_completion, alpha=0.5, sim=10000)
        tests_df.loc["Homogeneity", "SNHT Test"] = homogeneity
        tests_df.loc["Change Point Location", "SNHT Test"] = change_point
        tests_df.loc["P-value", "SNHT Test"] = p_value
        tests_df.loc["Maximum test Statistics", "SNHT Test"] = T
        tests_df.loc["Average between change point", "SNHT Test"] = mu
    if "buishand" in tests:
        [homogeneity, change_point, p_value, R, mu] = pyhomogeneity.buishand_range_test(
            target_completion, alpha=0.5, sim=10000
        )
        tests_df.loc["Homogeneity", "Buishand Test"] = homogeneity
        tests_df.loc["Change Point Location", "Buishand Test"] = change_point
        tests_df.loc["P-value", "Buishand Test"] = p_value
        tests_df.loc["Maximum test Statistics", "Buishand Test"] = R
        tests_df.loc["Average between change point", "Buishand Test"] = mu

    target_station = re.sub("[()]", "", target_station)
    completed_data.to_csv("CompletedData.csv", sep=delimiter)
    analysis_df.to_csv("StationsAnalysis.csv", sep=delimiter)
    target_completion.to_csv(f"{target_station.replace(' ', '_')}_completed.csv", sep=delimiter)
    tests_df.to_csv("HomogeneityTests.csv", sep=delimiter)


if __name__ == "__main__":
    typer.run(SeriesCompletion)

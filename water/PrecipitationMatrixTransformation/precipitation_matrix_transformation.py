import datetime
import os
from pathlib import Path

import pandas as pd
import typer
from numpy import NaN


def precipitationMatrixTransformation(
    file_path: str = typer.Option(..., help="Path of AEMET Precipitation Test file"),
    delimiter: str = typer.Option(..., help="Delimiter of CSV"),
):

    os.chdir("data")

    # create dataframe
    matrix_df = pd.read_excel(file_path, engine="openpyxl")

    # change column name if it is wrong
    if "AﾑO" in matrix_df.columns:
        matrix_df.rename(columns={"AﾑO": "AÑO"}, inplace=True)

    # replace precipitation with values -3 and -4 to 0
    matrix_df = matrix_df.replace([-3, -4], 0)
    matrix_df.loc[:, "P1":"P31"] = matrix_df.loc[:, "P1":"P31"].div(10)
    # obtain minimum and maximum year of recorded data
    min_year = matrix_df["AÑO"].min()
    max_year = matrix_df["AÑO"].max()

    # create auxiliary dataframe containing info of extreme years
    min_df = matrix_df.where(matrix_df["AÑO"] == min_year)
    max_df = matrix_df.where(matrix_df["AÑO"] == max_year)

    # set conditions so that the time series starting and ending point point
    # coincides with the hidrologic year in Andalusia (from 1 October to 30 September)
    if int(min_df["MES"].min()) <= 10 and int(max_df["MES"].max() >= 9):
        start_date = f"{int(min_year) - 1}-10-1"
        end_date = f"{int(max_year) + 1}-9-30"
        dates_pd = pd.date_range(start=start_date, end=end_date, freq="D")
    elif int(min_df["MES"].min()) <= 10:
        start_date = f"{int(min_year) - 1}-10-1"
        end_date = f"{int(max_year)}-9-30"
        dates_pd = pd.date_range(start=start_date, end=end_date, freq="D")
    elif int(max_df["MES"].max()) >= 9:
        start_date = start_date = f"{int(min_year)}-10-1"
        end_date = f"{int(max_year) + 1}-9-30"
        dates_pd = pd.date_range(start=start_date, end=end_date, freq="D")

    # create dataframe where the time series data is to be stored
    final_pd = pd.DataFrame(columns=["DATE"])
    final_pd["DATE"] = dates_pd
    final_pd = final_pd.set_index("DATE")

    # get the stations where the data is obtained
    stations = matrix_df["NOMBRE"].unique()

    # create a dataframe to each station that will be used to get the final output
    for station in stations:
        partial_pd = pd.DataFrame(columns=[station])

        # Get the values for each station, so that the columns labelled as 'P1',....'P31' corresponds
        # to the day of the month and record these values and assign each value in the time series output
        data_station = matrix_df[matrix_df["NOMBRE"] == station]
        for index, row in data_station.iterrows():
            values_p = row["P1":"P31"].to_dict()
            for key, val in values_p.items():
                try:
                    datetime_index = datetime.datetime(int(row["AÑO"]), int(row["MES"]), int(key.replace("P", "")))
                    partial_pd.loc[datetime_index] = val
                except ValueError:
                    None
        # join the dataframe created for each station to the final one
        final_pd = final_pd.join(partial_pd)

    # drop columns with NaN values
    if NaN in final_pd.columns:
        final_pd = final_pd.drop(NaN, axis="columns")

    final_pd.to_csv("PrecipitationTimeSeries.csv", sep=delimiter)


if __name__ == "__main__":
    typer.run(precipitationMatrixTransformation)

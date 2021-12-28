import os

import pandas as pd
import typer


def store_in_database(
    filepath1: str = typer.Option(..., help="Name of the xlsx file"),
    filepath2: str = typer.Option(..., help="Name of the database"),
    summary_sheet: str = typer.Option(
        ..., help="Name of the xlsx sheet that includes the summary. Defaults to 'Resumen' "
    ),
    data_columns: str = typer.Option(
        ..., help="Range of columns to include in format <initial>:<end> using excel column names. Defaults to 'B:AO'"
    ),
):
    os.chdir("data")

    # Read input file
    df = pd.read_excel(filepath1, sheet_name=summary_sheet, usecols=data_columns)

    # Removing Nan data
    df = df.dropna(how="all")
    df = df.drop("Total", axis=1, inplace=True)

    # Read database
    db = pd.read_excel(filepath2)

    # Removing Nan data
    db = db.dropna(how="all")

    # Mergin sheets
    df_final = pd.concat([df, db], ignore_index=True)

    # Creates 'output.csv'
    df_final.to_csv("output.csv", sep=";")


if __name__ == "__main__":
    typer.run(store_in_database)

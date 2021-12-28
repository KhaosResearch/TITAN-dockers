import os

import pandas as pd
import typer


def extract_from_template(
    filepath: str = typer.Option(..., help="Name of the xlsx file"),
    code: str = typer.Option(..., help=""),
    summary_sheet: str = typer.Option(..., help="Name of the xlsx sheet that includes the summay. Defaults to 'Resumen'"),
    data_columns: str = typer.Option(..., help="Range of columns to include in format <initial>:<end> using excel column names. Defaults to 'A:AQ'"),
):
    os.chdir("data")
    xlsx_sheet = pd.read_excel(filepath, sheet_name=summary_sheet, usecols=data_columns)

    # Removing Nan data
    xlsx_sheet = xlsx_sheet.dropna(how="all")

    # Inserting code column
    xlsx_sheet.insert(0, "C—digo", [code] * len(xlsx_sheet))

    # creates `output.xlsx`
    xlsx_sheet.to_excel("output.xlsx", index=False)


if __name__ == "__main__":
    typer.run(extract_from_template)

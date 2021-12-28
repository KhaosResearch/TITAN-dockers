import os

import pandas as pd
import typer


def spss2csv(
    filepath: str = typer.Option(..., help="Name of the spss file"),
    drop_index: bool = typer.Option(..., help="Drop index of tabular dataset"),
):
    os.chdir("data")

    # Create the dataframe
    try:
        df = pd.read_spss(filepath)
    except:
        raise ValueError("The format of the file is not valid")

    # Dropping the unname columns to obtain just the factors of analysis
    if "Unnamed: 0" in df.columns and drop_index:
        df = df.drop("Unnamed: 0", axis=1)

    # prepare the output
    df.to_csv("Data.csv", index=False, sep=";")


if __name__ == "__main__":
    typer.run(spss2csv)

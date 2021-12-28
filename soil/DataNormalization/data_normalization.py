import os

import pandas as pd
import typer
from sklearn.preprocessing import StandardScaler


def data_normalization(
    filepath: str = typer.Option(..., help="Name of the csv file"),
    delimiter: str = typer.Option(..., help="Delimiter of the csv file"),
):
    os.chdir("data")

    try:
        df = pd.read_csv(filepath, sep=delimiter).dropna()
    except:
        raise ValueError("The file input is not in the valid format")

    # Factors in the output
    factors = df.columns.values.tolist()

    # Centering and scaling the data so that the means for each factor are 0 and the standard deviation are 1
    scaled_data = StandardScaler().fit_transform(df)

    # Create output dataframe
    scaled_df = pd.DataFrame(scaled_data, columns=factors)

    # prepare output for the time series output
    scaled_df.to_csv("DataNormalized.csv", sep=delimiter, index=False)


if __name__ == "__main__":
    typer.run(data_normalization)

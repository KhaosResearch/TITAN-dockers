import os

import pandas as pd
import typer


def stadistics33(
    filepath: str = typer.Option(..., help="Name of the csv file"),
    delimiter: str = typer.Option(..., help="Delimtier of the csv file"),
):
    os.chdir("data")
    data = pd.read_csv(filepath, sep=delimiter, index_col=0)

    communities = []

    for com in data.loc["Community"]:
        if com not in communities:
            communities.append(com)

    df_final = pd.DataFrame(index=communities, columns=["Mean Coverage", "Altitude Range", "Altitude Difference"])
    for com in communities:
        n_com = 0
        total_cov = 0
        for col in data.columns:
            if com == data.loc["Community", col]:
                n_com = n_com + 1
                total_cov = total_cov + int(data.loc["Coverage(%)", col])
                df_final.loc[com, "Mean Coverage"] = total_cov / n_com

    for com in communities:
        max_alt = 0
        min_alt = 999999999999999999999999999
        for col in data.columns:
            if com == data.loc["Community", col]:
                if int(data.loc["Altitude(m)", col]) >= max_alt:
                    max_alt = int(data.loc["Altitude(m)", col])
                if int(data.loc["Altitude(m)", col]) < min_alt:
                    min_alt = int(data.loc["Altitude(m)", col])

                df_final.loc[com, "Altitude Range"] = str(max_alt) + "-" + str(min_alt)
                df_final.loc[com, "Altitude Difference"] = max_alt - min_alt

    df_final.to_csv("output_3_3.csv", sep=delimiter)


if __name__ == "__main__":
    typer.run(stadistics33)

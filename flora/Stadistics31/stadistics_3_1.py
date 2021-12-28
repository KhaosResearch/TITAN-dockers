import os

import pandas as pd
import typer


def stadistics_3_1(
    filepath: str = typer.Option(..., help="Name of the csv file"),
    delimiter: str = typer.Option(..., help="Delimiter of the csv"),
):
    os.chdir("data")
    data = pd.read_csv(filepath, sep=delimiter, index_col=0)

    # Calculo de riqueza de cada inventario: Suma de especies presentes
    permanent_columns = [
        "Date",
        "Author",
        "Location",
        "UTM",
        "Lithology",
        "Coverage(%)",
        "Altitude(m)",
        "Plot slope",
        "Alt. Veg. (cm)",
        "Plot area(m2)",
        "Plot orientation",
        "Ecology",
        "Community",
        "Species",
    ]

    df2 = data.drop(axis=0, labels=permanent_columns)

    index_df2 = df2.index

    data.loc["Total_Species", :] = 0

    for i in index_df2:
        for c in data:
            if data.loc[i, c] != "-":
                data.loc["Total_Species", c] += 1

    # Paso de cobertura semicuantitativa a cuantitativa para cada especie: 5=75-100%, 4=50-75%, 3=25-50%, 2=5-25%,
    # 1=2- 5%, +=1%

    for c in data.columns:
        if int(data.loc["Coverage(%)", c]) <= 100 and int(data.loc["Coverage(%)", c]) > 75:
            data.loc["Coverage(%)", c] = "5"
        elif int(data.loc["Coverage(%)", c]) <= 75 and int(data.loc["Coverage(%)", c]) > 50:
            data.loc["Coverage(%)", c] = "4"
        elif int(data.loc["Coverage(%)", c]) <= 50 and int(data.loc["Coverage(%)", c]) > 25:
            data.loc["Coverage(%)", c] = "3"
        elif int(data.loc["Coverage(%)", c]) <= 25 and int(data.loc["Coverage(%)", c]) > 5:
            data.loc["Coverage(%)", c] = "2"
        elif int(data.loc["Coverage(%)", c]) <= 5 and int(data.loc["Coverage(%)", c]) > 1:
            data.loc["Coverage(%)", c] = "1"
        elif int(data.loc["Coverage(%)", c]) == 1:
            data.loc["Coverage(%)", c] = "+"

    # Transformación de la inclinación desde escala hexadecimal a porcentaje
    for c in data.columns:
        data.loc["Plot slope", c] = round((int(data.loc["Plot slope", c]) * 1.6 * 100) / 288, 2)

    # Transformación de la orientación en numérica (N=8, NE=7, NW=6, E=5, W=4, SW=3, SE=2, S=1)
    for c in data.columns:
        if data.loc["Plot orientation", c] == "N":
            data.loc["Plot orientation", c] = "8"
        elif data.loc["Plot orientation", c] == "NE":
            data.loc["Plot orientation", c] = "7"
        elif data.loc["Plot orientation", c] == "NW":
            data.loc["Plot orientation", c] = "6"
        elif data.loc["Plot orientation", c] == "E":
            data.loc["Plot orientation", c] = "5"
        elif data.loc["Plot orientation", c] == "W":
            data.loc["Plot orientation", c] = "4"
        elif data.loc["Plot orientation", c] == "SW":
            data.loc["Plot orientation", c] = "3"
        elif data.loc["Plot orientation", c] == "SE":
            data.loc["Plot orientation", c] = "2"
        elif data.loc["Plot orientation", c] == "S":
            data.loc["Plot orientation", c] = "1"

    # Output.csv
    data.to_csv("output.csv", sep=delimiter, encoding="utf-8-sig")


if __name__ == "__main__":
    typer.run(stadistics_3_1)

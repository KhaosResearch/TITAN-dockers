import base64
import os
from io import BytesIO

import matplotlib as plt
import numpy as np
import pandas as pd
import seaborn as sns
import typer


def clustermap(
    filepath: str = typer.Option(..., help="Name of the csv file"),
    delimiter: str = typer.Option(..., help="Delimiter of the csv file"),
    date_column: str = typer.Option(..., help="The name of the date's column"),
    station_column: str = typer.Option(..., help="The name of the station's column"),
    square_column: str = typer.Option(
        ..., help="The name of the Percentage of Collected Data's column (Color Gradient's Heatmap)"
    ),
    var_color_column: str = typer.Option(
        ..., help="The name of the Percentage of Collected Data's column (Color Gradient's Heatmap)"
    ),
    palette: str = typer.Option(..., help="Colot Palette"),
    standardization: str = typer.Option(..., help="By row (row), By column (column)"),
    nan_filter: str = typer.Option(..., help="Change values by mean column (mean). Delete row with NaN value (drop)"),
):

    os.chdir("data")

    data = pd.read_csv(str(filepath), sep=delimiter, decimal=".")

    if str(standardization).lower() == "row":
        standardization: int = 0
    elif str(standardization).lower() == "column":
        standardization: int = 1
    else:
        print("standardization must be row or column")
        exit()

    if str(nan_filter).lower() == "mean":
        nan_filter: int = 0
    elif str(nan_filter).lower() == "drop":
        nan_filter: int = 1
    else:
        print("nan_filter must be mean or drop")
        exit()

    shape_x = len(set(data[station_column]))
    shape_y = len(set(data[date_column]))

    square_number = (np.asarray(data[square_column].round(1))).reshape(shape_y, shape_x)
    var_number = (np.asarray(data[var_color_column])).reshape(shape_y, shape_x)

    result = data.pivot(index=date_column, columns=station_column, values=square_column)
    if nan_filter == 0:
        result = result.fillna(result.mean())
        result.to_csv("data_pivot_clustermap.csv", sep=",")
    elif nan_filter == 1:
        result = result.dropna(axis=0, how="any")
        result.to_csv("data_pivot_clustermap.csv", sep=",")
    else:
        print(
            """
            The NaN filter must be 0 or 1
        """
        )
        exit()

    g = sns.clustermap(result, standard_scale=standardization, cmap=palette, linewidth=0.50)
    plt.pyplot.setp(g.ax_heatmap.get_yticklabels(), rotation=0)
    plt.pyplot.setp(g.ax_heatmap.get_xticklabels(), rotation=0)

    tmpfile = BytesIO()
    g.savefig(tmpfile, format="png")
    encoded = base64.b64encode(tmpfile.getvalue()).decode("utf-8")
    html = "<img src='data:image/png;base64,{}'>".format(encoded)
    with open("clustermap.html", "w") as f:
        f.write(html)


if __name__ == "__main__":
    typer.run(clustermap)

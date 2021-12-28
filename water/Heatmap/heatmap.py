import base64
import os
from io import BytesIO

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns
import typer


def heatmap(
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
):

    os.chdir("data")

    data = pd.read_csv(str(filepath), sep=delimiter, decimal=".")

    shape_x = len(set(data[station_column]))
    shape_y = len(set(data[date_column]))

    square_number = (np.asarray(data[square_column]).round(1)).reshape(shape_y, shape_x)
    var_number = (np.asarray(data[var_color_column])).reshape(shape_y, shape_x)

    result = data.pivot(index=date_column, columns=station_column, values=var_color_column)
    data2 = data.pivot(index=date_column, columns=station_column, values=square_column)
    labels = data2.round(1).values

    fig, ax = plt.subplots(figsize=(12, 11))
    title = "Heatmap"
    plt.title(title, fontsize=18)
    ttl = ax.title
    ttl.set_position([0.5, 1.05])
    ax.set_xticks([])
    ax.set_yticks([])
    ax.xaxis.tick_top()

    sns.heatmap(
        result,
        annot=labels,
        fmt="",
        cmap=palette,
        linewidth=0.50,
        ax=ax,
        cbar_kws={"label": "Collected Data (%)"},
        vmin=0,
        vmax=100,
        center=50,
    )

    tmpfile = BytesIO()
    fig.savefig(tmpfile, format="png")
    encoded = base64.b64encode(tmpfile.getvalue()).decode("utf-8")
    html = "<img src='data:image/png;base64,{}'>".format(encoded)
    with open("heatmap.html", "w") as f:
        f.write(html)


if __name__ == "__main__":
    typer.run(heatmap)

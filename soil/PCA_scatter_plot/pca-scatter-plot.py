import os

import matplotlib.pyplot as plt
import pandas as pd
import typer


def pca_scatter_plot(
    filepath: str = typer.Option(..., help="Name of the csv file"),
    delimiter: str = typer.Option(..., help="Delimiter of the csv file"),
    x_axis: str = typer.Option(..., help="Name of the x axis"),
    y_axis: str = typer.Option(..., help="Name of th y axis"),
):
    os.chdir("data")

    data = pd.read_csv(str(filepath), sep=delimiter, decimal=".")
    col_1 = str(x_axis)
    col_2 = str(y_axis)

    fig = plt.figure(figsize=(8, 8))
    ax = fig.add_subplot(1, 1, 1)
    ax.set_xlabel(str(col_1), fontsize=15)
    ax.set_ylabel(str(col_2), fontsize=15)
    ax.set_title("PCA Plot", fontsize=20)
    ax.scatter(data.loc[:, str(col_1)], data.loc[:, str(col_2)], s=50)
    ax.legend = None
    ax.grid()
    fig.savefig("PCA_plot.pdf", format="pdf")


if __name__ == "__main__":
    typer.run(pca_scatter_plot)

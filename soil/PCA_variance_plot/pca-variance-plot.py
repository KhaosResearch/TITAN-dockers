import os
import sys

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import typer


def pca_variance_plot(
    filepath: str = typer.Option(..., help="Name of the csv file"),
    delimiter: str = typer.Option(..., help="Delimiter of the csv file"),
):
    os.chdir("data")

    data = pd.read_csv(filepath, sep=delimiter, decimal=".", header=None)
    data.index += 1

    plt.style.use("seaborn-whitegrid")
    fig = plt.figure()
    ax = plt.axes()
    ax.set_xlabel("Number of Components")
    ax.set_ylabel("Variance")
    ax.plot(data, "bo", data, "k")
    plt.xticks(np.arange(0, len(data) + 1, 1.0))
    plt.title("Scree plot")

    fig.savefig("scree_plot.pdf", format="pdf")


if __name__ == "__main__":
    typer.run(pca_variance_plot)

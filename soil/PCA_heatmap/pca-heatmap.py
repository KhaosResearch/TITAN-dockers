import os

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import typer


def pca_heatmap(
    filepath: str = typer.Option(..., help="Name of the csv file"),
    delimiter: str = typer.Option(..., help="Delimiter of the csv file"),
):
    os.chdir("data")

    data = pd.read_csv(str(filepath), sep=delimiter, decimal=".", index_col=0)
    labels = data.values

    fig, ax = plt.subplots(figsize=(12, 11))
    title = "Correlation Matrix"
    plt.title(title, fontsize=18)
    ttl = ax.title
    ttl.set_position([0.5, 1.05])
    sns.heatmap(data, annot=labels, fmt="", cmap="coolwarm", linewidth=0.50, ax=ax, vmin=-1, vmax=1)
    plt.xticks(fontsize=7)
    plt.yticks(fontsize=7)

    fig.savefig("correlation_matrix_heatmap.pdf", format="pdf")


if __name__ == "__main__":
    typer.run(pca_heatmap)

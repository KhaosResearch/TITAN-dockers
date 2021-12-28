import os

import numpy as np
import pandas as pd
import typer
from sklearn.decomposition import PCA


def _dimension_reduction(percentage_variance: list, variance_explained: int = 75):
    cumulative_variance = 0
    n_components = 0
    while cumulative_variance < variance_explained:
        cumulative_variance += percentage_variance[n_components]
        n_components += 1
    return n_components


def pca_component(
    filepath: str = typer.Option(..., help="The name of the csv file"),
    number_components: int = typer.Option(
        ..., help="Number of components desired after the dimension reduction.Default to 2."
    ),
    delimiter: str = typer.Option(..., help="Delimiter of the csv file"),
):
    os.chdir("data")

    data = pd.read_csv(filepath, sep=delimiter, decimal=".")

    number_components = int(number_components)

    corr = data.corr().round(2)
    corr.to_csv("correlation_matrix_heatmap.csv", sep=delimiter)

    pca2 = PCA()
    pca_data2 = pca2.fit_transform(data)
    per_var = np.round(pca2.explained_variance_ratio_ * 100, decimals=1)
    np.savetxt("scree_plot.csv", per_var, delimiter=delimiter)

    if number_components == 0:
        number_components = _dimension_reduction(per_var)

    pca = PCA(n_components=number_components)

    pca_data = pca.fit_transform(data)

    pc_labels = ["PC" + str(x) for x in range(1, number_components + 1)]

    pca_df = pd.DataFrame(data=pca_data, columns=pc_labels)
    pca_df.to_csv("PCA_plot.csv", sep=delimiter, index=False)

    col = []
    for columns in np.arange(number_components):
        col.append("PC" + str(columns + 1))

    loadings = pd.DataFrame(pca.components_.T, columns=col, index=data.columns)
    loadings.to_csv("covariance_matrix.csv", sep=delimiter, index=True)


if __name__ == "__main__":
    typer.run(pca_component)

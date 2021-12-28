import os

import numpy as np
import pandas as pd
import typer
from sklearn.decomposition import PCA


def _dimension_reduction(percentage_variance: list, variance_explained: int):
    cumulative_variance = 0
    n_components = 0
    while cumulative_variance < variance_explained:
        cumulative_variance += percentage_variance[n_components]
        n_components += 1
    return n_components


def pca_variance(
    filepath: str = typer.Option(..., help="Name of the csv file"),
    delimiter: str = typer.Option(..., help="Delimetr of the csv file"),
    variance_explained: int = typer.Option(
        ...,
        help="""The total variace that is want it to be explained by the Principal Components.
                Not needed if we set the number of components. Default to 75.""",
    ),
):
    os.chdir("data")

    data = pd.read_csv(str(filepath), sep=delimiter, decimal=".")

    variance_explained = int(variance_explained)

    corr = data.corr().round(2)
    corr.to_csv("correlation_matrix_heatmap.csv", sep=delimiter)

    pca = PCA()
    pca_data = pca.fit_transform(data)
    per_var = np.round(pca.explained_variance_ratio_ * 100, decimals=1)
    np.savetxt("scree_plot.csv", per_var, delimiter=delimiter)

    number_components = _dimension_reduction(per_var, variance_explained)

    pca = PCA(number_components)
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
    typer.run(pca_variance)

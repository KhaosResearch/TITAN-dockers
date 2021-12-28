import datetime
import os
import re
from typing import List, Optional

import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import pandas as pd 
import numpy as np
import typer

def countNA(
    filepath: str = typer.Option(..., help="Path of file"),
    delimiter: str = typer.Option(..., help="Delimiter of file")):

    os.chdir("data")
    df = pd.read_csv(filepath, sep=delimiter)

    count_na = []
    for i in range(1,len(df.columns)):
        count_na.append(df.iloc[:,i].isna().sum())

    def func(pct, allvals):
        absolute = int(pct/100.*np.sum(allvals))
        return "{:.1f}%\n({:d})".format(pct, absolute)

    with PdfPages('count_na.pdf') as pdf:
        for i in range(0,len(count_na)):
            count_total = [len(df.index)-count_na[i], count_na[i]]
            fig, ax = plt.subplots()
            wedges, texts, autotexts = ax.pie(count_total, autopct=lambda pct: func(pct, count_total), startangle=90)
            ax.legend(wedges, ["Collected data", "NAs"], loc="lower left", bbox_to_anchor=(0.8, 0.7))
            ax.set_title(list(df.columns.values)[i+1])
            ax.axis('equal') 
            pdf.savefig(fig)

if __name__ == "__main__":
    typer.run(countNA)
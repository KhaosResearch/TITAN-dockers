import datetime
import os
import re
from typing import List, Optional

import pandas as pd 
import numpy as np
import typer

def CompleteTimeSeriesSummary(
    file_path_completed: str = typer.Option(..., help="Path of Station completed file"),
    file_path_replaced: str = typer.Option(..., help="Path of file that contains only data which have changed"),
    delimiter_completed: str = typer.Option(..., help="Delimiter of Station completed CSV"),
    delimiter_replaced: str = typer.Option(..., help="Delimiter of data changed CSV")
):

    os.chdir("data")
    df_completed = pd.read_csv(file_path_completed, sep=delimiter_completed)
    df_completed.set_index("DATE")
    df_replace = pd.read_csv(file_path_replaced, sep=delimiter_replaced)
    df_replace.set_index("DATE")

    station_name = list(df_completed.columns)[1]

    def hightlightCompletedData(row):
        ret = ["" for _ in row.index]
        if row.COMPLETED == True:
            ret[row.index.get_loc(station_name)] = "background-color: D59BFF"
        return ret

    equiv = df_completed["DATE"].isin(df_replace["DATE"])

    equiv_list = []
    for elem in equiv: 
        equiv_list.append(elem)

    df_completed["COMPLETED"] = equiv_list

    df_styled = df_completed.style.apply(hightlightCompletedData, axis=1).hide_columns("COMPLETED")

    df_styled.format({station_name: "{:.3f}"})

    df_styled.set_table_styles(
        [{'selector': 'tr:hover',
        'props': [('background-color', '8E17E3')]}, {"selector": "tbody td", "props": [("border", "1px solid grey"), ('text-align', 'center')]}]
    )

    with open("CompleteSeriesSummary.html","w") as fp:
        fp.write(df_styled.render())  

if __name__ == "__main__":
    typer.run(CompleteTimeSeriesSummary)

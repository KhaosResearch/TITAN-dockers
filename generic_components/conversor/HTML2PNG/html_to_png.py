# -*- coding: utf-8 -*-
"""
@author: Daniel Doblas Jiménez
@email: dandobjim@uma.es
"""

import os
from pathlib import Path

import imgkit

#%% Imports and set work directory
import typer


def html2png(filepath: str = typer.Option(..., help="Name of the HTML file")):
    os.chdir("data")

    file_path = Path(filepath)
    file_name = str(file_path.stem) + ".png"

    # Generate file
    with open(file_path) as f:
        imgkit.from_file(str(file_path), file_name)


if __name__ == "__main__":
    typer.run(html2png)

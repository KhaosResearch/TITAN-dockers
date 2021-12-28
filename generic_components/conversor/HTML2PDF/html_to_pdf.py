# -*- coding: utf-8 -*-
"""
@author: Daniel Doblas Jiménez
@email: dandobjim@uma.es
"""

import os

#%% Imports and set work directory
import sys
from pathlib import Path

import pdfkit
import typer


def html2pdf(filepath: str = typer.Option(..., help="Name of the HTML file")):
    os.chdir("data")
    # Inputs
    file_path = Path(filepath)
    # Processing path
    file_name = str(file_path.stem) + ".pdf"
    # Generate file
    with open(file_path) as f:
        pdfkit.from_file(str(file_path), file_name)


if __name__ == "__main__":
    typer.run(html2pdf)

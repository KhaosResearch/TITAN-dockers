import ast
import math
import os

import jinja2
import pandas as pd
import typer

# This dictionary contains all static information about the different
# pollen types. Each Key is the acronym of the polen type as specified
# in the xlsx data.
polen_data = {
    "Arte": {"name": "Artemisia", "allergy": "Moderada", "pollen_class": 2},
    "Cupr": {"name": "Cupresáceas (cipreses)", "allergy": "Moderada", "pollen_class": 4},
    "Olea": {"name": "Olivo", "allergy": "Alta", "pollen_class": 4},
    "Casu": {"name": "Casuarinas", "allergy": "Moderada", "pollen_class": 3},
    "Chen": {"name": "Chenopodiáceas", "allergy": "Moderada", "pollen_class": 2},
    "Plan": {"name": "Llantenes (Plantago)", "allergy": "Moderada", "pollen_class": 2},
    "Poac": {"name": "Gramineas", "allergy": "Alta", "pollen_class": 2},
    "Urti": {"name": "Urticáceas (ortigas, parietarias)", "allergy": "Alta", "pollen_class": 1},
}

# This dict contains the thresholds for the different pollen
# classes as defined here:
# http://www.uco.es/investiga/grupos/rea/wp-content/uploads/2020/05/manual_eng.pdf
pollen_classes = {
    1: {
        "Nil": {"min": 0, "max": 1},
        "Low": {"min": 1, "max": 15},
        "Moderate": {"min": 16, "max": 30},
        "High": {"min": 31, "max": 60},
        "Extreme": {"min": 61, "max": math.inf},
    },
    2: {
        "Nil": {"min": 0, "max": 1},
        "Low": {"min": 1, "max": 25},
        "Moderate": {"min": 26, "max": 50},
        "High": {"min": 51, "max": 100},
        "Extreme": {"min": 101, "max": math.inf},
    },
    3: {
        "Nil": {"min": 0, "max": 1},
        "Low": {"min": 1, "max": 30},
        "Moderate": {"min": 31, "max": 50},
        "High": {"min": 51, "max": 100},
        "Extreme": {"min": 101, "max": math.inf},
    },
    4: {
        "Nil": {"min": 0, "max": 1},
        "Low": {"min": 1, "max": 50},
        "Moderate": {"min": 51, "max": 200},
        "High": {"min": 201, "max": 400},
        "Extreme": {"min": 401, "max": math.inf},
    },
}


def _render_template(data: dict):
    """
    Generates the html output of a jinja template rendered with `data`
    """
    templateLoader = jinja2.FileSystemLoader(searchpath="/usr/local/src/")
    templateEnv = jinja2.Environment(loader=templateLoader)
    template = templateEnv.get_template("aerobiology.html.jinja")
    return template.render(data)


def get_color(pollen_id: str, pollen_level: int):
    """
    Gets the concentration level color for a given pollen of
    a given level
    """
    pollen_class = polen_data[pollen_id]["pollen_class"]
    class_data = pollen_classes[pollen_class]

    if pollen_level < class_data["Nil"]["max"]:
        return "gris"
    elif class_data["Low"]["min"] < pollen_level < class_data["Low"]["max"]:
        return "verde"
    elif class_data["Moderate"]["min"] < pollen_level < class_data["Moderate"]["max"]:
        return "naranja"
    elif class_data["High"]["min"] < pollen_level < class_data["High"]["max"]:
        return "rojo"
    else:  # pollen_level is higher than twice the High category
        return "negro"


def render_html(
    filepath: str = typer.Option(..., help="Name of the xlsx file"),
    forecast: str = typer.Option(..., help="Pairs of key (the same as the xlsx) and its forecasts. Example: {'Olea': 'Alza', 'Poac': 'Estable'}"),
    station: str = typer.Option(..., help="Name of the data's station. Example: 'Estación ____'"),
    title_date: str = typer.Option(..., help="Title message including the date. Example: 'Datos del _ al _ de _ de _ y pronóstico'"),
    summary_sheet: str = typer.Option(..., help=" Name of the xlsx sheet that includes the summay. Defaults to 'Resumen'"),
):
    os.chdir("data")
    xlsx_sheet = pd.read_excel(filepath, sheet_name=summary_sheet)
    # Removing Nan data
    xlsx_sheet = xlsx_sheet.dropna(how="all")

    # Add forecast to polen_data
    forecast = ast.literal_eval(forecast)
    for polen in forecast:
        polen_data[polen]["forecast"] = forecast[polen]

    # Generating color coded table
    week = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    for polen in polen_data:
        week_level = xlsx_sheet[polen]
        for i, day in enumerate(week):
            polen_data[polen][day] = get_color(polen, week_level[i])

    template_data = {"polen_data": polen_data, "station": station, "title_date": title_date}
    html_string = _render_template(template_data)

    # creates `output.html`
    with open("pollen_prediction.html", "w", encoding='utf-8') as f_out:
        f_out.write(html_string)


if __name__ == "__main__":
    typer.run(render_html)

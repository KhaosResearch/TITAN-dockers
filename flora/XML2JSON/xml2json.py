import json
import os
import re

import typer
import untangle


def resetJsonDict():
    json_D = {
        "No_Register": "",
        "Date": "",
        "Authors": "",
        "Location": "",
        "UTM": "",
        "Lithology": "",
        "Coverage(%)": "",
        "Altitude(m)": "",
        "Plot_Slope": "",
        "Alt_Veg_(cm)": "",
        "Plot_Area(m2)": "",
        "Plot_Orientation": "",
        "Ecology": "",
        "Community": "",
        "Species": [],
    }

    return json_D


def filterPlotArea(distance):
    items = []
    match = re.match(r"([0-9]+)([a-z]+)", distance, re.I)
    if match:
        items = match.groups(1)
        if items[1] == "Km":
            return int(items[0]) * (10 ** 6)
        elif items[1] == "m":
            return int(items[0])
    else:
        return 0


def xml2json(filepath: str = typer.Option(..., help="Name of the XML file")):
    os.chdir("data")
    doc = untangle.parse(filepath)
    json_list = []
    for rel in doc.ReleveTable.Releve:
        json_dict = resetJsonDict()
        json_dict["No_Register"] = rel["name"]
        json_dict["Authors"] = rel.BibliographicReference.WorkAuthors.cdata
        json_dict["Date"] = "01/01/" + str(rel.BibliographicReference.WorkPublicationYear.cdata)
        json_dict["Lithology"] = ""
        json_dict["Plot_Area(m2)"] = filterPlotArea(rel.CitationCoordinate["units"])

        if hasattr(rel.SideData[1], "Datum"):
            for sd1 in rel.SideData[1].Datum:
                if sd1["label"] == "Locality":
                    json_dict["Location"] = sd1.value.cdata
                elif sd1["label"] == "Altitude":
                    json_dict["Altitude"] = sd1.value.cdata
                elif sd1["label"] == "Inclination":
                    json_dict["Plot_Slope"] = sd1.value.cdata

        if hasattr(rel.SideData[2], "Datum"):
            for sd2 in rel.SideData[2].Datum:
                if sd2["label"] == "Total Cover (%)":
                    json_dict["Coverage(%)"] = sd2.value.cdata
                elif sd2["label"] == "Shrub Height (m)":
                    json_dict["Alt_Veg_(cm)"] = sd2.value.cdata

        if hasattr(rel, "ReleveEntry"):
            for sp in rel.ReleveEntry:
                if sp["accepted_name"]:
                    json_dict["Species"].append({"name": sp["accepted_name"], "ind": sp["value"]})
                else:
                    json_dict["Species"].append({"name": sp["original_name"], "ind": sp["value"]})

        json_list.append(json_dict)

    with open("inventory.json", "w", encoding="utf8") as f:
        json.dump(json_list, f)


if __name__ == "__main__":
    typer.run(xml2json)

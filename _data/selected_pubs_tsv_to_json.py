import os.path

import compress_json
import pandas as pd

if __name__ == "__main__":

    df = pd.read_csv(os.path.abspath("selected_publications_table.tsv"), sep="\t", keep_default_na=False)

    selected_pubs = []
    for i, row in df.iterrows():
        if row["highlight"]:
            row = dict(row)
            row["authors"] = [a.strip().replace("Renee", "Renée") for a in row["authors"].split(",")]
            selected_pubs.append(dict(row))

    compress_json.dump(
        selected_pubs,
        os.path.abspath("selected_publications.json"),
        json_kwargs={"indent": 2},
    )

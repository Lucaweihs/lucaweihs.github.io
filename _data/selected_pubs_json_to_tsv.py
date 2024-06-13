import os.path

import compress_json
import pandas as pd

if __name__ == "__main__":
    projs = compress_json.load(os.path.abspath("selected_publications.json"))

    entries = []
    for p in projs:
        e = {
            "title": p["title"],
            "year": max(map(int, p["years"])),
            "authors": ", ".join(p["authors"]),
            "venue": next((v for v in p["venues"] if v.lower() != "arxiv"), "arXiv"),
            "url": p["url"],
            "thumbnail": p["thumbnail"],
        }

        if "code" in p:
            github_url = next((u for u in p["code"]["urls"] if "github" in u), None)
            if github_url is not None:
                e["code_url"] = github_url
            else:
                e["code_url"] = p["code"]["urls"][0]

        entries.append(e)

    pd.DataFrame(entries).to_csv(os.path.abspath("_data/selected_publications_tmp.tsv"), sep="\t", index=False)
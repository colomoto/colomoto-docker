import glob
import json
import operator
import os

import markdown_it
from mdit_py_plugins.front_matter import front_matter_plugin
import yaml

MD_PARSER = markdown_it.MarkdownIt("gfm-like").use(front_matter_plugin)

REQUIRED = [
    "name",
    "homepage",
    "release_url",
    "interface",
    "summary",
]

rootdir = os.path.dirname(os.path.dirname(__file__))
tooldir = os.path.join(rootdir, "tools")

##
## Parse metadata
##
REG = {}
for toolmd in glob.glob(f"{tooldir}/*.md"):
    toolid = os.path.basename(toolmd)[:-3]
    if toolid in ["TEMPLATE", "index"]:
        continue
    with open(toolmd) as f:
        t = MD_PARSER.parse(f.read())
    meta = yaml.safe_load(t[0].content)
    if not meta:
        raise KeyError(f"missing metadata for {toolid}")
    for r in REQUIRED:
        if r not in meta:
            raise KeyError(f"{toolid} is missing metadata {r}")
    REG[toolid] = meta

def sorted_tools():
    return sorted(REG.items(), key=lambda i: i[1]["name"].lower())


##
## Generate release_changes.json
##
RC = {}
for toolid, meta in REG.items():
    RC[toolid] = {
        "name": meta["name"].replace("\\.", "."),
        "description": meta["summary"],
        "release_url": meta["release_url"]}
    if "pyface_package" in meta:
        RC[meta["pyface_package"]] = {
                "name": meta["pyface_name"],
                "description": f"Python interface to {meta['name']}",
                "release_url": meta["pyface_release_url"]}

RC = dict(sorted(RC.items(), key=operator.itemgetter(0)))

with open(os.path.join(rootdir, "hooks", "release_changes.json"), "w") as fp:
    json.dump(RC, fp, indent=4, sort_keys=False)

##
## Generate tools/index.md
##

with open(os.path.join(rootdir, "tools", "index.md"), "w") as fp:
    print("""# List of embedded tools

The CoLoMoTo Docker image provides access to the following softwares:

| Software tool | Homepage | Description | Jupyter interface |
| --- | --- | --- | --- |""", file=fp)
    keys = ["name", "homepage", "summary", "interface"]
    for toolid, meta in sorted_tools():
        print("|", " | ".join(meta[k] for k in keys), "|", file=fp)

##
## Generate docs/_toc.yml
##

chapters = [{"file": "tools/index"}]
for toolid, meta in sorted_tools():
    pattern = ''.join(f'[{c.lower()}{c.upper()}]' if c.isalpha() else c for c in toolid)
    chapters.append({
        "file": f"tools/{toolid}",
        "sections": [{"glob": f"tutorials/{pattern}/*"}]
    })

with open("docs/_toc.yml") as fp:
    toc = yaml.safe_load(fp.read())

i = [i for i, p in enumerate(toc["parts"]) if p["caption"] == "Software tools"][0]
toc["parts"][i]["chapters"] = chapters

with open("docs/_toc.yml", "w") as fp:
    fp.write(yaml.safe_dump(toc))

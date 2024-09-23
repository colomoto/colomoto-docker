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


##
## Generate release_changes.json
##
RC = {}
for toolid, meta in REG.items():
    RC[toolid] = {
        "name": meta["name"],
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
    for toolid, meta in sorted(REG.items(), key=lambda i: i[1]["name"].lower()):
        print("|", " | ".join(meta[k] for k in keys), "|", file=fp)

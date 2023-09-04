import json
import os
import re

x = re.compile(r"^RUN\b((?:.+\\\n)*.+[^\\]$)", re.M)
y = re.compile(r"(?<=conda\sinstall\b)([^&]+)", re.S|re.M)
c = re.compile(r"-c\s([^\s]+)")
w = re.compile(r"[^\\\s]+")

def get_pkgs(lines, cfg):
    pkgs = []
    g = {"ignore_next": False}
    def handle_arg(m):
        arg = m.group(0)
        if arg[0] == "-" or g["ignore_next"] or arg in ["nomkl"]:
            pass
        else:
            if "=" not in arg:
                return
            if "::" in arg:
                arg = arg.split("::")[1]
            pkg = arg.split("=")[:2]
            pkgs.append(tuple(pkg))
            ret = arg
        g["ignore_next"] = arg in ["-c"]
    def handle_install(lines):
        w.sub(handle_arg, lines.group(1))
    def handle_run(m):
        lines = m.group(0)
        y.sub(handle_install, m.group(1))
    x.sub(handle_run, lines)
    return pkgs

if __name__ == "__main__":
    inpfile = "Dockerfile"
    cfgfile = __file__.replace(".py", ".json")
    TAG = os.getenv("TAG")
    IMAGE_NAME = os.getenv("IMAGE")
    with open(cfgfile) as fp:
        cfg = json.load(fp)
    with open(inpfile) as f:
        data = f.read()
    pkgs = get_pkgs(data, cfg)
    print(f"""Fetch and run this image using
```
pip install -U colomoto-docker
colomoto-docker -V {TAG}
```

## Packages

| Package | Version | Description |
| --- | --- | --- |""")
    for pkg, version in sorted(pkgs):
        if pkg not in cfg:
            continue
        pkg_cfg = cfg[pkg]
        name = pkg_cfg.get("name",pkg)
        release_url = pkg_cfg.get("release_url","").format(version)
        if release_url:
            version = "[{version}]({release_url})".format(
                version=version,
                release_url=release_url)
        desc = pkg_cfg.get("description","N/A")
        print("| {name} | {version} | {description} |".format(
            name=name,
            description=desc,
            version=version))


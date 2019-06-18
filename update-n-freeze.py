
"""
TODO:
- implement explicit version and build ordering
"""
import json
import re

from urllib.request import urlopen
from urllib.error import HTTPError

x = re.compile(r"^RUN\b((?:.+\\\n)*.+[^\\]$)", re.M)
y = re.compile(r"(?<=conda\sinstall\b)([^&]+)", re.S|re.M)
c = re.compile(r"-c\s([^\s]+)")
w = re.compile(r"[^\\\s]+")

def get_latest_version(pkg, channels, cfg):
    bad_deps = set(cfg.get("blacklist-dependencies", []))
    bad_builds = re.compile("({})".format("|".join(\
            cfg["blacklist-builds"]))) if "blacklist-builds" in cfg \
                else None
    for channel in channels:
        parts = channel.split("/")
        channel = parts[0]
        label = parts[2] if len(parts) == 3 and parts[1] == "label" \
                else "main"
        print("# {}: trying {} with label {}".format(pkg, channel, label))
        try:
            with urlopen("http://api.anaconda.org/package/{}/{}"\
                    .format(channel, pkg)) as fd:
                if fd.getcode() == 404:
                    continue
                data = json.load(fd)
                # index by version, then build with os and label filter
                builds = {}
                for f in data["files"]:
                    if label not in f["labels"]:
                        continue
                    if f["attrs"]["platform"] is not None:
                        if f["attrs"]["platform"] != "linux":
                            continue
                        if f["attrs"]["machine"] != "x86_64":
                            continue
                    v = f["version"]
                    b = f["attrs"]["build"]
                    if b.startswith("py") \
                        and not b.startswith("py_") \
                        and not b.startswith(cfg["pybuild"]):
                        continue
                    if bad_builds and bad_builds.match(b):
                        continue
                    if bad_deps and f["dependencies"]:
                        bad = False
                        for dep in f["dependencies"]["depends"]:
                            if dep["name"] in bad_deps:
                                bad = True
                                break
                        if bad:
                            continue
                    if v not in builds:
                        builds[v] = set()
                    builds[v].add(b)
                print(builds)
                for v in reversed(data["versions"]):
                    for b in reversed(data["builds"]):
                        if v in builds and b in builds[v]:
                            print("### found {}, {}".format(v, b))
                            return "{}={}".format(v, b)
        except HTTPError:
            continue
    raise ValueError

def update_and_freeze(lines, cfg):
    ignore_next = False
    custom_channels = []

    def handle_arg(m):
        global ignore_next
        arg = m.group(0)
        if arg[0] == "-" or ignore_next or arg in ["nomkl"]:
            ret = arg
        else:
            pkg = arg.split("=")[0]
            if pkg in cfg["override"]:
                v = cfg["override"][pkg]
            else:
                channels = custom_channels + cfg["channels"]
                if pkg in cfg.get("force-channel", {}):
                    channels = [cfg["force-channel"][pkg]]

                v = get_latest_version(pkg, channels, cfg)
            ret = "%s=%s" % (pkg, v)
        if arg in ["-c"]:
            ignore_next = True
        else:
            ignore_next = False
        return ret

    def handle_install(lines):
        custom_channels.clear()
        custom_channels.extend(c.findall(lines.group(1)))
        return w.sub(handle_arg, lines.group(1))

    def handle_run(m):
        lines = m.group(0)
        return "%s%s" %  (lines[:m.start(1)-m.start(0)],
            y.sub(handle_install, m.group(1)))

    return x.sub(handle_run, lines)

if __name__ == "__main__":
    inpfile = "Dockerfile"
    cfgfile = "update-n-freeze.json"
    cfg = {}
    if cfgfile:
        with open(cfgfile) as fp:
            cfg = json.load(fp)
    if "channels" not in cfg:
        cfg["channels"] = []
    if "override" not in cfg:
        cfg["override"] = {}
    with open(inpfile) as f:
        data = f.read()
    data = update_and_freeze(data, cfg)
    with open(inpfile, "w") as fp:
        fp.write(data)


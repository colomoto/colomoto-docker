from py4j.java_gateway import JavaGateway, GatewayParameters

from subprocess import PIPE
import subprocess

proc = None
gw = None


def GINsim(java_cmd="java", jar_path="git/ginsim-dev/target/GINsim-2.9.6-SNAPSHOT.jar"):
    "Launch in background a GINsim instance running the python gateway"
    close()
    
    global proc, gw
    # Start the gateway and read the selected dynamical port
    proc = subprocess.Popen([java_cmd, "-jar", jar_path, "-py"], stdout=PIPE, stdin=PIPE)
    port = int(proc.stdout.readline().strip())
    
    # start the gateway and return the entry point (GINsim's ScriptLauncher)
    param = GatewayParameters(port=port)
    gw = JavaGateway(gateway_parameters=param)
    
    return gw.entry_point


def close():
    "close the running GINsim if any"
    
    global proc, gw
    if proc and gw:
        print("cleanup")
        gw.shutdown()
        proc.terminate()
        proc = None
        gw = None

import atexit
atexit.register(close)


if __name__ == "__main__":
    gs = GINsim()
    print(gs)



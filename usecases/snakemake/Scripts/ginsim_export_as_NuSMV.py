# Author: CoLoMoTo
# Affiliation: CoLoMoTo
# Aim: Export a GINsim model into NuSMV-compatible format.
# Date: 20/07/2017

# Example of a CL
# java -Xmx1G -jar GINsim-2.9.4-with-deps.jar -s ginsim_export_as_NuSMV.py model.zginml ./model.smv


from pprint import pprint

# Get the GINsim file (first argument), and read GINsim model data from it
g = gs.open(gs.args[0])

# Get the model
model = g.getModel()

# Get the NuSMV service
nusmvs = gs.service("NuSMV")

# Create the NuSMV configuration
# http://doc.ginsim.org/devel/apidocs/index.html?org/ginsim/service/export/nusmv/NuSMVConfig.html
from org.ginsim.service.export.nusmv import NuSMVConfig
nusmvconfig = NuSMVConfig(g)

# Set "asynchronous" export
nusmvconfig.setUpdatePolicy(NuSMVConfig.CFG_ASYNC)

# Set "export stable states"
nusmvconfig.setExportStableStates(True)

# Add all input nodes as fixed inputs
# Get initial state from GINsim data
sinit = gs.associated(g, "initialState", True) 
# Get node names from initial state
inputNodeNames = [str(nodeInfo) for nodeInfo in sinit.getInputNodes()]
# Add each input node as fixed input in NuSMV configuration
for inputNode in inputNodeNames:
	nusmvconfig.addFixedInput(inputNode) 

# Run export service
nusmvfilename = gs.args[1]
nusmvs.run(nusmvconfig, nusmvfilename)

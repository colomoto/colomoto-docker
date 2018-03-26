# Author: CoLoMoTo
# Affiliation: CoLoMoTo
# Aim: Export a GINsim model into NuSMV-compatible format.
# Date: 20/07/2017

# Example of a CL
# python3 ginsim_export_as_NuSMV.py model.zginml ./model.smv

import sys
import ginsim
import biolqm
from shutil import copyfile

# Load a model
model = ginsim.load(sys.argv[1])

# Convert model to NuSMV
s = ginsim.to_nusmv(model)

# Export converted model
copyfile(s.input_smv, sys.argv[2])

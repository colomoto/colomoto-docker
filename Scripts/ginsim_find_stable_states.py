# Author: CoLoMoTo
# Affiliation: CoLoMoTo
# Aim: Find the stable states of a GINsim model.
# Date: 20/07/2017

# Example of a CL
# java -Xmx1G -jar GINsim-2.9.6-with-deps.jar -s ginsim_find_stable_states.py model.zginml


# Get the GINsim file (first argument), and read GINsim model data from it
g = gs.open(gs.args[0])

# Get the model
model = g.getModel()

# Get tool to find the Stable States
toolStable = lqm.getTool("stable")

# Run the tool
toolStable.run(model, ("",))

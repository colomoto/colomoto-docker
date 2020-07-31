#!/bin/bash

do_cellcollective=true
strict=true

lopts="help"
lopts="${lopts},allow-errors"
lopts="${lopts},skip-cellcollective"

usage() {
        echo "
Usage: $0 [opts]

Options:
    --allow-errors              allow errors during execution
    --skip-cellcollective       skip CellCollective tests
"
}

NB_OPTS=("--ExecutePreprocessor.timeout=300")

argv="$(getopt --longoptions $lopts -- "${0}" "${@}")"
if [ $? -ne 0 ]; then
    usage
    exit 1
fi
eval set -- $argv

while [ -n "${1:-}" ]; do
    case "${1:-}" in
        --help)
            usage
            exit 1 ;;
        --skip-cellcollective)
            echo "WARNING: Skipping cellcollective tests"
            NB_OPTS+=("--TagRemovePreprocessor.remove_cell_tags={'cellcollective'}")
            do_cellcollective=false ;;
        --allow-errors)
            echo "WARNING: Strict mode disabled"
            strict=false
            NB_OPTS+=("--allow-errors") ;;
    esac
    shift
done

if $strict; then
    set -e
fi

set -x
validate_nb() {
    _nb="$1"
    jupyter nbconvert --execute "${_nb}" --stdout "${NB_OPTS[@]}" >/dev/null
}

test_nb=()
test_nb+=("tutorials/Reproducibility - fixpoints.ipynb")
test_nb+=("tutorials/Reproducibility - model checking.ipynb")
test_nb+=("tutorials/ActoNet/ActoNet_Bladder.ipynb")
test_nb+=("tutorials/bioLQM/bioLQM_tutorial.ipynb")
test_nb+=("tutorials/bioLQM/Layout for regulatory graph.ipynb")
test_nb+=("tutorials/boolSim/boolSim - attractors.ipynb")
test_nb+=("tutorials/boolSim/boolSim - reachable.ipynb")
test_nb+=('tutorials/CABEAN/CABEAN_Myeloid_reprogramming.ipynb')
test_nb+=("tutorials/Caspo/Caspo-control_Bladder.ipynb")
if $do_cellcollective; then
    test_nb+=("tutorials/CellCollective/CellCollective - Knowledge Base.ipynb")
fi
test_nb+=("tutorials/GINsim/GINsim - visualization")
test_nb+=("tutorials/MaBoSS/Toy Example.ipynb")
test_nb+=("tutorials/MaBoSS/MaBoSS - Quick tutorial.ipynb")
test_nb+=("tutorials/MaBoSS/Predict mutations with Pint, refine with MaBoSS.ipynb")
test_nb+=("tutorials/mpbn/Bladder_Remy2015.ipynb")
test_nb+=("tutorials/mpbn/Quick_example.ipynb")
test_nb+=("tutorials/mpbn/TumourInvasion_Cohen2015.ipynb")
test_nb+=("tutorials/minibn/Model creation and edition with minibn.ipynb")
test_nb+=("tutorials/minibn/Simulations with minibn.ipynb")
test_nb+=("tutorials/NuSMV/NuSMV with GINsim.ipynb")
test_nb+=("tutorials/Pint/quick-tutorial.ipynb")
test_nb+=("tutorials/PyBoolNet/PyBoolNet_tutorial.ipynb")
test_nb+=("tutorials/R-BoolNet/Random BN generation, loading with biolqm or minibn.ipynb")
test_nb+=("tutorials/StableMotifs/StableMotifs_Myeloid.ipynb")
test_nb+=("tutorials/CaSQ/CaSQ_from_CellDesigner_to_GINsim.ipynb")

if [ -n "${DOCKER_IMAGE}" ]; then
    echo
    echo "Running within ${DOCKER_IMAGE} (commit ${DOCKER_SOURCE_COMMIT}) built on ${DOCKER_BUILD_DATE}"
    echo
fi
for nb in "${test_nb[@]}"; do
    echo "======= Testing $nb"
    validate_nb "${nb}"
done

if $strict; then
    echo "*** SUCCESS ***"
fi


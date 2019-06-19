#!/bin/bash

set -e

validate_nb() {
    _nb="$1"
    _output="/tmp/tmp.OYN0z4DZco.colomoto-test.ipynb"
    jupyter nbconvert --execute "${_nb}" --to notebook --output $_output \
        --ExecutePreprocessor.timeout=300
    rm -f $_output
}

test_nb=()
test_nb+=("tutorials/Reproducibility - fixpoints.ipynb")
test_nb+=("tutorials/Reproducibility - model checking.ipynb")
test_nb+=("tutorials/bioLQM/bioLQM_tutorial.ipynb")
test_nb+=("tutorials/CellCollective/CellCollective - Knowledge Base.ipynb")
test_nb+=("tutorials/GINsim/GINsim - visualization")
test_nb+=("tutorials/MaBoSS/Toy Example.ipynb")
test_nb+=("tutorials/MaBoSS/MaBoSS - Quick tutorial.ipynb")
test_nb+=("tutorials/MaBoSS/Predict mutations with Pint, refine with MaBoSS.ipynb")
test_nb+=("tutorials/Model creation and edition with minibn.ipynb")
test_nb+=("tutorials/NuSMV/NuSMV with GINsim.ipynb")
test_nb+=("tutorials/Pint/quick-tutorial.ipynb")
test_nb+=("tutorials/R-BoolNet/Random BN generation, loading with biolqm or minibn.ipynb")
test_nb+=("usecases/Usecase - Mutations enabling tumour invasion.ipynb")
test_nb+=("usecases/Usecase - Balance of Th17 vs Treg cell populations.ipynb")

for nb in "${test_nb[@]}"; do
    echo "======= Testing $nb"
    validate_nb "${nb}"
done

echo "*** SUCCESS ***"


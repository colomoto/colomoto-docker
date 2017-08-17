

# put GINsim jar in conda's opt folder and the launcher in bin
mkdir -p "$PREFIX/opt"
cp "${SRC_DIR}/GINsim-${PKG_VERSION}-SNAPSHOT-jar-with-dependencies.jar" "$PREFIX/opt/GINsim.jar"

cp "${RECIPE_DIR}/GINsim" "$PREFIX/bin"
chmod +x "$PREFIX/bin/GINsim"


cd "${RECIPE_DIR}/python"
$PYTHON setup.py install



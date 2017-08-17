
# can't build from source with conda's old gcc
cmake .
make

# When building from source: enter the bin output folder
cd bin

# Just copy the clingo binary
cp -p clasp clingo gringo lpconvert reify "$PREFIX/bin"

# depending on build options, also copy the shared library (libclingo.so)
cp -p lib*.so* "$PREFIX/lib"



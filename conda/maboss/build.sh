

cd engine/src
make install
make MAXNODES=128 install
make MAXNODES=256 install
mv ../pub/MaBoSS* ${PREFIX}/bin
cd ../..
mkdir -p "${PREFIX}/opt/MaBoSS"
mv tools doc tutorial examples ${PREFIX}/opt/MaBoSS/



set -e

cd bddisasm

mkdir -p build
cd build

cmake ..
sudo make install

cd ..
cd ..

mkdir -p build
cd build

cmake ..
make

./bddisasm_sample
./bdshemu_sample

cd ..

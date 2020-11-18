set -e

echo "\n[+] Using bddisasm as a subdirectory..."
cmake -B build/subdir . -DUSE_SUBDIR=ON
cmake --build build/subdir
./build/subdir/bddisasm_sample
./build/subdir/bdshemu_sample

echo "\n[+] Building and installing bddisasm..."
cmake -B bddisasm/build bddisasm
cmake --build bddisasm/build
sudo cmake --build bddisasm/build --target install

echo "\n[+] Checking pkg-config..."
pkg-config --cflags --libs libbddisasm

echo "\n[+] Building the samples using pkg-config to find bddisasm and bdshemu..."
cmake -B build/pkgconfig . -DUSE_PKGCONFIG=ON
cmake --build build/pkgconfig
./build/pkgconfig/bddisasm_sample
./build/pkgconfig/bdshemu_sample

echo "\n[+] Building the samples without using pkg-config to find bddisasm and bdshemu..."
cmake -B build/package . -DUSE_PKGCONFIG=OFF
cmake --build build/package
./build/package/bddisasm_sample
./build/package/bdshemu_sample

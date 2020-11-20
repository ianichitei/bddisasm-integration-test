set -e

echo "\n[+] Installing bddisasm from a package..."
cmake -B bddisasm/build bddisasm -DCMAKE_INSTALL_PREFIX=/usr
cmake --build bddisasm/build --target package
# Kinda hacky
sudo dpkg -i `ls bddisasm/build/*deb`

echo "\n[+] Checking pkg-config..."
pkg-config --cflags --libs libbddisasm

echo "\n[+] Building the samples using pkg-config to find bddisasm and bdshemu..."
cmake -B build/pkgconfig . -DUSE_PKGCONFIG=ON
cmake --build build/pkgconfig
./build/pkgconfig/bddisasm_sample
./build/pkgconfig/bdshemu_sample

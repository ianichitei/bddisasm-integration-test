set -e

echo "\n[+] Using bddisasm as a subdirectory..."
cmake -B build/subdir . -DUSE_SUBDIR=ON
cmake --build build/subdir
./build/subdir/bddisasm_sample
./build/subdir/bdshemu_sample

# Cleanup the bddisasm build dirs
rm -rf bin
rm -rf bddisasm/build

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

echo "\n[+] Setting up vcpkg..."
cd vcpkg
./bootstrap-vcpkg.sh
./vcpkg install bddisasm
cd -

echo "\n[+] Building the samples using vcpkg on Debug..."
cmake -B build/vcpkg/Debug . -DUSE_PKGCONFIG=OFF -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_TOOLCHAIN_FILE=./vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build build/vcpkg/Debug
./build/vcpkg/Debug/bddisasm_sample
./build/vcpkg/Debug/bdshemu_sample

echo "\n[+] Building the samples using vcpkg on Release..."
cmake -B build/vcpkg/Release . -DUSE_PKGCONFIG=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build build/vcpkg/Release
./build/vcpkg/Release/bddisasm_sample
./build/vcpkg/Release/bdshemu_sample

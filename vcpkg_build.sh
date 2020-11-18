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

#!/bin/bash

set -e

# As a subdirectory.
cmake -B build/subdir . -DUSE_AS=subdir
cmake --build build/subdir

# With an installed copy.
echo "\nBuilding and installing bddisasm..."
cmake -B bddisasm/build bddisasm -DCMAKE_INSTALL_PREFIX=./install-dir
cmake --build bddisasm/build --target install

cmake -B build/installed . -DUSE_AS=installed -DBDDISASM_INSTALL_PATH=./install-dir
cmake --build build/installed

# With an installed copy in a path with spaces.
echo "\nBuilding and installing bddisasm in a path with spaces..."
cmake -B bddisasm/build_spaces bddisasm -DCMAKE_INSTALL_PREFIX="./install dir"
cmake --build bddisasm/build_spaces --target install

cmake -B build/installed_spaces . -DUSE_AS=installed -DBDDISASM_INSTALL_PATH="./install dir"
cmake --build build/installed_spaces

# Using VCPKG
echo "\nInstalling bddisasm with vcpkg"
cd vcpkg
./vcpkg install bddisasm:x64-linux
cd ..

echo "\nBuilding with vcpkg dependency"
cmake -B build/vcpkg . -DUSE_AS=vcpkg -DCMAKE_TOOLCHAIN_FILE=./vcpkg/scripts/buildsystems/vcpkg.cmake
cmake --build build/vcpkg

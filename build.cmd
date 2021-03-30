@echo off

REM As a subdirectory.
cmake -B build/subdir . -DUSE_AS=subdir -G Ninja -DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build build/subdir --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

REM With an installed copy.
echo "Building and installing bddisasm..."
cmake -B bddisasm/build bddisasm -DCMAKE_INSTALL_PREFIX=./install-dir -G Ninja -DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build bddisasm/build --target install
if %errorlevel% neq 0 exit /b %errorlevel%

cmake -B build/installed . -DUSE_AS=installed -DBDDISASM_INSTALL_PATH=./install-dir -G Ninja -DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build build/installed --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

REM With an installed copy in a path with spaces.
echo "Building and installing bddisasm in a path with spaces..."
cmake -B bddisasm/build_spaces bddisasm -DCMAKE_INSTALL_PREFIX="./install dir" -G Ninja -DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build bddisasm/build_spaces --target install
if %errorlevel% neq 0 exit /b %errorlevel%

cmake -B build/installed_spaces . -DUSE_AS=installed -DBDDISASM_INSTALL_PATH="./install dir" -G Ninja -DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build build/installed_spaces --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

REM Using VCPKG
echo "Installing bddisasm with vcpkg"
cd vcpkg
.\vcpkg.exe install bddisasm:x64-windows
cd ..

echo "Building with vcpkg dependency"
cmake -B build/vcpkg . -DUSE_AS=vcpkg -DCMAKE_TOOLCHAIN_FILE=.\vcpkg\scripts\buildsystems\vcpkg.cmake -G Ninja -DCMAKE_C_COMPILER=cl -DCMAKE_CXX_COMPILER=cl
cmake --build build/vcpkg

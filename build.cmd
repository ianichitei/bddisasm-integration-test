@echo off

REM As a subdirectory.
cmake -B build/subdir . -DUSE_AS=subdir
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build build/subdir --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

REM With an installed copy.
echo "Building and installing bddisasm..."
cmake -B bddisasm/build bddisasm -DCMAKE_INSTALL_PREFIX=./install-dir
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build bddisasm/build --target install
if %errorlevel% neq 0 exit /b %errorlevel%

cmake -B build/installed . -DUSE_AS=installed -DBDDISASM_INSTALL_PATH=./install-dir
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build build/installed --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

REM With an installed copy in a path with spaces.
echo "Building and installing bddisasm in a path with spaces..."
cmake -B bddisasm/build_spaces bddisasm -DCMAKE_INSTALL_PREFIX="./install dir"
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build bddisasm/build_spaces --target install
if %errorlevel% neq 0 exit /b %errorlevel%

cmake -B build/installed_spaces . -DUSE_AS=installed -DBDDISASM_INSTALL_PATH="./install dir"
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build build/installed_spaces --config Release
if %errorlevel% neq 0 exit /b %errorlevel%

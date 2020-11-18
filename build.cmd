@echo off

echo [+] Setting up vcpkg...
call vcpkg\bootstrap-vcpkg.bat
IF NOT %ERRORLEVEL% == 0 goto :failure
call vcpkg\vcpkg integrate install
IF NOT %ERRORLEVEL% == 0 goto :failure
call vcpkg\vcpkg install bddisasm:x86-windows
IF NOT %ERRORLEVEL% == 0 goto :failure
call vcpkg\vcpkg install bddisasm:x64-windows
IF NOT %ERRORLEVEL% == 0 goto :failure

echo [+] Building for Debug x64...
call msbuild msvc\bddisasm_user\bddisasm_user.sln /t:Rebuild /p:Configuration=Debug /p:Platform=x64 /maxcpucount
IF NOT %ERRORLEVEL% == 0 goto :failure
msvc\bddisasm_user\bin\Debug\x64\bddisasm_user.exe
IF NOT %ERRORLEVEL% == 0 goto :failure
call msbuild msvc\bdshemu_user\bdshemu_user.sln /t:Rebuild /p:Configuration=Debug /p:Platform=x64 /maxcpucount
IF NOT %ERRORLEVEL% == 0 goto :failure
msvc\bdshemu_user\bin\Debug\x64\bdshemu_user.exe
IF NOT %ERRORLEVEL% == 0 goto :failure

echo [+] Building for Release x64...
call msbuild msvc\bddisasm_user\bddisasm_user.sln /t:Rebuild /p:Configuration=Release /p:Platform=x64 /maxcpucount
IF NOT %ERRORLEVEL% == 0 goto :failure
msvc\bddisasm_user\bin\Release\x64\bddisasm_user.exe
IF NOT %ERRORLEVEL% == 0 goto :failure
call msbuild msvc\bdshemu_user\bdshemu_user.sln /t:Rebuild /p:Configuration=Release /p:Platform=x64 /maxcpucount
IF NOT %ERRORLEVEL% == 0 goto :failure
msvc\bdshemu_user\bin\Release\x64\bdshemu_user.exe
IF NOT %ERRORLEVEL% == 0 goto :failure

echo [+] Building for Debug x86...
call msbuild msvc\bddisasm_user\bddisasm_user.sln /t:Rebuild /p:Configuration=Debug /p:Platform=x86 /maxcpucount
IF NOT %ERRORLEVEL% == 0 goto :failure
msvc\bddisasm_user\bin\Debug\Win32\bddisasm_user.exe
IF NOT %ERRORLEVEL% == 0 goto :failure
call msbuild msvc\bdshemu_user\bdshemu_user.sln /t:Rebuild /p:Configuration=Debug /p:Platform=x86 /maxcpucount
IF NOT %ERRORLEVEL% == 0 goto :failure
msvc\bdshemu_user\bin\Debug\Win32\bdshemu_user.exe
IF NOT %ERRORLEVEL% == 0 goto :failure

echo [+] Building for Release x86...
call msbuild msvc\bddisasm_user\bddisasm_user.sln /t:Rebuild /p:Configuration=Release /p:Platform=x86 /maxcpucount
IF NOT %ERRORLEVEL% == 0 goto :failure
msvc\bddisasm_user\bin\Release\Win32\bddisasm_user.exe
IF NOT %ERRORLEVEL% == 0 goto :failure
call msbuild msvc\bdshemu_user\bdshemu_user.sln /t:Rebuild /p:Configuration=Release /p:Platform=x86 /maxcpucount
IF NOT %ERRORLEVEL% == 0 goto :failure
msvc\bdshemu_user\bin\Release\Win32\bdshemu_user.exe
IF NOT %ERRORLEVEL% == 0 goto :failure

echo Build Done!
exit /b 0

:failure
exit /b %ERRORLEVEL%

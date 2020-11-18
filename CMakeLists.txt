cmake_minimum_required(VERSION 3.12)

project(bddisasm_sample)

option(USE_PKGCONFIG "Find bddisasm using pkg-config" ON)

add_executable(bddisasm_sample disasm_main.c)
add_executable(bdshemu_sample shemu_main.c)

if (USE_PKGCONFIG)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(BDDISASM REQUIRED libbddisasm)
else ()
    find_package(bddisasm CONFIG REQUIRED)
endif ()

target_include_directories(bddisasm_sample PRIVATE ${BDDISASM_INCLUDE_DIRS})
target_link_directories(bddisasm_sample PRIVATE ${BDDISASM_LIBRARY_DIRS})
target_link_libraries(bddisasm_sample ${BDDISASM_LIBRARIES})

target_include_directories(bdshemu_sample PRIVATE ${BDDISASM_INCLUDE_DIRS})
target_link_directories(bdshemu_sample PRIVATE ${BDDISASM_LIBRARY_DIRS})
target_link_libraries(bdshemu_sample ${BDDISASM_LIBRARIES})

message(STATUS "BDDISASM_INCLUDE_DIRS: ${BDDISASM_INCLUDE_DIRS}")
message(STATUS "BDDISASM_LIBRARY_DIRS: ${BDDISASM_LIBRARY_DIRS}")
message(STATUS "BDDISASM_LIBRARIES: ${BDDISASM_LIBRARIES}")

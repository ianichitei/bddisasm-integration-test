cmake_minimum_required(VERSION 3.12)

project(bddisasm_sample)

option(USE_PKGCONFIG "Find bddisasm using pkg-config" ON)
option(USE_SUBDIR "Use bddisasm as a subdirectory. Ignores USE_PKGCONFIG" OFF)

if (USE_SUBDIR)
    add_subdirectory(bddisasm EXCLUDE_FROM_ALL)
endif ()

add_executable(bddisasm_sample disasm_main.c)
add_executable(bdshemu_sample shemu_main.c)

if (USE_SUBDIR)
    add_dependencies(bddisasm_sample bddisasm)
    add_dependencies(bdshemu_sample bdshemu)

    # This is a bit of a hack.
    target_compile_definitions(bddisasm_sample PRIVATE "USE_SUBDIR")
    target_compile_definitions(bdshemu_sample PRIVATE "USE_SUBDIR")

    target_include_directories(bddisasm_sample PRIVATE ${PROJECT_SOURCE_DIR}/bddisasm/inc)
    target_include_directories(bddisasm_sample PRIVATE ${PROJECT_SOURCE_DIR}/bdshemu/inc)

    target_link_libraries(bddisasm_sample bddisasm)
    target_link_libraries(bdshemu_sample bdshemu bddisasm)
else ()
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
endif ()

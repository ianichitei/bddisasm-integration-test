cmake_minimum_required(VERSION 3.16)

project(bddisasm_sample)

SET(USE_AS "" CACHE STRING "How to consume bddisasm. Supported values: 'subdir', 'installed'")
set(BDDISASM_INSTALL_PATH "" CACHE STRING "Path to the installed bddisasm package")

if (MSVC)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}")
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}")
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}")
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}")
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}")
endif (MSVC)

if (USE_AS STREQUAL "subdir")
    message("Consuming bddisasm as a subdirectory")

    add_subdirectory(bddisasm)
elseif (USE_AS STREQUAL "installed")
    if (BDDISASM_INSTALL_PATH)
        set(CMAKE_PREFIX_PATH "${BDDISASM_INSTALL_PATH}")
    endif (BDDISASM_INSTALL_PATH)
    
    message("Using prefix path: ${CMAKE_PREFIX_PATH}")
    find_package(bddisasm 1.31 COMPONENTS bddisasm_Development)
else ()
    message("USE_AS set to: ${USE_AS}")
    message(FATAL_ERROR "USE_AS must be set to one of the following: 'subdir', 'installed'")
endif ()

add_executable(just-decode common/common.c just-decode/just_decode.c)
target_link_libraries(just-decode PRIVATE bddisasm::bddisasm)

add_executable(just-emulate common/common.c just-emulate/just_emulate.c)
target_link_libraries(just-emulate PRIVATE bddisasm::bdshemu)

add_executable(decode-and-emulate common/common.c decode-and-emulate/decode_and_emulate.c)
target_link_libraries(decode-and-emulate PRIVATE bddisasm::bddisasm bddisasm::bdshemu)

if (NOT MSVC)
    add_custom_target(check-decode COMMAND "${CMAKE_CURRENT_BINARY_DIR}/just-decode")
    add_custom_target(check-emulate COMMAND "${CMAKE_CURRENT_BINARY_DIR}/just-emulate")
    add_custom_target(check-decode-and-emulate COMMAND "${CMAKE_CURRENT_BINARY_DIR}/decode-and-emulate")
else ()
    add_custom_target(check-decode
        COMMAND "just-decode.exe"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    add_custom_target(check-emulate
        COMMAND "just-emulate.exe"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
    add_custom_target(check-decode-and-emulate
        COMMAND "decode-and-emulate.exe"
        WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}")
endif ()

add_dependencies(check-decode just-decode)
add_dependencies(check-emulate just-emulate)
add_dependencies(check-decode-and-emulate decode-and-emulate)

add_custom_target(check ALL)
add_dependencies(check check-decode check-emulate check-decode-and-emulate)

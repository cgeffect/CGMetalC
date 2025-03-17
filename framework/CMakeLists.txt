
cmake_minimum_required(VERSION 3.26.1)
message("--begin avmedia complie---")

set(LIBRARY_NAME cg-render)
project(${LIBRARY_NAME})

set(CMAKE_SYSTEM_PROCESSOR "arm64")
set(CMAKE_OSX_ARCHITECTURES "arm64")
set(CMAKE_OSX_DEPLOYMENT_TARGET "12.0" CACHE STRING "Minimum OS X deployment version")
set(CMAKE_CXX_STANDARD 17)

# list(APPEND libSRV_INCLUDES_DIR ./)
list(APPEND INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../metal-cpp/deploy/include/metal-cpp)
list(APPEND INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../metal-cpp/deploy/include/metal-cpp-extensions)

list(APPEND METAL_CPP_LIB ${CMAKE_CURRENT_SOURCE_DIR}/../metal-cpp/deploy/lib/libMETAL_CPP.a)

# Get all project dir
FILE(GLOB_RECURSE allCPP 
    ${CMAKE_CURRENT_SOURCE_DIR}/render/*.h
    ${CMAKE_CURRENT_SOURCE_DIR}/render/*.cpp
)
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} FILES ${allCPP})

# Create executable and link target
add_executable(${LIBRARY_NAME} ${allCPP})
target_include_directories(${LIBRARY_NAME} PUBLIC ${INCLUDE_DIR})
target_link_libraries(${LIBRARY_NAME} 
    ${METAL_CPP_LIB}
    "-framework Metal"
    "-framework MetalKit"
    "-framework AppKit"
    "-framework Foundation"
    "-framework QuartzCore"
)

message(STATUS "Adding HRender")

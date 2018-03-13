set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

set(CMAKE_FIND_ROOT_PATH "/home/liuzili/opencv-2.4.13/opencv-2.4.13/build")
link_directories(${CMAKE_FIND_ROOT_PATH}/lib)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRAY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


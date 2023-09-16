cmake_minimum_required(VERSION 3.2)

project(ZeroTierOneJNI)

find_package(Java COMPONENTS Development)
message("JAVA_HOME: $ENV{JAVA_HOME}")

if(WIN32)
set(Java_INCLUDE_DIRS $ENV{JAVA_HOME}/include)
endif()

if(APPLE)
set(Java_INCLUDE_DIRS "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/JavaVM.framework/Headers")
endif()

message("Java Include Dirs: ${Java_INCLUDE_DIRS}")

if(WIN32)
    add_definitions(-DNOMINMAX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /EHsc /W3 /MP")
endif()

if(APPLE)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -arch i386 -arch x86_64 -Wall -O3 -flto -fPIE -fvectorize -fstack-protector -mmacosx-version-min=10.7 -Wno-unused-private-field")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_C_FLAGS} -fno-rtti")
endif()

file(GLOB core_src_glob ../node/*.cpp)

set(src_files
    ../osdep/OSUtils.cpp
    jni/com_zerotierone_sdk_Node.cpp
    jni/ZT_jniutils.cpp
    jni/ZT_jnicache.cpp
    )

set(include_dirs
    ${CMAKE_CURRENT_SOURCE_DIR}/../include/
    ${CMAKE_CURRENT_SOURCE_DIR}/../node/
    ${CMAKE_CURRENT_SOURCE_DIR}/../ext/
    ${CMAKE_CURRENT_SOURCE_DIR}/../ext/prometheus-cpp-lite-1.0/core/include/
    ${CMAKE_CURRENT_SOURCE_DIR}/../ext/prometheus-cpp-lite-1.0/simpleapi/include/
    ${Java_INCLUDE_DIRS})

if(WIN32)
    set(include_dirs
        ${include_dirs}
        ${Java_INCLUDE_DIRS}/win32)
endif()

include_directories(
    ${include_dirs}
    )

add_library(${PROJECT_NAME} SHARED ${src_files} ${core_src_glob})

if(APPLE)
    set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".jnilib")
endif()

set(link_libs log)

if(WIN32)
    set(link_libs
        wsock32
        ws2_32

        )
endif()

target_link_libraries(${PROJECT_NAME} ${link_libs})

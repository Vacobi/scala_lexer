cmake_minimum_required(VERSION 3.20)
project(scala_lexer LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(FLEX REQUIRED)

FLEX_TARGET(MyScanner lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp)

add_executable(lexer ${FLEX_MyScanner_OUTPUTS}
        lexer.l)

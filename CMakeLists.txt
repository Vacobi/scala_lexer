cmake_minimum_required(VERSION 3.30)
project(lexer)

set(CMAKE_CXX_STANDARD 20)

find_package(FLEX REQUIRED)

FLEX_TARGET(MyScanner lexer.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c)

add_executable(lexer ${FLEX_MyScanner_OUTPUTS}
        lexer.l)

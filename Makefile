BISON = bison -d -o parser.tab.c grammar/parser.y
FLEX  = flex -o lex.yy.c grammar/lexer.l
CXX   = g++
CXXFLAGS = -std=c++17 -g

all: rust_parser

parser.tab.c parser.tab.h: grammar/parser.y
	$(BISON)

lex.yy.c: grammar/lexer.l parser.tab.h
	$(FLEX)

rust_parser: parser.tab.c lex.yy.c src/main.cpp src/ast.cpp
	$(CXX) $(CXXFLAGS) parser.tab.c lex.yy.c src/main.cpp src/ast.cpp -o rust_parser
clean:
	rm -f grammar/parser.tab.* grammar/lex.yy.c rust_parser

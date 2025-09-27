#include <iostream>
#include "ast.h"

int yyparse();
extern ASTNode* root;  // definido en parser.y

int main(int argc, char** argv) {
    std::cout << "=== Parser Rust-like con AST ===" << std::endl;
    if (yyparse() == 0) {
        std::cout << "Parsing completado sin errores." << std::endl;
        if (root) {
            std::cout << "\n=== AST ===\n";
            printAST(root);
        }
    } else {
        std::cout << "Parsing fallido." << std::endl;
    }
    return 0;
}

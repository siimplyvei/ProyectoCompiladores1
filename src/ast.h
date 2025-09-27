#ifndef AST_H
#define AST_H

#include <string>
#include <vector>
#include <iostream>

struct ASTNode {
    std::string type;                 
    std::string value;                
    std::vector<ASTNode*> children;   

    ASTNode(const std::string& t, const std::string& v = "")
        : type(t), value(v) {}
};


inline void printAST(ASTNode* node, int indent = 0) {
    for (int i = 0; i < indent; i++) std::cout << "  ";
    std::cout << node->type;
    if (!node->value.empty()) std::cout << " (" << node->value << ")";
    std::cout << "\n";

    for (auto child : node->children) {
        printAST(child, indent + 1);
    }
}

#endif

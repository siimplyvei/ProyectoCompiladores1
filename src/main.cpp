#include <iostream>
using namespace std;

int yyparse();

int main(int argc, char** argv) {
    cout << "=== Parser Rust-like ===" << endl;
    if (yyparse() == 0) {
        cout << "Parsing completado sin errores." << endl;
    } else {
        cout << "Parsing fallido." << endl;
    }
    return 0;
}

extern "C" int yywrap() {
    return 1;
}

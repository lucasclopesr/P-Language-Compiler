#include <stdio.h>
#include "list.h"


int main(int argc, char const *argv[]){
    hashmap h = new_hashmap(100);
    assign(h, "chave\0", (node_value)'c');
    printf("%c\n", get(h,"chave\0").value.char_value);
}
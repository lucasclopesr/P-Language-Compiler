#ifndef LIST
#define LIST

#include <string.h>

typedef struct node node;
typedef node *list;
typedef union node_value node_value;

union node_value {
    int int_value;
    float float_value;
    char char_value;
};

struct node
{
    char *key;
    node_value data;
    list next;
};

typedef struct hashmap *hashmap;
struct hashmap
{
    list *l;
    int _arr_len;
};

typedef struct hash_ret hash_ret;
struct hash_ret
{
    char valid;
    node_value value;
};


hash_ret get(hashmap h, char *key);
void assign(hashmap h, char *key,  node_value data);
hashmap new_hashmap(int arr_size);
void hashmap_delete(hashmap h);

#endif

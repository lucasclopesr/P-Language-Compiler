#include <stdlib.h>
#include "list.h"

int hash_func(char *key){
    int ret = 0;
    for (int i = 0; key[i] != '\0'; i++){
        ret += key[i];
    }
    return ret;
}

char comp_func(char *k1, char *k2){
    return !strcmp(k1,k2);
}

int hash_map_get_index(hashmap h, char *key)
{
    return hash_func(key) % h->_arr_len;
}

list new_list()
{
    list item = malloc(sizeof(node));
    item->next = item->key = 0;
    return item;
}

char list_add(hashmap h, list item, char *key, node_value value)
{
    if (!item->key)
    {
        item->data = value;
        item->key = key;
        return 1;
    }
    if (comp_func(key, item->key))
    {
        item->data = value;
        return;
    }
    if (!item->next){
        item->next = new_list();
    }

    return list_add(h, item->next, key, value);
}

void assign(hashmap h,  char *key, node_value value)
{
    int index = hash_map_get_index(h, key);
    list_add(h, h->l[index], key, value);
}

list list_get(hashmap h, list item, char *key)
{

    if (!item->key)
    {
        return 0;
    }
    if (comp_func(key, item->key))
        return item;
    if (!item->next)
        return 0;

    return list_get(h, item->next, key);
}

list hashmap_get_item(hashmap h, char *key){
    unsigned index = hash_map_get_index(h, key);
    return list_get(h, h->l[index], key);
}

hashmap new_hashmap(int arr_size)
{
    hashmap h = malloc(sizeof(struct hashmap));
    h->l = malloc(arr_size * sizeof(list));
    h->_arr_len = arr_size;
    for (size_t i = 0; i < arr_size; i++)
    {
        h->l[i] = new_list();
    }
    return h;
}

hash_ret get(hashmap h, char *key)
{
    hash_ret ret;
    ret.valid = 0;
    const list item = hashmap_get_item(h, key);
    if (item == 0){
        return ret;
    }
    ret.value = item->data;
    ret.valid = 1;
    return ret;
}

void list_delete(list item)
{
    if (item->next)
    {
        list_delete(item->next);
    }
    free(item);
}

void hashmap_delete(hashmap h)
{
    for (size_t i = 0; i < h->_arr_len; i++)
    {
        list cur = h->l[i];
        list_delete(cur);
    }
    free(h->l);
    free(h);
}

#ifndef _OBJECT_H_
#define _OBJECT_H_

struct DNode{
    int data;
    DNode *next;
    DNode *prev;
};

struct DList{
    DNode *head;
    DNode *tail;
};

typedef enum {
    EXIT = 0,
    ADD_HEAD,
    ADD_TAIL,
    ADD_AFTER,
    REMOVE_HEAD,
    REMOVE_TAIL,
    REMOVE_AT_INDEX,
    REMOVE_BY_VALUE,
    FIND_BY_INDEX,
    FIND_BY_VALUE,
    PRINT_LIST
} MenuOption;

#endif

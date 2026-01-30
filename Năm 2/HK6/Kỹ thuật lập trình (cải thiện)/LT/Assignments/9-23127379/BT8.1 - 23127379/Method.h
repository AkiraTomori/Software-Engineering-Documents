#ifndef _METHOD_H_
#define _METHOD_H_

#include "Object.h"
#include <iostream>

void initialize(DList &list);

bool isEmpty(DList list);

DNode *createNode(int data);

DNode *findData(const DList &list, int value);

DNode *findNode(const DList &list, int i);

DNode *findTail(const DList &list);

void addHead(DList &list, int data);

void addTail(DList &list, int data);

void addAfter(DList &list, int data, int index);

void removeHead(DList &list);

void removeTail(DList &list);

void removeNode(DList &list, int i);

void removeData(DList &list, int data);

void removeList(DList &list);

void printList(DList &list);
#endif
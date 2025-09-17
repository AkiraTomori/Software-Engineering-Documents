#ifndef _METHOD_H_
#define _METHOD_H_

#include "Object.h"
#include <iostream>
#include <string>

void initialize(SList &list);

bool isListEmpty(SList list);

SNode *createNode(int data);

void addHead(SList &list, int data);

int countNode(SList list);

void reverseList(SList &list);

void addKeepOrder(SList &list, int data);

void removeHead(SList &list);

void removeList(SList &list);

void printList(const SList &list);

int findOrder(SList &list);

void addKeepOrder(SList &list, int data);
#endif

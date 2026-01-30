#include "Method.h"

void initialize(SList &list)
{
    list.head = nullptr;
}

bool isListEmpty(SList list)
{
    return list.head == nullptr;
}

SNode *createNode(int data)
{
    SNode *newNode = new SNode;
    newNode->val = data;
    newNode->next = nullptr;
    return newNode;
}

void addHead(SList &list, int data)
{
    SNode *newNode = createNode(data);
    if (isListEmpty(list))
    {
        list.head = newNode;
    }
    else
    {
        newNode->next = list.head;
        list.head = newNode;
    }
}

int countNode(SList list)
{
    if (isListEmpty(list))
        return 0;

    int node = 0;
    for (SNode *p = list.head; p; p = p->next)
    {
        node++;
    }

    return node;
}

void reverseList(SList &list)
{
    if (isListEmpty(list))
        return;
    SNode *prev = nullptr;
    SNode *nextNode = nullptr;
    SNode *curr = list.head;

    while (curr)
    {
        nextNode = curr->next;
        curr->next = prev;
        prev = curr;
        curr = nextNode;
    }

    list.head = prev;
}

void removeHead(SList &list)
{
    if (isListEmpty(list))
        return;

    SNode *temp = list.head;
    list.head = list.head->next;
    delete temp;
}

void removeList(SList &list)
{
    while (list.head)
    {
        removeHead(list);
    }
}

void printList(const SList &list)
{
    if (isListEmpty(list)) return;

    for (SNode *p = list.head; p; p = p->next){
        std::cout << p->val << " ";
    }
    std::cout << "\n";
}

int findOrder(SList &list)
{
    for (SNode *p = list.head; p->next; p = p->next){
        if (p->val > p->next->val){
            return -1;
        }
    }
    return 1;
}
void addKeepOrder(SList &list, int data)
{
    if (isListEmpty(list)){
        addHead(list, data);
        return;
    }

    int order = findOrder(list);
    SNode *prev = nullptr;
    for (SNode *p = list.head; p; p = p->next){
        if (p->val * order > data * order){
            SNode *temp = createNode(data);
            if (prev == nullptr){
                addHead(list, data);
            }
            else{
                prev->next = temp;
                temp->next = p;
            }
            return;
        }
        prev = p;
    }
    prev->next = createNode(data);
}
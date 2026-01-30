#include "Method.h"

void initialize(DList &list)
{
    list.head = nullptr;
    list.tail = nullptr;
}

bool isEmpty(DList list)
{
    return list.head == nullptr;
}

DNode *createNode(int data)
{
    DNode *newNode = new DNode();
    newNode->data = data;
    newNode->next = nullptr;
    newNode->prev = nullptr;
    return newNode;
}

DNode *findData(const DList &list, int value)
{
    for (DNode *p = list.head; p; p = p->next){
        if (p->data == value){
            return p;
        }
    }
    return nullptr;
}

DNode *findNode(const DList &list, int i)
{
    int pos = 0;
    for (DNode *p = list.head; p; p = p->next){
        if (pos == i){
            return p;
        }
        ++pos;
    }
    return nullptr;
}

DNode *findTail(const DList &list)
{
    if (list.tail == nullptr) return nullptr;
    return list.tail;
}

void addHead(DList &list, int data)
{
    DNode *newNode = createNode(data);
    if (isEmpty(list)){
        list.head = newNode;
        list.tail = newNode;
    }
    else{
        newNode->next = list.head;
        list.head->prev = newNode;
        list.head = newNode;
    }
}

void addTail(DList &list, int data)
{
    DNode *newNode = createNode(data);
    if (isEmpty(list)){
        list.head = newNode;
        list.tail = newNode;
    }
    else{
        list.tail->next = newNode;
        newNode->prev = list.tail;
        list.tail = newNode;
    }
}

void addAfter(DList &list, int data, int index)
{
    DNode *newNode = createNode(data);
    int pos = 0;
    for (DNode *p = list.head; p; p = p->next){
        if (pos == index){
            if (p->next == nullptr)
                addTail(list, data);
            else{
                p->next->prev = newNode;
                newNode->next = p->next;
                p->next = newNode;
                newNode->prev = p;
            }
            return;
        }
        ++pos;
    }
}

void removeHead(DList &list)
{
    if (isEmpty(list)) return;
    if (list.head == list.tail){
        delete list.head;
        list.head = nullptr;
        list.tail = nullptr;
        return;
    }

    DNode *temp = list.head;
    list.head = list.head->next;
    list.head->prev = nullptr;
    delete temp;
}

void removeTail(DList &list)
{
    if (list.tail == nullptr) return;
    if (list.head == list.tail){
        delete list.head;
        list.head = nullptr;
        list.tail = nullptr;
        return;
    }
    DNode *temp = list.tail;
    list.tail = list.tail->prev;
    list.tail->next = nullptr;
    delete temp;
}

void removeNode(DList &list, int i)
{
    int pos = 0;
    for (DNode *p = list.head; p; p = p->next){
        if (pos == i){
            if (p == list.tail){
                removeTail(list);
                return;
            }
            if (p == list.head){
                removeHead(list);
                return;
            }
            p->next->prev = p->prev;
            p->prev->next = p->next;
            delete p;
            return;
        }
        ++pos;
    }
}

void removeData(DList &list, int data)
{
    for (DNode *p = list.head; p; p = p->next){
        if (p->data == data){
            if (p == list.head){
                removeHead(list);
                return;
            }
            if (p == list.tail){
                removeTail(list);
                return;
            }

            p->prev->next = p->next;
            p->next->prev = p->prev;
            delete p;
            return;
        }
    }
}

void removeList(DList &list)
{
    while (!isEmpty(list)){
        removeHead(list);
    }
}

void printList(DList &list)
{
    std::cout << "Current list: \n";
    for (DNode *p = list.head; p; p = p->next){
        std::cout << p->data << " ";
    }
    std::cout << "\n";
}
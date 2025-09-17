#ifndef _TASK_H_
#define _TASK_H_

#include <iostream>
#include <stdio.h>

typedef enum {
    EXIT,
    SUM,
    POWER,
    HARMONY,
    PASCAL
} Choice;

int calculateSum(int n);
int calcPower(int x, int n);
double calcHarmony(int n);
int comb(int n, int k);
void printPascal(int n, int i = 0);


#endif
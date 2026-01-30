#ifndef _TASK_H_
#define _TASK_H_

#include <iostream>
#include <stdio.h>
#include <string.h>

#define MAX_ELEMENTS 256
typedef enum{
    EXIT,
    EVEN,
    MAX,
    REVERSE,
    PRINT
} Choice;

void inputArray(int *arr, int n);
void outputArray(int *arr, int n);
int calcAllEven(int *arr, int n);
int findMaxNumber(int *arr, int n);
int findMax(int *arr, int left, int right);
void reverseChar(char *str, int left, int right);
void printCurrency(int n);

#endif
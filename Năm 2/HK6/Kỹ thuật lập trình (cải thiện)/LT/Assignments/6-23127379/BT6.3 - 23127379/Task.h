#ifndef _TASK_H_
#define _TASH_H_

#include <iostream>
#include <string.h>
#include <stdio.h>

typedef enum{
    EXIT,
    PERMUTATION,
    K_PERMUTATION,
    K_SETS
} Choice;
void inputArray(int *arr, int n);
void outputArray(int *arr, int n);
void printPermutation(int *arr, int n, int pos = 0);
void kPermute(int *arr, int n, int result[], int k, bool used[], int pos);
void release(int *arr, int *result, bool *used, int *result2);
void kSets(int *arr, int n, int *result, int k, int pos = 0, int start = 0);
#endif
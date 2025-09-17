#include "Task.h"

void inputArray(int *arr, int n)
{
    for (int i = 0; i < n; i++)
    {
        arr[i] = i + 1;
    }
}
void outputArray(int *arr, int n)
{
    for (int i = 0; i < n; i++)
    {
        printf("%d ", arr[i]);
    }
    printf("\n");
}
void printPermutation(int *arr, int n, int pos)
{
    if (pos == n)
    {
        outputArray(arr, n);
        return;
    }
    for (int i = pos; i < n; i++)
    {
        std::swap(arr[pos], arr[i]);
        printPermutation(arr, n, pos + 1);
        std::swap(arr[pos], arr[i]); // drawback
    }
}

void kPermute(int *arr, int n, int result[], int k, bool used[], int pos)
{
    if (pos == k){
        outputArray(result, k);
        return;
    }
    for (int i = pos; i < n; i++)
    {
        if (!used[i])
        {
            used[i] = true;
            result[pos] = arr[i];
            kPermute(arr, n, result, k, used, pos + 1);
            used[i] = false;
        }
    }
}

void kSets(int *arr, int n, int *result, int k, int pos, int start)
{
    if (pos == k){
        outputArray(result, k);
        return;
    }
    for (int i = start; i < n; i++){
        result[pos] = arr[i];
        kSets(arr, n, result, k, pos + 1, i + 1);
    }
}
void release(int *arr, int *result, bool *used, int *result2)
{
    delete [] arr;
    delete [] result;
    delete [] used;
    delete [] result2;
}
#include "Task.h"

int calcAllEven(int *arr, int n)
{
    if (n == 0) return 0;
    return (arr[n - 1] % 2 == 0 ? arr[n - 1] : 0) + calcAllEven(arr, n - 1);
}

int findMaxNumber(int *arr, int n)
{
    int left = 0, right = n - 1;
    return findMax(arr, left, right);
}

int findMax(int *arr, int left, int right)
{
    if (left == right)
    {
        return arr[left];
    }
    int mid = left + (right - left) / 2;
    int leftMax = findMax(arr, left, mid);
    int rightMax = findMax(arr, mid + 1, right);
    return leftMax > rightMax ? leftMax : rightMax;
}

void reverseChar(char *str, int left, int right)
{
    if (left >= right) return;
    char temp = str[left];
    str[left] = str[right];
    str[right] = temp;
    reverseChar(str, left + 1, right - 1);
}

void printCurrency(int n)
{
    if (n < 1000){
        printf("%d", n);
        return;
    }
    printCurrency(n / 1000);
    printf(",%03d", n % 1000);
}

void inputArray(int *arr, int n)
{
    for (int i = 0; i < n; i++){
        printf("arr[%d]: ", i + 1);
        scanf("%d", &arr[i]);
    }
}

void outputArray(int *arr, int n)
{
    for (int i = 0; i < n; i++){
        printf("%d ", arr[i]);
    }
    printf("\n");
}
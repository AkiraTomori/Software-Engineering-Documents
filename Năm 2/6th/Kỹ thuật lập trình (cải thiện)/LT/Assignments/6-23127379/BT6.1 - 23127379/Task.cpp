#include "Task.h"

int calculateSum(int n)
{
    if (n == 1) return 1;
    return n + calculateSum(n - 1);
}
int calcPower(int x, int n)
{
    // if (n == 0) return 1;
    // return x * calcPower(x, n - 1);
    int p;
    if (n == 0) return 1;
    else if (n % 2 == 0){
        p = calcPower(x, n / 2);
        return p * p;
    }
    else{
        p = calcPower(x, (n - 1) / 2);
        return x * p * p;
    }
}
double calcHarmony(int n)
{
    if (n == 1) return 1.0;
    return (n % 2 == 0 ? -1.0 : 1.0) / n + calcHarmony(n - 1);
}
int comb(int n, int k)
{
    if (k == 0 || k == n) return 1;
    return comb(n - 1, k - 1) + comb(n - 1, k);
}
void printPascal(int n, int i)
{
    if (i == n) return;
    for (int j = 0; j <= i; j++){
        printf("%d ", comb(i, j));
    }
    printf("\n");
    printPascal(n, i + 1);
}
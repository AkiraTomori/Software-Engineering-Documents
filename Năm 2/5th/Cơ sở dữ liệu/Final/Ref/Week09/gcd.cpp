#include <iostream>
#include <stdio.h>

int FindGcd(int a, int b)
{
    int r;
    while (a != b)
    {
        if (a > b)
            a = a - b;
        else
            b = b - a;
    }
    return a;
}
int main()
{
    int a, b;
    // scanf("%d%d", &a, &b);
    a = 24; b = 16;
    printf("%d", FindGcd(a, b));
    return 0;
}
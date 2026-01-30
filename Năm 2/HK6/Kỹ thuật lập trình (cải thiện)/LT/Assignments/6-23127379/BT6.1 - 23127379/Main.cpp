#include "Task.h"

int main()
{
    printf("1. Exercise 1\n");
    printf("2. Exercise 2\n");
    printf("3. Exercise 3\n");
    printf("4. Exercise 4\n");

    int choice;
    do
    {
        printf("Enter exercise to check (1-4) (0 for exit): ");
        scanf("%d", &choice);
        switch (choice)
        {
        case SUM:
        {
            printf("Enter n: ");
            int n;
            scanf("%d", &n);
            int sum = calculateSum(n);
            printf("Sum from 1 - n: %d\n", sum);
            break;
        }
        case POWER:
        {
            printf("Enter x: ");
            int x;
            scanf("%d", &x);
            printf("Enter n: ");
            int n;
            scanf("%d", &n);
            int powerX = calcPower(x, n);
            printf("%d^%d = %d\n", x, n, powerX);
            break;
        }
        case HARMONY:
        {
            printf("Enter n: ");
            int n; scanf("%d", &n);
            double harmonySum = calcHarmony(n);
            printf("Harmony sum: %lf\n", harmonySum);
            break;
        }
        case PASCAL:
        {
            printf("Enter n: ");
            int n;
            scanf("%d", &n);
            printf("Pascal triangle: \n");
            printPascal(n, 0);
            break;
        }
        case EXIT:
        {
            printf("End program.\n");
            break;
        }
        default:
            printf("Invalid choice.\n");
            break;
        }
    } while (choice != EXIT);
    return 0;
}
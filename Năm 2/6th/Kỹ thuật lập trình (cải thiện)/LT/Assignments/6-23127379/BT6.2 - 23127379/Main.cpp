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
        printf("Enter exercise (1-4) (0 for exit): ");
        scanf("%d", &choice);
        switch (choice)
        {
        case EVEN:
        {
            printf("Calculate even elements.\n");
            printf("Enter size of array: ");
            int n; scanf("%d", &n);
            int *arr = new int[n];
            inputArray(arr, n);
            outputArray(arr, n);
            int sumEven = calcAllEven(arr, n);
            printf("Sum of even integers: %d\n", sumEven);
            delete [] arr;
            break;
        }
        case MAX:
        {
            printf("Find max \n");
            printf("Enter size of array: ");
            int n; scanf("%d", &n);
            int *arr = new int[n];
            inputArray(arr, n);
            outputArray(arr, n);
            int max = findMaxNumber(arr, n);
            printf("Max: %d\n", max);
            delete []arr;
            break;
        }
        case REVERSE:
        {
            std::cin.ignore();
            char temp[MAX_ELEMENTS];
            printf("Enter sentence: ");
            std::cin.getline(temp, MAX_ELEMENTS);
            char *str = new char[strlen(temp) + 1];
            strcpy(str, temp);
            reverseChar(str, 0, strlen(str) - 1);
            printf("Reverse string: %s\n", str);
            delete []str;
            break;
        }
        case PRINT:
        {
            printf("Enter currency: ");
            int n; scanf("%d", &n);
            printCurrency(n);
            printf("\n");
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
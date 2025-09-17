#include "Task.h"

int main()
{
    printf("1. Exercise 1\n");
    printf("2. Exercise 2\n");
    printf("3. Exercise 3\n");
    
    int choice;
    do{
        printf("Enter exercise (1-3) (0 for exit): ");
        scanf("%d", &choice);
        switch (choice){
            case PERMUTATION:
            {
                printf("Permutaion.\n");
                printf("Enter n: ");
                int n; scanf("%d", &n);
                int *arr = new int[n];
                inputArray(arr, n);
                outputArray(arr, n);
                printf("Permutaion\n");
                printPermutation(arr, n, 0);
                delete []arr;
                break;
            }
            case K_PERMUTATION:
            {
                printf("K-permutaion.\n");
                printf("Enter n: ");
                int n; scanf("%d", &n);
                int *arr = new int[n];
                inputArray(arr, n);
                outputArray(arr, n);
                printf("Enter k: ");
                int k; scanf("%d", &k);
                int *result = new int[k];
                bool *used = new bool[n];
                for (int i = 0; i < n; i++) used[i] = false;
                kPermute(arr, n, result, k, used, 0);
                delete []arr;
                delete []result;
                delete []used;
                break;
            }
            case K_SETS:
            {
                printf("K-Sets.\n");
                printf("Enter n: ");
                int n; scanf("%d", &n);
                int *arr = new int[n];
                inputArray(arr, n);
                outputArray(arr, n);
                printf("Enter k: ");
                int k; scanf("%d", &k);
                int *result = new int[k];
                kSets(arr, n, result, k, 0, 0);
                delete []arr;
                delete []result;
                break;
            }
            case EXIT:
            {
                printf("Exit program.\n");
                break;
            }
            default:
            {
                printf("Invalid choice.\n");
                break;
            }
        }
    } while (choice != EXIT);
    return 0;
}
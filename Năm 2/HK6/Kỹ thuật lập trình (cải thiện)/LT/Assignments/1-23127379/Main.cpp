#include "Request.h"
#include "getData.h"

int main()
{
    Plantation plantation = readInput("FARM_IN.txt");

    int coffeeCount = countCoffeeTrees(plantation);
    int teaCount = countTeaTrees(plantation);
    float fenceLength = calcFenceLength(plantation);
    float tubeLength = calculateTotalLength(plantation);

    writeToFiles("FARM_OUT.txt", coffeeCount, teaCount, fenceLength, tubeLength);
    return 0;
}
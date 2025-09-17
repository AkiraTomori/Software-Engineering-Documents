#include "Request.h"
// b)
int countTrees(Plantation p, int type)
{
    int countTreeTypes = 0;
    for (int i = 0; i < p.countTree; i++)
    {
        if (p.trees[i].type == type)
        {
            countTreeTypes++;
        }
    }
    return countTreeTypes;
}

int countCoffeeTrees(Plantation p)
{
    return countTrees(p, TYPE_COFFEE);
}

int countTeaTrees(Plantation p)
{
    return countTrees(p, TYPE_TEA);
}
// c)
Point findUpperLeft(Plantation p)
{
    Point upperLeft = p.trees[0].location;
    for (int i = 1; i < p.countTree; i++)
    {
        Point current = p.trees[i].location;
        if (current.x < upperLeft.x)
            upperLeft.x = current.x;
        if (current.y > upperLeft.y)
            upperLeft.y = current.y;
    }
    return upperLeft;
}

Point findLowerRight(Plantation p)
{
    Point lowerRight = p.trees[0].location;
    for (int i = 1; i < p.countTree; i++)
    {
        Point current = p.trees[i].location;
        if (current.x > lowerRight.x)
            lowerRight.x = current.x;
        if (current.y < lowerRight.y)
            lowerRight.y = current.y;
    }
    return lowerRight;
}

float calcFenceLength(Plantation p)
{
    Point upperLeft = findUpperLeft(p);
    Point lowerRight = findLowerRight(p);
    float width = fabs(lowerRight.x - upperLeft.x);
    float height = fabs(upperLeft.y - lowerRight.y);
    return 2 * (width + height);
}

// d)
Point findPump(Plantation p)
{
    Point pump = {0, 0};
    for (int i = 0; i < p.countTree; i++)
    {
        pump.x += p.trees[i].location.x;
        pump.y += p.trees[i].location.y;
    }
    pump.x /= p.countTree;
    pump.y /= p.countTree;
    return pump;
}

float distance(Point p, Point q)
{
    float x = p.x - q.x;
    float y = p.y - q.y;
    return sqrt(x * x + y * y);
}

float calculateTotalLength(Plantation p)
{
    Point pumpLocation = findPump(p);
    float totalLength = 0.0;
    for (int i = 0; i < p.countTree; i++)
    {
        totalLength += distance(pumpLocation, p.trees[i].location);
    }
    return totalLength;
}
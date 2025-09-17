#include "getData.h"

Plantation readInput(const char *filename)
{
    FILE *file = fopen(filename, "r");
    Plantation p;
    if (file == nullptr)
    {
        printf("Cannot open %s files.\n", filename);
        exit(1);
    }
    fscanf(file, "%d", &p.countTree);
    for (int i = 0; i < p.countTree; i++)
    {
        Point location = {0, 0};
        Tree tree;
        fscanf(file, "%f %f %d", &location.x, &location.y, &tree.type);
        tree.location = location;
        p.trees[i] = tree;
    }
    fclose(file);
    return p;
}
void writeToFiles(const char *filename, int coffeeTreesCount, int teaTreesCount, float fenceLength, float tubeLength)
{
    FILE *file = fopen(filename, "w");
    if (file == nullptr)
    {
        printf("Cannot open %s files.\n", filename);
        return;
    }
    fprintf(file, "%d %d\n", coffeeTreesCount, teaTreesCount);
    fprintf(file, "%.2f\n", fenceLength);
    fprintf(file, "%.2f", tubeLength);
    fclose(file);
}
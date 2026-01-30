#ifndef _OBJECT_H_
#define _OBJECT_H_

#define MAX_TREE 100
// #define TYPE_COFFEE 0
// #define TYPE_TEA 1
enum TreeType{
    TYPE_COFFEE = 0,
    TYPE_TEA = 1
};
// a)
/**
 * @brief Declare a structure Point in 2D
 * 
 * @param x x coordinate in 2D
 * @param y y coordinate in 2D
 */
struct Point
{
    float x;
    float y;
};

/**
 * @brief Declare a structure for a tree
 * 
 * @param location coordinate of a tree in 2D 
 * @param type type of a tree (0 for coffee, 1 for tea)
 */
struct Tree
{
    Point location;
    int type;
};

/**
 * @brief Declare plantation structure 
 * 
 * @param trees an array of trees
 * @param countTree number of trees in one plantation
 */
struct Plantation
{
    Tree trees[MAX_TREE];
    int countTree;
};

#endif
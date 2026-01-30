#ifndef _REQUEST_H_
#define _REQUEST_H_

#include "Object.h"

#include <iostream>
#include <stdio.h>
#include <math.h>
#include <string.h>

// b)
/**
 * @brief count Trees base on type
 * 
 * @param p a plantation needs to be checked
 * @param type type of tree needs counting 
 * 
 * @return number of trees based on types
 */
int countTrees(Plantation p, int type);

/**
 * @brief count coffee Trees
 * 
 * @param p a plantation needs to be checked
 * @return number of coffee Trees
 */
int countCoffeeTrees(Plantation p);

/**
 * @brief count Tee Trees
 * 
 * @param p a plantation needs to be checked
 * @return number of tea trees
 */
int countTeaTrees(Plantation p);
// c)

/**
 * @brief Find upper left location
 * 
 * @param p a plantion needs to be checked
 * @details find coordinate which x is min, y is max
 * @return upper Left coordinate
 */
Point findUpperLeft(Plantation p);

/**
 * @brief Find lower right location
 * 
 * @param p a plantion needs to be checked
 * @details find coordinate which x is max, y is min
 * @return lower right coordinate
 */
Point findLowerRight(Plantation p);

/**
 * @brief Find perimeter of rectangular fence
 * 
 * @param p a plantation needs to be checked
 * @return the perimeter of rectangular fence
 */
float calcFenceLength(Plantation p);

// d)
/**
 * @brief Find the center of plantation
 * 
 * @param p a plantation needs to be checked
 * @return center coordinate of in plantation
 */
Point findPump(Plantation p);

/**
 * @brief Find the distance between two points (Length/modun)
 * 
 * @param p first coordinate
 * @param q second coordinate
 * @return the distance between 2 points
 */
float distance(Point p, Point q);

/**
 * @brief Calculate total length of tubes
 * 
 * @param p a plantation needs to be checked
 * @return total length of tubes
 */
float calculateTotalLength(Plantation p);

#endif
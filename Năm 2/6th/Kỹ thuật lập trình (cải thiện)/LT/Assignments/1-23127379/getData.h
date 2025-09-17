#ifndef _GET_DATA_H_
#define _GET_DATA_H_
#include <fstream>
#include "Object.h"
// e)
/**
 * @brief get data for plantation
 * 
 * @param filename name of file
 * @return date of plantation
 */
Plantation readInput(const char *filename);

/**
 * @brief write to files 
 * 
 * @param filename name of file
 * @param coffeeTreesCount number of coffee trees
 * @param teaTreesCount number of tea trees
 * @param fenceLength perimeter of rectangular fence
 * @param tubeLength total length of used tube
 * 
 */
void writeToFiles(const char *filename, int coffeeTreesCount, int teaTreesCount, float fenceLength, float tubeLength);

#endif
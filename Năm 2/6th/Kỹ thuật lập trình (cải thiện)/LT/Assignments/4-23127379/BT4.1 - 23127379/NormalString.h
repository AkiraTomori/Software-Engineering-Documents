#ifndef _NORMAL_STRING_H_
#define _NORMAL_STRING_H_

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string.h>
#include <ctype.h>
#define INITIAL_CAPACITY 128
using namespace std;

int countWord(char *str);
char *normalize(char *str);
char *readParagraphUntilNewDotLine();
void capitalize(char *word);

#endif
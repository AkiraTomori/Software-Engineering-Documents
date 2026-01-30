#ifndef _COPY_H_
#define _COPY_H_

#include <iostream>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#define BUFFER_SIZE 4096
using namespace std;

void printHelp();
bool copyFile(const char *src, const char *dest);
bool joinFile(const char *file1, const char *file2, const char *dest);
char *getFileName(const char *path);
int process_Argv(int argc, char **argv);

#endif
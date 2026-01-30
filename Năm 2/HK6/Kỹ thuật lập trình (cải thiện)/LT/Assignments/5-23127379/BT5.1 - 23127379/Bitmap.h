#ifndef _BITMAP_H_
#define _BITMAP_H_

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#define MAX_FILE_NAME 256
#pragma pack(push, 1)
struct Header{
    char signature[2];
    uint32_t imgSize;
    uint16_t reserved1;
    uint16_t reserved2;
    uint32_t offset;
};

struct DIB{
    uint32_t DIBSize;
    uint32_t width;
    uint32_t height;
    uint16_t colorPlanes;
    uint16_t colorDepth;
    uint32_t compression;
    uint32_t pixelArraySize;
    uint32_t horizontalRes;
    uint32_t verticalRes;
    uint32_t numColors;
    uint32_t numImportantColors;
};

struct Pixel{
    unsigned char blue;
    unsigned char green;
    unsigned char red;
};

struct ColorTable{
    Pixel *colors;
    uint32_t length;
};

struct PixelArray{
    unsigned char *rawData;
    uint32_t paddingSize;
    uint32_t lineSize;
};

struct BMPFile{
    Header header;
    DIB dib;
    ColorTable colorTable;
    PixelArray pixelArray;
};
#pragma pack(pop)

bool isBMP(FILE *fp);

void readBMPHeader(FILE *fp, BMPFile &bmp);

void readBMPDIB(FILE *fp, BMPFile &bmp);

void readBMPPixelArray(FILE *fp, BMPFile &bmp);

void reamBMPColorTable(FILE *fp, BMPFile &bmp);

void readBMP(FILE *fp, BMPFile &bmp);

void writeBMP(char *filename, BMPFile &bmp);

void printInfo(BMPFile &bmp);

void parseArgv(int argc, char **argv, char *filename, int &h, int &w);

void freeMem(BMPFile &bmp);

void readBmpFile(const char *filename, BMPFile &bmp);

void splitBMP(BMPFile &bmp, int h, int w, const char *filename);
#endif
#include "Bitmap.h"

int main(int argc, char **argv)
{
    int h = 1, w = 1;
    char filename[MAX_FILE_NAME];
    if (argc != 4 && argc != 6)
    {
        printf("Invalid parameter.\n");
        printf("Usage: <program> <filename> -h <value h> -w <param w>.\n");
        return 1;
    }
    printf("ARGUMENT PARSE: \n");
    parseArgv(argc, argv, filename, h, w);
    printf("Filename: %s.\n", filename);
    printf("h = %d, w = %d.\n", h, w);
    
    BMPFile bmp;
    readBmpFile(filename, bmp);
    splitBMP(bmp, h, w, filename);

    freeMem(bmp);
    return 0;
}
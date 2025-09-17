#include "Bitmap.h"

bool isBMP(FILE *fp)
{
    if (fp == NULL)
        return false;
    char sign[2];
    fseek(fp, 0, SEEK_SET);
    fread(sign, sizeof(sign), 1, fp);
    return sign[0] == 'B' && sign[1] == 'M';
}
void readBMPHeader(FILE *fp, BMPFile &bmp)
{
    if (fp == NULL)
        return;
    fseek(fp, 0, SEEK_SET);
    fread(&bmp.header, 14, 1, fp);
}

void readBMPDIB(FILE *fp, BMPFile &bmp)
{
    if (fp == NULL)
        return;
    fseek(fp, 14, SEEK_SET);
    fread(&bmp.dib, 40, 1, fp);
}

void reamBMPColorTable(FILE *fp, BMPFile &bmp)
{
    if (fp == NULL)
        return;
    fseek(fp, 54, SEEK_SET);
    fread(&bmp.colorTable, sizeof(ColorTable), 1, fp);
}
void readBMPPixelArray(FILE *fp, BMPFile &bmp)
{
    if (fp == NULL)
        return;
    uint32_t width = bmp.dib.width * (bmp.dib.colorDepth / 8);
    bmp.pixelArray.paddingSize = (4 - (width % 4)) % 4;
    bmp.pixelArray.lineSize = width + bmp.pixelArray.paddingSize;
    bmp.dib.pixelArraySize = bmp.pixelArray.lineSize * bmp.dib.height;
    bmp.pixelArray.rawData = (unsigned char*)malloc(bmp.dib.pixelArraySize * sizeof(unsigned char));
    fseek(fp, bmp.header.offset, SEEK_SET);
    fread(bmp.pixelArray.rawData, bmp.dib.pixelArraySize, 1, fp);
}

void readBMP(FILE *fp, BMPFile &bmp)
{
    if (fp != NULL){
        readBMPHeader(fp, bmp);
        readBMPDIB(fp, bmp);
        readBMPPixelArray(fp, bmp);
    }
    fclose(fp);
}

void writeBMP(char *filename, BMPFile &bmp)
{
    FILE *fp = fopen(filename, "wb");
    if (fp == NULL){
        printf("Error when write file.\n");
        return;
    }
    fwrite(&bmp.header, 14, 1, fp);
    fwrite(&bmp.dib, 40, 1, fp);
    fseek(fp, bmp.header.offset, SEEK_SET);
    fwrite(bmp.pixelArray.rawData, bmp.dib.pixelArraySize, 1, fp);
    fclose(fp);
    printf("Write successfully.\n");
}

void printInfo(BMPFile &bmp)
{
    printf("GENERAL INFORMATIOn: \n");
    printf("Signature: %s", bmp.header.signature);
    printf("Header size: %d", 14);
    std::cout << "DIB Size: " << bmp.dib.DIBSize << "\n";
    std::cout << "Pixel Array Offset: "<< bmp.header.offset << "\n";
    std::cout << "Pixel Array Size: " << bmp.dib.pixelArraySize << "\n";
    std::cout << "Total image Size: " << bmp.header.imgSize << "\n";
    std::cout << "Image Width: " << bmp.dib.width << "\n";
    std::cout << "Image Height: " << bmp.dib.height << "\n";
    std::cout << "Color depth: " << bmp.dib.colorDepth << " bit" <<  "\n";
    std::cout << "Compression: " << bmp.dib.compression << "\n";
}

void parseArgv(int argc, char **argv, char *filename, int &h, int &w)
{
    h = 1; w = 1;
    strcpy(filename, argv[1]);

    if (argc == 4)
    {
        if (strcmp(argv[2], "-h") == 0)
            h = atoi(argv[3]);
        else if (strcmp(argv[2], "-w") == 0)
            w = atoi(argv[3]);
    }
    else if (argc == 6){
        if (strcmp(argv[2], "-h") == 0 && strcmp(argv[4], "-w") == 0){
            h = atoi(argv[3]);
            w = atoi(argv[5]);
        }
        else if (strcmp(argv[2], "-w") == 0 && strcmp(argv[4], "-h") == 0){
            w = atoi(argv[3]);
            h = atoi(argv[5]);
        }
    }
}

void freeMem(BMPFile &bmp)
{
    free(bmp.pixelArray.rawData);
}

void readBmpFile(const char *filename, BMPFile &bmp){
    FILE *fp = fopen(filename, "rb");
    if (fp == NULL){
        printf("Cannot open file %s.\n", filename);
        return;
    }
    readBMP(fp, bmp);
}

void splitBMP(BMPFile &bmp, int h, int w, const char *filename)
{
    int subWidth = bmp.dib.width / w;
    int subHeight = bmp.dib.height / h;
    int bpp = bmp.dib.colorDepth / 8;
    int lineSize = subWidth * bpp;
    int padding = (4 - (lineSize % 4)) % 4;
    int newLineSize = lineSize + padding;

    for (int i = 0; i < h; i++){
        for (int j = 0; j < w; j++)
        {
            BMPFile part = bmp;
            part.dib.width = subWidth;
            part.dib.height = subHeight;
            part.pixelArray.lineSize = newLineSize;
            part.pixelArray.paddingSize = padding;
            part.dib.pixelArraySize = newLineSize * subHeight;
            part.header.imgSize = part.dib.pixelArraySize + part.header.offset;

            part.pixelArray.rawData = (unsigned char *)malloc(part.dib.pixelArraySize);

            for (int y = 0; y < subHeight; y++){
                int srcY = bmp.dib.height - (i * subHeight + y) - 1;
                int dstY = subHeight - y - 1;

                unsigned char *src = bmp.pixelArray.rawData + srcY * bmp.pixelArray.lineSize + j * subWidth * bpp;
                unsigned char *dst = part.pixelArray.rawData + dstY * newLineSize;

                memcpy(dst, src, lineSize);
                memset(dst + lineSize, 0, padding);
            }
            char outname[MAX_FILE_NAME];
            sprintf(outname, "%s_part_%d_%d.bmp", filename, i + 1, j + 1);
            writeBMP(outname, part);
            free(part.pixelArray.rawData);
        }
    }
}
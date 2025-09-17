#include "Copy.h"

bool copyFile(const char *src, const char *dest)
{
    FILE *fp1 = fopen(src, "rb");
    FILE *fp2 = fopen(dest, "ab+");
    if (!fp1 || !fp2){
        return false;
    }
    char buffer[BUFFER_SIZE];
    int bytes;
    while ((bytes = fread(buffer, 1, BUFFER_SIZE, fp1)) > 0){
        fwrite(buffer, 1, bytes, fp2);
    }
    fclose(fp1); fclose(fp2);
    return true;
}

bool joinFile(const char *file1, const char *file2, const char *dest)
{
    bool flag = copyFile(file1, dest);
    if (!flag) return false;
    
    flag = copyFile(file2, dest);
    if(!flag) return false;

    return true;
}

void printHelp(){
    printf("COPY - UTILITY HELP.\n");
    printf("Syntax 1: COPY <source file> <destination file>.\n");
    printf("Syntax 2: COPY <source file> <destination path>/.\n");
    printf("Syntax 3: COPY <file1> + <file2> <destination file>.\n");
    printf("Syntax 4: COPY -?");
}

char *getFileName(const char *path)
{
    const char *slash = strchr(path, '/');
    if (slash == NULL) return (char *)path;
    return (char *)(slash + 1);
}
int process_Argv(int argc, char **argv)
{
    if (argc < 2){
        printf("Invalid argument. Use COPY -? for help.\n");
        return 1;
    }
    if (strcmp(argv[1], "-?") == 0){
        printHelp();
        return 0;
    }
    if (argc == 5 && (strcmp(argv[2], "+") == 0)){
        return joinFile(argv[1], argv[3], argv[4]);
    }
    if (argc == 3)
    {
        const char *src = argv[1];
        const char *dest = argv[2];
        size_t len = strlen(dest);
        if (dest[len - 1] == '/'){
            const char *filename = getFileName(src);
            char *full_dest = (char *)malloc(len + strlen(filename) + 1);
            if (!full_dest){
                return 1;
            }
            strcpy(full_dest, dest);
            strcat(full_dest, filename);
            bool result = copyFile(src, full_dest);
            free(full_dest);
            return result;
        }
        else{
            return copyFile(src, dest);
        }
    }
    printf("Invalid syntax: use COPY -? for help.\n");
    return 1;
}
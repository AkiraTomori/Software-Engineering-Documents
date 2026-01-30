#include "NormalString.h"

int countWord(char *str){
    int word = 0;
    const char* delim = " \t\n\r,.!?;:\"'()[]{}<>|/\\1234567890";
    int n = strlen(str);
    char *copy = (char *)malloc(n + 1);
    strcpy(copy, str);
    char *token = strtok(copy, delim);
    while (token != NULL)
    {
        word++;
        token = strtok(NULL, delim);
    }
    free(copy);
    return word;
}
void capitalize(char *word)
{
    if (word == NULL) return;
    else if (word[0]) word[0] = toupper(word[0]);
    int n = strlen(word);
    for (int i = 1; i < n; i++){
        word[i] = tolower(word[i]);
    }
}

char *normalize(char *str){
    const char* delim = " \t\n\r,.!?;:\"'()[]{}<>|/\\1234567890";
    int lengthStr = strlen(str);
    char *copy = (char *)malloc(lengthStr + 1);
    if (!copy) return NULL;
    strcpy(copy, str);

    char *result = (char *)malloc(1);
    if (!result){
        free(copy);
        return NULL;
    }
    result[0] = '\0';
    int resultLen = 0;
    char *token = strtok(copy, delim);
    while (token != NULL)
    {
        capitalize(token);
        int tokenLength = strlen(token);
        int space = resultLen > 0 ? 1 : 0;
        result = (char *)realloc(result, resultLen + tokenLength + space + 1);
        if (!result){
            free(copy);
            return NULL;
        }
        if (space){
            result[resultLen++] = ' ';
        }
        strcpy(result + resultLen, token);
        resultLen += tokenLength;

        token = strtok(NULL, delim);
    }
    free(copy);
    return result;
}

char *readParagraphUntilNewDotLine()
{
    int capacity = INITIAL_CAPACITY;
    char *buffer = (char *)malloc(capacity);
    if (!buffer) return NULL;

    int length = 0;
    char c, prev = 0;
    while ((c = getchar()) != EOF)
    {
        if (prev == '.' && c == '\n'){
            break;
        }
        if (length + 1 >= capacity)
        {
            capacity *= 2;
            char *newBuffer = (char *)realloc(buffer, capacity);
            if (!newBuffer){
                free(buffer);
                return NULL;
            }
            buffer = newBuffer;
        }
        buffer[length++] = c;
        prev = c;
    }
    buffer[length] = '\0';
    return buffer;
}
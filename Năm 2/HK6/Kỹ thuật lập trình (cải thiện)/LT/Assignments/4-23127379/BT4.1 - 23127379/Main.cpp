#include "NormalString.h"

int main()
{
    printf("Enter your paragraph(end with . and enter): ");
    char *paragraph = readParagraphUntilNewDotLine();
    
    int words = countWord(paragraph);
    printf("Words count: %d.\n", words);
    
    char *normal = normalize(paragraph);
    printf("Normalized: %s", normal);
    
    free(paragraph);
    free(normal);
    
    return 0;
}
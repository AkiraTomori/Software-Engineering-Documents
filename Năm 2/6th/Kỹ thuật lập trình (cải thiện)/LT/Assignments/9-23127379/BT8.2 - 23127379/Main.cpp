#include "Method.h"

int main(){
    std::cout << "Insert n (number of elements): ";
    int n; std::cin >> n;

    SList list;
    initialize(list);

    for (int i = 0; i < n; i++){
        int x;
        std::cout << "List[" << i + 1 << "]" << ": ";
        std::cin >> x;
        addKeepOrder(list, x);
    }

    int numberOfNodes = countNode(list);
    std::cout << "Number of nodes in the list: " << numberOfNodes << "\n";
    std::cout << "List before reverse: \n";
    printList(list);
    std::cout << "List after reverse: \n";
    reverseList(list);
    printList(list);
    std::cout << "Enter number need to be inserted: ";
    int x; std::cin >> x;
    addKeepOrder(list, x);
    printList(list);
    std::cout << "Number of nodes in the list: " << countNode(list) << "\n";
    removeList(list);

    return 0;
}
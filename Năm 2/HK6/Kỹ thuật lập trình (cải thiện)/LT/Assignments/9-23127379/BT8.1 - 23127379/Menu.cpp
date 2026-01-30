#include "Menu.h"

void menu() {
    DList list;
    initialize(list);

    MenuOption choice;
    showMenuSelection();
    do {
        choice = getMenuChoice();

        switch (choice) {
            case ADD_HEAD: {
                int val;
                std::cout << "Enter value to add at head: ";
                std::cin >> val;
                addHead(list, val);
                std::cout << "Insert complete.\n";
                break;
            }
            case ADD_TAIL: {
                int val;
                std::cout << "Enter value to add at tail: ";
                std::cin >> val;
                addTail(list, val);
                std::cout << "Insert complete.\n";
                break;
            }
            case ADD_AFTER: {
                int val, index;
                std::cout << "Enter value to add: ";
                std::cin >> val;
                std::cout << "Enter index to add after: ";
                std::cin >> index;
                addAfter(list, val, index);
                std::cout << "Insert complete.\n";
                break;
            }
            case REMOVE_HEAD:
                removeHead(list);
                std::cout << "Remove complete.\n";
                break;
            case REMOVE_TAIL:
                removeTail(list);
                std::cout << "Remove complete.\n";
                break;
            case REMOVE_AT_INDEX: {
                int index;
                std::cout << "Enter index to remove: ";
                std::cin >> index;
                removeNode(list, index);
                std::cout << "Remove complete.\n";
                break;
            }
            case REMOVE_BY_VALUE: {
                int val;
                std::cout << "Enter value to remove: ";
                std::cin >> val;
                removeData(list, val);
                std::cout << "Remove complete.\n";
                break;
            }
            case FIND_BY_INDEX: {
                int index;
                std::cout << "Enter index to find: ";
                std::cin >> index;
                DNode* node = findNode(list, index);
                if (node)
                    std::cout << "Found node at index " << index << ": " << node->data << "\n";
                else
                    std::cout << "Node not found.\n";
                break;
            }
            case FIND_BY_VALUE: {
                int val;
                std::cout << "Enter value to find: ";
                std::cin >> val;
                DNode* node = findData(list, val);
                if (node)
                    std::cout << "Found node with value " << val << "\n";
                else
                    std::cout << "Value not found in list.\n";
                break;
            }
            case PRINT_LIST:
                printList(list);
                break;
            case EXIT:
                std::cout << "Exiting program...\n";
                break;
            default:
                std::cout << "Invalid choice.\n";
        }
    } while (choice != EXIT);
    removeList(list);
}

void showMenuSelection()
{
    std::cout << "--- DOUBLY LINKED LIST MENU ---\n";
    std::cout << "1. Add Head\n";
    std::cout << "2. Add Tail\n";
    std::cout << "3. Add After Index\n";
    std::cout << "4. Remove Head\n";
    std::cout << "5. Remove Tail\n";
    std::cout << "6. Remove at Index\n";
    std::cout << "7. Remove by Value\n";
    std::cout << "8. Find Node by Index\n";
    std::cout << "9. Find Node by Value\n";
    std::cout << "10. Print List\n";
    std::cout << "0. Exit\n";
}

MenuOption getMenuChoice() {
    int choice;
    std::cout << "Choose option: ";
    std::cin >> choice;

    if (choice >= 0 && choice <= 10)
        return static_cast<MenuOption>(choice);
    else
        return EXIT;
}
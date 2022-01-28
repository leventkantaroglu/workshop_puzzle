import 'dart:io';
import 'dart:math';

import 'item.dart';
import 'position.dart';

const String emptyItemValue = " ";

typedef Board = List<List<Item>>;

void main(List<String> arguments) {
  initGame();
  gameCycle();
}

void initGame() {
  clearScreen();
  displayMessage("Game Started");
  board = createBoard();
}

void clearScreen() {
  print("\x1B[2J\x1B[0;0H");
}

Board createBoard() {
  List<String> values = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    emptyItemValue,
  ];
  values.shuffle();
  while (!isBoardItemsLocated()) {
    var randomLineIndex = Random().nextInt(4);

    if (board[randomLineIndex].length != 4 && values.isNotEmpty) {
      board[randomLineIndex].add(
        Item(
          value: values.first,
          position: Position(
            board[randomLineIndex].length,
            randomLineIndex,
          ),
        ),
      );
      values.removeAt(0);
    }
  }
  return board;
}

Board board = [[], [], [], []];

void gameCycle() {
  while (true) {
    printBoard(board);
    var key = stdin.readLineSync()?.toUpperCase();
    clearScreen();
    if (isValidInput(key)) {
      if (isValidMovement(key!)) {
        move(key);
        if (isCompleted()) {
          displayMessage("Congratulations");
        } else {
          displayMessage("Waiting for next move");
        }
      } else {
        displayMessage("Invalid movement, try again");
      }
    } else if (key == ".") {
      displayMessage("Exit");
      break;
    } else {
      displayMessage("Invalid key, ('.' to exit)");
    }
  }
}

bool isBoardItemsLocated() {
  for (var line in board) {
    if (line.length != 4) {
      return false;
    }
  }
  return true;
}

bool isCompleted() {
  // TODO
  return false;
}

void move(String key) {
  Item prevItem = getItem(key);
  Item nextItem = getItem(emptyItemValue);
  board[nextItem.position.y][nextItem.position.x].value = key;
  board[prevItem.position.y][prevItem.position.x].value = emptyItemValue;
}

bool isValidInput(String? key) {
  return (key is String && isBoardItem(board, key)) ? true : false;
}

Item getItem(String key) {
  late Item _selectedItem;
  for (var line in board) {
    for (var item in line) {
      if (item.value == key) {
        _selectedItem = item;
      }
    }
  }
  return _selectedItem;
}

bool isValidMovement(String key) {
  Position selectedItemPos = getItem(key).position;
  if ((selectedItemPos.y + 1 >= 0 &&
          selectedItemPos.y + 1 < 4 &&
          board[selectedItemPos.y + 1]
                      [selectedItemPos.x]
                  .value ==
              emptyItemValue) ||
      (selectedItemPos.y - 1 >= 0 &&
          selectedItemPos.y - 1 < 4 &&
          board[selectedItemPos.y - 1]
                      [selectedItemPos.x]
                  .value ==
              emptyItemValue) ||
      (selectedItemPos.x - 1 >= 0 &&
          selectedItemPos.x - 1 < 4 &&
          board[selectedItemPos.y][selectedItemPos.x - 1].value ==
              emptyItemValue) ||
      (selectedItemPos.x + 1 >= 0 &&
          selectedItemPos.x + 1 < 4 &&
          board[selectedItemPos.y][selectedItemPos.x + 1].value ==
              emptyItemValue)) {
    return true;
  }
  return false;
}

bool isBoardItem(Board board, String key) {
  for (var line in board) {
    for (Item item in line) {
      if (item.value == key) {
        return true;
      }
    }
  }
  return false;
}

void printBoard(Board board) {
  print("\n");
  print("  -----------------");

  for (var line in board) {
    var printableline = "  |";
    for (Item item in line) {
      printableline += " ${item.value} |";
    }
    print(printableline);
    print("  -----------------");
  }
  print("\n");
}

void displayMessage(String text) {
  print("-> " + text);
}


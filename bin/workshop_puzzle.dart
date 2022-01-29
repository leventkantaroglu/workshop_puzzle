import 'dart:io';
import 'dart:math';

import 'item.dart';
import 'position.dart';

const String emptyItemValue = " ";

typedef Board = List<List<Item>>;
late Board board;
late int boardSize;
late List<String> values;

void main(List<String> arguments) {
  createValues();
  if (!isValueListValid()) return;
  initGame();
  gameCycle();
}

bool isValueListValid() {
  if (values.length % sqrt(values.length) == 0) {
    return true;
  }
  print("-> Invalid values to create board");
  return false;
}

void initGame() {
  clearScreen();
  displayMessage("Game Started");
  createBoard();

  shuffleValues();
  locateValues();
}

void clearScreen() {
  print("\x1B[2J\x1B[0;0H");
}

void createBoard() {
  boardSize = sqrt(values.length).toInt();
  board = [];
  createLines();
}

void createLines() {
  for (var i = 0; i < boardSize; i++) {
    board.add([]);
  }
}

void createValues() {
  values = [
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
}

void shuffleValues() {
  values.shuffle();
}

void locateValues() {
  while (!isAllBoardItemsLocated()) {
    tryToLocateItem();
  }
}

bool isAllBoardItemsLocated() {
  for (var line in board) {
    if (line.length != boardSize) {
      return false;
    }
  }
  return true;
}

void tryToLocateItem() {
  var lineIndex = Random().nextInt(boardSize);

  if (isLocatingAvailable(board[lineIndex].length)) {
    var item = createItem(
      values.first,
      board[lineIndex].length,
      lineIndex,
    );
    locateItem(lineIndex, item);
    popValue();
  }
}

bool isLocatingAvailable(int currentLineLength) {
  return hasEmptyPosition(currentLineLength) && hasNotLocatedItem()
      ? true
      : false;
}

void locateItem(int randomLineIndex, Item item) {
  board[randomLineIndex].add(item);
}

void popValue() {
  values.removeAt(0);
}

bool hasNotLocatedItem() {
  return values.isNotEmpty;
}

bool hasEmptyPosition(int listLength) {
  return listLength < boardSize ? true : false;
}

Item createItem(String value, int x, int y) {
  return Item(
    value: value,
    position: createPosition(x, y),
  );
}

Position createPosition(int x, int y) {
  return Position(x, y);
}

void gameCycle() {
  while (true) {
    printBoard();
    clearScreen();
    var key = getUserInput();
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

String? getUserInput() {
  return stdin.readLineSync()?.toUpperCase();
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
  return (key is String && isBoardItem(key)) ? true : false;
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

  var isBottomMovementValid = (selectedItemPos.y + 1 >= 0 &&
      selectedItemPos.y + 1 < 4 &&
      board[selectedItemPos.y + 1][selectedItemPos.x].value == emptyItemValue);

  var isTopMovementValid = selectedItemPos.y - 1 >= 0 &&
      selectedItemPos.y - 1 < 4 &&
      board[selectedItemPos.y - 1][selectedItemPos.x].value == emptyItemValue;

  var isLeftMovementValid = selectedItemPos.x - 1 >= 0 &&
      selectedItemPos.x - 1 < 4 &&
      board[selectedItemPos.y][selectedItemPos.x - 1].value == emptyItemValue;

  var isRightMovementValid = selectedItemPos.x + 1 >= 0 &&
      selectedItemPos.x + 1 < 4 &&
      board[selectedItemPos.y][selectedItemPos.x + 1].value == emptyItemValue;

  if (isBottomMovementValid ||
      isTopMovementValid ||
      isLeftMovementValid ||
      isRightMovementValid) {
    return true;
  }
  return false;
}

bool isBoardItem(String key) {
  for (var line in board) {
    for (Item item in line) {
      if (item.value == key) {
        return true;
      }
    }
  }
  return false;
}

void printBoard() {
  print("\n");
  print("     -----------------");
  for (var line in board) {
    var printableline = "     |";
    for (Item item in line) {
      printableline += " ${item.value} |";
    }
    print(printableline);
    print("     -----------------");
  }
  print("\n");
}

void displayMessage(String text) {
  print("-> " + text);
}

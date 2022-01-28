import 'position.dart';

class Item {
  String value;
  Position position;
  Item({
    required this.value,
    required this.position,
  });

  @override
  String toString() => 'Item value: $value, $position';
}


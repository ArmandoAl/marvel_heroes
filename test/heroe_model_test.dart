import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_heroes/domain/domain.dart';

void main() {
  test('fromStore should return a valid object', () async {
    // Arrange
    const jsonStr = '''
      {
        "id": 1,
        "name": "Iron Man",
        "description": "The armored Avenger.",
        "image": "https://example.com/ironman.jpg"
      }
    ''';

    // Act
    final heroeModel = HeroeModel.fromStore(jsonDecode(jsonStr));

    // Assert
    expect(heroeModel.id, 1);
    expect(heroeModel.name, 'Iron Man');
    expect(heroeModel.description, 'The armored Avenger.');
    expect(heroeModel.image, 'https://example.com/ironman.jpg');
  });
}

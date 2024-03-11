import 'package:flutter_test/flutter_test.dart';
import 'package:marvel_heroes/domain/domain.dart';
import 'package:marvel_heroes/presentation/presentation.dart';

void main() {
  test('HeroDetailScreen should show heroe information', () async {
    // Arrange
    final heroeModel = HeroeModel(
      id: 1,
      name: 'Iron Man',
      description: 'The armored Avenger.',
      image: 'https://example.com/ironman.jpg',
    );

    // Act
    final detailScreen = HeroDetailScreen(heroeModel);
    // Assert
    expect(detailScreen.heroe, heroeModel);
  });
}

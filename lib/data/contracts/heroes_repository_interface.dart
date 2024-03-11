import 'package:marvel_heroes/domain/domain.dart';

//Implementamos la interfaz de nuestro repositorio de heroes
abstract class IHeroesRepository {
  Future<List<HeroeModel>> fetchHeroes(
      int limit, int offset, String nameStartsWith);
}

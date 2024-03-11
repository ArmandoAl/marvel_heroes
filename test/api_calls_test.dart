import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marvel_heroes/data/data.dart';
import 'package:marvel_heroes/domain/domain.dart';
import 'package:marvel_heroes/presentation/presentation.dart';
import 'package:mockito/mockito.dart';

class MockIHeroesRepository extends Mock implements IHeroesRepository {
  @override
  Future<List<HeroeModel>> fetchHeroes(
      int limit, int offset, String nameStartsWith) async {
    return <HeroeModel>[
      HeroeModel(id: 1, name: 'Iron Man', description: '', image: '')
    ];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late HeroesController controller;
  late MockIHeroesRepository mockRepository;
  late GetStorage getStorage;

  setUp(() {
    mockRepository = MockIHeroesRepository();
    getStorage = GetStorage();
    controller = HeroesController(mockRepository, getStorage);
  });

  test('fetchHeroes should return success and populate heroes', () async {
    // Arrange
    const limit = 20;
    const offset = 0;
    const nameStartsWith = '';
    await controller.fetchHeroes(limit, offset, nameStartsWith);

    // Assert
    expect(controller.status, Status.success);
    expect(controller.heroes, isNotEmpty);
    expect(controller.heroes[0], isA<HeroeModel>());
  });
}

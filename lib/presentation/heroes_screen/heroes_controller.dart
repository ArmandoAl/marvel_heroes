// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marvel_heroes/data/data.dart';
import 'package:marvel_heroes/domain/domain.dart';

//Estos son los estados por los que pasa la pantalla de heroes
enum Status { loading, success, error, initial, empty, moreData }

//Este controlador recibe el repositorio de heroes y el storage de GetStorage, se encarga de manejar la logica y la gestion de estados de la pantalla de heroes
class HeroesController extends GetxController {
  final GetStorage _storage;
  final IHeroesRepository _heroesRepository;
  HeroesController(this._heroesRepository, this._storage);

  //Variables para manejar los estados y los datos de la pantalla y la busqueda de heroes
  final _heroes = <HeroeModel>[].obs;
  final _allHeroes = <HeroeModel>[].obs;
  final _status = Status.initial.obs;
  final limit = 20.obs;
  final offset = 0.obs;
  final nameStartsWith = ''.obs;

  //Getters para obtener los datos y los estados de la pantalla
  List<HeroeModel> get heroes => _heroes;
  List<HeroeModel> get allHeroes => _allHeroes;
  Status get status => _status.value;

  //Metodo para obtener los heroes en el momento de inicializar el controlador
  @override
  void onInit() async {
    super.onInit();
    fetchHeroes(limit.value, offset.value, nameStartsWith.value);
    limit.value = 10;
  }

  Future<void> fetchMoreHeroes() async {
    //Esta funcion se llama cuando se llega al final de la lista de heroes, para cargar mas heroes, se hace una peticion a la api para obtener los siguientes 10 heroes y se agregan a la lista de heroes, ademas de guardarlos en el storage de GetStorage

    if (_status.value != Status.loading) {
      _status.value = Status.loading;

      final heroes = await _heroesRepository.fetchHeroes(
        limit.value,
        offset.value + 10,
        nameStartsWith.value,
      );

      if (heroes.isEmpty) {
        _status.value = Status.empty;
      } else {
        _heroes.addAll(heroes);
        _allHeroes.addAll(heroes);

        _storage.write('heroes',
            _allHeroes.map((heroe) => jsonEncode(heroe.toJson())).toList());

        //save the heroes in the cache, all the model

        offset.value += 10;
        _status.value = Status.moreData;
      }
    }
    return;
  }

  Future<void> fetchHeroes(int limit, int offset, String nameStartsWith) async {
    //Verifica si hay heroes en el storage de GetStorage, si no los hay hace una peticion a la api para obtener los heroes y guarda los heroes en el storage, si los hay los carga en la lista de heroes
    if (_storage.read('heroes') != null) {
      List<HeroeModel> heroes = [];
      for (var heroe in _storage.read('heroes')) {
        heroes.add(HeroeModel.fromStore(jsonDecode(heroe)));
      }
      _heroes.assignAll(heroes);
      _allHeroes.assignAll(heroes);

      _status.value = Status.success;
    } else {
      try {
        final heroes = await _heroesRepository.fetchHeroes(
          limit,
          offset,
          nameStartsWith,
        );
        _heroes.assignAll(heroes);
        _allHeroes.assignAll(heroes);

        //save the heroes in the cache, all the model

        _storage.write('heroes',
            _allHeroes.map((heroe) => jsonEncode(heroe.toJson())).toList());

        _status.value = Status.success;
      } catch (e) {
        print('Error fetching heroes: $e');
        _status.value = Status.error;
      }
    }
  }

  void searchHeroes(String query) {
    //Este metodo se encarga de buscar heroes en la lista de heroes, si la busqueda esta vacia muestra todos los heroes, si no muestra los heroes que coincidan con la busqueda
    if (query.isEmpty) {
      _heroes.assignAll(_allHeroes);
    } else {
      _heroes.assignAll(_allHeroes
          .where(
              (heroe) => heroe.name.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  void navigateToHeroeDetail(HeroeModel heroe) {
    //Este metodo se encarga de navegar a la pantalla de detalle de un heroe, recibe un heroe como parametro y lo envia a la pantalla de detalle
    Get.toNamed('/heroeDetail', arguments: heroe);
  }
}

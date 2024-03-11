import 'dart:convert';
import 'package:marvel_heroes/data/data.dart';
import '../../domain/domain.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

//Implementamos la interfaz de nuestro repositorio de heroes, en el método fetchHeroes hacemos la petición a la API de Marvel para obtener los heroes, con el límit y el offset que le pasamos por parámetro
class HeroesRepository implements IHeroesRepository {
  final http.Client client = http.Client();
  @override
  Future<List<HeroeModel>> fetchHeroes(
      int limit, int offset, String nameStartsWith) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final hash = generateMd5(
        '$ts${MarvelHeroesApi.privateKey}${MarvelHeroesApi.publicKey}');
    try {
      final response = await client.get(
          Uri.parse(
              '${MarvelHeroesApi.baseUrl}limit=$limit&offset=$offset&ts=$ts&apikey=${MarvelHeroesApi.publicKey}&hash=$hash'),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> results = data['data']['results'];
        return results.map((e) => HeroeModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Exception on load heroes');
    }
  }
}

//Función para generar el hash md5 necesario para la autenticación de la API
String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

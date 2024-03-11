// Ponemos las constantes de la API de Marvel en un archivo separado para poder reutilizarlas en toda la aplicación. En la clase encontramos la url de la api, y las keys para poder usarla
class MarvelHeroesApi {
  static const String baseUrl =
      'https://gateway.marvel.com/v1/public/characters?';
  static const String publicKey = "59d5bb1c31c5dc767db4559b49fde182";
  static const String privateKey = "2c476ef40a0200aa0712f1f8462392e0012d3216";
}

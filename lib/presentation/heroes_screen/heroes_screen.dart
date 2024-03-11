import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marvel_heroes/data/data.dart';
import 'package:marvel_heroes/presentation/presentation.dart';

//Esta es la pantalla de heroes, recibe un controlador de heroes y muestra una lista de heroes, ademas de un buscador para buscar heroes por nombre
class HeroesScreen extends StatelessWidget {
  HeroesScreen({Key? key}) : super(key: key);

  //Controladores para el scroll y el buscador
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final controller =
      Get.put(HeroesController(HeroesRepository(), GetStorage()));

  @override
  Widget build(BuildContext context) {
    //Se usa un Obx para escuchar los cambios en el controlador de heroes, si no hay heroes se muestra un CircularProgressIndicator, si hay heroes se muestra la lista de heroes
    return Obx(
      () => controller.heroes.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    const Text('Marvel Heroes'),
                    const Spacer(),
                    Text(controller.allHeroes.isEmpty
                        ? ''
                        : '${controller.allHeroes.length} heroes')
                  ],
                ),
                backgroundColor: Colors.blue,
              ),
              body: Container(
                height: Get.height,
                width: Get.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue,
                      Colors.red,
                    ],
                  ),
                ),
                child: controller.status == Status.initial
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          heroeSearch(controller, _searchController),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController
                                ..addListener(() {
                                  //Cuando se llega al final de la lista de heroes, se llama al metodo fetchMoreHeroes para cargar mas heroes
                                  if (_scrollController.position.pixels >=
                                      _scrollController
                                              .position.maxScrollExtent -
                                          200.0) {
                                    controller.fetchMoreHeroes();
                                  }
                                }),
                              itemCount: controller.heroes.length,
                              itemBuilder: (context, index) {
                                final hero = controller.heroes[index];
                                return GestureDetector(
                                  onTap: () {
                                    controller.navigateToHeroeDetail(hero);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 230, 228, 228),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0.0, 1.0),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      style: ListTileStyle.list,
                                      title: Text(
                                        '${hero.id.toString()} - ${hero.name}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(hero.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          )),
                                      leading: CachedNetworkImage(
                                        imageUrl: hero.image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          if (controller.status == Status.loading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),
              ),
            ),
    );
  }

  Widget heroeSearch(
      HeroesController controller, TextEditingController searchController) {
    //Este widget es el buscador de heroes, recibe un controlador de heroes y un controlador de texto, y muestra un TextField para buscar heroes por nombre
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 230, 228, 228),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          fillColor: Colors.white,
          labelText: 'Search',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          controller.searchHeroes(value);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marvel_heroes/presentation/presentation.dart';
import 'domain/domain.dart';

//Se inicializa el storage de GetStorage
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //usamos el GetMaterialApp para poder usar GetX y definimos las rutas de las pantallas
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
          name: '/',
          page: () => HeroesScreen(),
        ),
        GetPage(
          name: '/heroeDetail',
          page: () => HeroDetailScreen(
            Get.arguments as HeroeModel,
          ),
        ),
      ],
    );
  }
}

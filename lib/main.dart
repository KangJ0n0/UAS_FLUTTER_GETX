import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/routes.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      title: 'Point of Sale (POS)', // Nama aplikasi
      initialRoute: '/', // Rute awal (halaman login)
      getPages:
          AppRoutes.routes, // Daftar rute yang didefinisikan di routes.dart
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import 'dashboard_controller.dart';

class CashierController extends GetxController {
  var productName = ''.obs;
  var productPrice = 0.0.obs;
  var transactionDate = Rx<DateTime>(DateTime.now());
  var productList = <Product>[].obs;
  var totalPrice = 0.0.obs;

  final DashboardController dashboardController = Get.find();

  void addProduct() {
    if (productName.isNotEmpty && productPrice.value > 0) {
      final product = Product(
        name: productName.value,
        price: productPrice.value,
        transactionDate: transactionDate.value,
      );
      productList.add(product);
      totalPrice.value += product.price;

      // Reset input fields
      productName.value = '';
      productPrice.value = 0.0;
    }
  }

  void completeTransaction() {
    if (productList.isNotEmpty) {
      // Show confirmation dialog
      Get.dialog(
        AlertDialog(
          title: Text(
            'Konfirmasi Transaksi',
            style: TextStyle(
              color: Color(0xFF4A9DEC),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Apakah Anda yakin ingin menyelesaikan transaksi?'),
              SizedBox(height: 10),
              Text('Total Produk: ${productList.length}'),
              Text('Total Harga: Rp${totalPrice.value.toStringAsFixed(0)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), // Close dialog
              child: Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                // Process the transaction
                productList.forEach(dashboardController.updateDashboard);
                productList.clear();
                totalPrice.value = 0.0;

                Get.back(); // Close dialog

                // Show success snackbar
                Get.snackbar(
                  'Transaksi Berhasil',
                  'Transaksi telah diselesaikan',
                  backgroundColor: Color(0xFF4A9DEC),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4A9DEC),
                foregroundColor: Colors.white,
              ),
              child: Text('Konfirmasi'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } else {
      // Show error if no products
      Get.snackbar(
        'Error',
        'Tidak ada produk dalam transaksi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

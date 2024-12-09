import 'package:get/get.dart';
import '../models/product_model.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  var totalSales = 0.0.obs;
  var totalTransactions = 0.obs;
  var transactionHistory = <Product>[].obs;

  void updateDashboard(Product product) {
    transactionHistory.add(product);
    totalSales.value += product.price;
    totalTransactions.value++;
  }

  List<Product> getTransactionsByDate(DateTime date) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return transactionHistory
        .where((product) =>
            dateFormat.format(product.transactionDate) ==
            dateFormat.format(date))
        .toList();
  }
}

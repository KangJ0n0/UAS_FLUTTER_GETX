import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../views/login_view.dart';
import '../views/cashier_view.dart';
import '../views/dashboard_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(
      name: '/',
      page: () => LoginView(),
    ),
    GetPage(
      name: '/cashier',
      page: () => CashierPage(),
      binding: BindingsBuilder(() {
        Get.put(DashboardController(), permanent: true);
      }),
    ),
    GetPage(
      name: '/dashboard',
      page: () => DashboardPage(),
      binding: BindingsBuilder(() {
        Get.put(DashboardController(), permanent: true);
      }),
    ),
  ];
}

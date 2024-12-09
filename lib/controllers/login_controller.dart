import 'package:get/get.dart';

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var errorMessage = ''.obs;

  void login() {
    if (username.value.isEmpty || password.value.isEmpty) {
      errorMessage.value = "Username dan password tidak boleh kosong.";
      return;
    }
    if (username.value == 'admin' && password.value == 'admin') {
      errorMessage.value = '';
      Get.offNamed('/dashboard');
    } else {
      errorMessage.value = "Login gagal. Periksa username atau password.";
    }
  }
}

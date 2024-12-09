import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF70C1F3), // Light blue
              Color(0xFF4A9DEC), // Slightly darker light blue
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Title
                      Center(
                        child: Text(
                          'Selamat Datang',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Login untuk melanjutkan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Username TextField
                      _buildTextField(
                        labelText: 'Username',
                        icon: Icons.person_outline,
                        onChanged: (value) => controller.username.value = value,
                      ),
                      SizedBox(height: 20),

                      // Password TextField
                      _buildPasswordTextField(
                        onChanged: (value) => controller.password.value = value,
                      ),

                      // Error Message
                      Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                controller.errorMessage.value,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )),

                      SizedBox(height: 20),

                      // Login Button
                      ElevatedButton(
                        onPressed: controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4A9DEC),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // Forgot Password
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Custom Text Field Widget
  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Color(0xFF4A9DEC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A9DEC), width: 2),
        ),
      ),
    );
  }

  // Custom Password Text Field Widget
  Widget _buildPasswordTextField({
    required Function(String) onChanged,
  }) {
    return TextField(
      onChanged: onChanged,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF4A9DEC)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF4A9DEC), width: 2),
        ),
      ),
    );
  }
}

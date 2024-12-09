import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cashier_controller.dart';
import '../widgets/sidebar.dart';
import 'package:intl/intl.dart';

class CashierPage extends StatelessWidget {
  final CashierController controller = Get.put(CashierController());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime selectedDate = await showDatePicker(
          context: context,
          initialDate: controller.transactionDate.value,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(
                  primary: Color(0xFF4A9DEC), // Light blue primary color
                ),
              ),
              child: child!,
            );
          },
        ) ??
        controller.transactionDate.value;

    controller.transactionDate.value = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cashier', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF4A9DEC),
        elevation: 0,
      ),
      drawer: Sidebar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A9DEC).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Name TextField
              _buildTextField(
                labelText: 'Nama Produk',
                icon: Icons.shopping_basket_outlined,
                onChanged: (value) => controller.productName.value = value,
              ),
              SizedBox(height: 15),

              // Product Price TextField
              _buildTextField(
                labelText: 'Harga Produk',
                icon: Icons.attach_money_outlined,
                keyboardType: TextInputType.number,
                onChanged: (value) => controller.productPrice.value =
                    double.tryParse(value) ?? 0.0,
              ),
              SizedBox(height: 15),

              // Date Selection Row
              _buildDateSelectionRow(context),
              SizedBox(height: 15),

              // Add Product Button
              _buildAddProductButton(),
              SizedBox(height: 15),

              // Product List
              _buildProductList(),
              SizedBox(height: 15),

              // Total Price Display
              _buildTotalPriceDisplay(),
              SizedBox(height: 15),

              // Complete Transaction Button
              _buildCompleteTransactionButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Custom TextField Widget
  Widget _buildTextField({
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: keyboardType,
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

  // Date Selection Row
  Widget _buildDateSelectionRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFF4A9DEC)),
              SizedBox(width: 10),
              Text(
                'Tanggal transaksi:',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          TextButton(
            onPressed: () => _selectDate(context),
            child: Obx(() => Text(
                  DateFormat('yyyy-MM-dd')
                      .format(controller.transactionDate.value),
                  style: TextStyle(
                    color: Color(0xFF4A9DEC),
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  // Add Product Button
  Widget _buildAddProductButton() {
    return ElevatedButton.icon(
      onPressed: controller.addProduct,
      icon: Icon(Icons.add),
      label: Text('Tambah produk'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4A9DEC),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    );
  }

  // Product List
  Widget _buildProductList() {
    return Obx(() => Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListView.separated(
              itemCount: controller.productList.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade300,
              ),
              itemBuilder: (context, index) {
                final product = controller.productList[index];
                return ListTile(
                  title: Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat('yyyy-MM-dd').format(product.transactionDate),
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(
                    'Rp${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Color(0xFF4A9DEC),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }

  // Total Price Display
  Widget _buildTotalPriceDisplay() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFF4A9DEC).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() => Text(
            'Total Harga: Rp${controller.totalPrice.value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A9DEC),
            ),
            textAlign: TextAlign.center,
          )),
    );
  }

  // Complete Transaction Button
  Widget _buildCompleteTransactionButton() {
    return ElevatedButton(
      onPressed: controller.completeTransaction,
      child: Text('Selesaikan transaksi'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4A9DEC),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
      ),
    );
  }
}

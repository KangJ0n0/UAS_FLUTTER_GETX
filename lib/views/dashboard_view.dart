import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/sidebar.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
  final NumberFormat rupiahFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue[300],
        elevation: 0,
      ),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            // Prepare data for charts
            final groupedData = <String, double>{};
            final dateFormat = DateFormat('yyyy-MM-dd');
            final today = DateTime.now();
            final todayString = dateFormat.format(today);

            // Filter transactions to only include today's transactions
            final todaysTransactions =
                controller.transactionHistory.where((transaction) {
              final transactionDate =
                  dateFormat.format(transaction.transactionDate);
              return transactionDate == todayString;
            }).toList();

            // Calculate total sales and transactions for today
            final totalTodaySales = todaysTransactions.fold(
                0.0, (sum, transaction) => sum + transaction.price);
            final totalTodayTransactions = todaysTransactions.length;

            for (var transaction in controller.transactionHistory) {
              final date = dateFormat.format(transaction.transactionDate);
              groupedData[date] = (groupedData[date] ?? 0) + transaction.price;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Penjualan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              rupiahFormatter
                                  .format(controller.totalSales.value),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transaksi hari ini',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '$totalTodayTransactions',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Sales Bar Chart
                _buildSalesBarChart(groupedData, dateFormat),

                SizedBox(height: 20),

                // Sales Pie Chart
                _buildSalesPieChart(groupedData),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSalesBarChart(
      Map<String, double> groupedData, DateFormat dateFormat) {
    // If no data, return a placeholder widget
    if (groupedData.isEmpty) {
      return Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Tidak ada data penjualan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Chart (Bedasarkan tanggal)',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            AspectRatio(
              aspectRatio: 1.7,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipPadding: EdgeInsets.all(5),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rupiahFormatter.format(rod.toY),
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  alignment: BarChartAlignment.spaceAround,
                  maxY:
                      groupedData.values.reduce((a, b) => a > b ? a : b) * 1.1,
                  barGroups: groupedData.entries
                      .map((entry) => BarChartGroupData(
                            x: groupedData.keys.toList().indexOf(entry.key),
                            barRods: [
                              BarChartRodData(
                                toY: entry.value,
                                color: Colors.blue[300],
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                              )
                            ],
                          ))
                      .toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= groupedData.keys.length) {
                            return Text('');
                          }
                          final date = groupedData.keys.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              date,
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 70,
                        interval:
                            groupedData.values.reduce((a, b) => a > b ? a : b) /
                                5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            rupiahFormatter.format(value),
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.left,
                          );
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesPieChart(Map<String, double> groupedData) {
    // If no data, return a placeholder widget
    if (groupedData.isEmpty) {
      return Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Tidak ada data penjualan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Distribution',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 300, // Increased height for more space
              child: PieChart(
                PieChartData(
                  sections: groupedData.entries.map((entry) {
                    return PieChartSectionData(
                      color: _getColorForIndex(
                          groupedData.keys.toList().indexOf(entry.key)),
                      value: entry.value,
                      title: '', // Remove date from title
                      radius: 100,

                      // Badge for date and amount
                      badgeWidget: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              entry.key, // Date
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              rupiahFormatter.format(entry.value), // Amount
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      badgePositionPercentageOffset: 0.9, // Adjust position
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final blueShades = [
      Colors.blue[300],
      Colors.blue[400],
      Colors.blue[500],
      Colors.blue[600],
      Colors.blue[700],
    ];

    return blueShades[index % blueShades.length]!;
  }
}

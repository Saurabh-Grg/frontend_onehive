import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/EarningController.dart';
import 'package:fl_chart/fl_chart.dart'; // Add fl_chart dependency

// EarningsPage - The UI page for Earnings
class EarningsPage extends StatelessWidget {
  // Get the EarningsController instance
  final EarningsController earningsController = Get.put(EarningsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Earnings
              Text(
                'Total Earnings: ${earningsController.totalEarnings.value} NPR',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              SizedBox(height: 10),
              // Completed and Pending Earnings
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEarningsCard('Completed Payments', earningsController.completedPayments.value, Colors.green),
                  _buildEarningsCard('Pending Payments', earningsController.pendingPayments.value, Colors.red),
                ],
              ),
              SizedBox(height: 20),
              // Earnings Distribution (Graph)
              Text('Earnings Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildEarningsGraph(),
              SizedBox(height: 20),
              // Earnings Trend (Graph)
              Text('Earnings Trend (Last Month)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildEarningsTrendGraph(),
              SizedBox(height: 20),
              // Payment Methods
              Text('Payment Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildPaymentMethods(),
              SizedBox(height: 20),
              // Recent Transactions List
              Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                height: 300,
                child: Obx(() {
                  return ListView.builder(
                    itemCount: earningsController.recentTransactions.length,
                    itemBuilder: (context, index) {
                      var transaction = earningsController.recentTransactions[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          leading: Icon(Icons.attach_money),
                          title: Text('${transaction['jobTitle']}'),
                          subtitle: Text('Amount: ${transaction['amount']} NPR'),
                          trailing: Text(transaction['status'].toString(), style: TextStyle(color: transaction['status'] == 'Completed' ? Colors.green : Colors.red)),
                        ),
                      );
                    },
                  );
                }),
              ),
              // Filter by Date Range (optional)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () {
                    // Show date range picker for filtering transactions
                  },
                  child: Text('Filter by Date Range'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Earnings card for completed and pending payments
  Widget _buildEarningsCard(String title, double amount, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text('$amount NPR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  // Earnings Distribution Graph (Completed vs Pending)
  Widget _buildEarningsGraph() {
    return Container(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: earningsController.completedPayments.value,
              color: Colors.green,
              title: 'Completed',
              radius: 50,
            ),
            PieChartSectionData(
              value: earningsController.pendingPayments.value,
              color: Colors.red,
              title: 'Pending',
              radius: 50,
            ),
          ],
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 40,
        ),
      ),
    );
  }

  // Earnings Trend Graph (Last Month)
  Widget _buildEarningsTrendGraph() {
    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 500),
                FlSpot(1, 700),
                FlSpot(2, 650),
                FlSpot(3, 800),
              ],
              isCurved: true,
              color: Colors.blue,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  // Payment Methods Display
  Widget _buildPaymentMethods() {
    return Column(
      children: [
        ListTile(
          title: Text('eSewa'),
          trailing: Icon(Icons.check, color: Colors.green),
        ),
        ListTile(
          title: Text('Bank Transfer'),
          trailing: Icon(Icons.check, color: Colors.green),
        ),
        ListTile(
          title: Text('Cash'),
          trailing: Icon(Icons.close, color: Colors.red),
        ),
      ],
    );
  }
}

// EarningsData model for the graph
class EarningsData {
  final String status;
  final double amount;

  EarningsData(this.status, this.amount);
}

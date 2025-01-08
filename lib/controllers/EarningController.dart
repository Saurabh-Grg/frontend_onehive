import 'package:get/get.dart';

// Controller for Earnings data
class EarningsController extends GetxController {
  var totalEarnings = 5000.0.obs; // Example total earnings in NPR
  var completedPayments = 3000.0.obs; // Completed payments in NPR
  var pendingPayments = 2000.0.obs; // Pending payments in NPR
  var recentTransactions = [
    {'jobTitle': 'Website Design', 'amount': 1500, 'status': 'Completed', 'date': '2025-01-08'},
    {'jobTitle': 'App Development', 'amount': 2000, 'status': 'Pending', 'date': '2025-01-05'},
    {'jobTitle': 'SEO Optimization', 'amount': 500, 'status': 'Completed', 'date': '2025-01-02'},
  ].obs; // Example recent transactions
}

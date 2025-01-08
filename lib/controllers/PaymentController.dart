import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'UserController.dart';

class PaymentController extends GetxController {
  // Define the payment state variables
  var paymentStatus = ''.obs;
  var escrowStatus = ''.obs;
  var paymentUrl = ''.obs;
  final UserController userController = Get.put(UserController());

  // Method to initiate the payment
  Future<void> initiatePayment(int clientId, int freelancerId, int jobId, double amount) async {
    paymentStatus.value = 'initiating';

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/payment/initialize'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userController.token.value}',
        },
        body: json.encode({
          'client_id': clientId,
          'freelancer_id': freelancerId,
          'job_id': jobId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          // Extract the eSewa redirect URL and append query parameters
          final esewaRedirectUrl = responseData['esewaRedirectUrl'];
          final totalAmount = responseData['params']['total_amount'];
          final pid = responseData['params']['pid'];
          final scd = responseData['params']['scd'];
          final su = responseData['params']['su'];
          final fu = responseData['params']['fu'];

          // Build the final payment URL
          paymentUrl.value = '$esewaRedirectUrl?total_amount=$totalAmount&pid=$pid&scd=$scd&su=$su&fu=$fu';
          paymentStatus.value = 'initiated';
        } else {
          paymentStatus.value = 'error';
        }
      } else {
        paymentStatus.value = 'failed';
      }
    } catch (e) {
      paymentStatus.value = 'failed';
      // _handleError(e, 'Error initiating payment');
    }
  }
  // Method to verify the payment
  Future<void> verifyPayment(String pid, String amt) async {
    try {
      final response = await http.get(
        Uri.parse('http://your-backend-url/payment/verify?pid=$pid&amt=$amt'),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          paymentStatus.value = 'verified';
        } else {
          paymentStatus.value = 'failed';
        }
      } else {
        paymentStatus.value = 'error';
      }
    } catch (e) {
      paymentStatus.value = 'error';
      print("Error verifying payment: $e");
    }
  }

  // Method to release escrow payment (client action)
  Future<void> releaseEscrowPayment(int paymentId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('http://your-backend-url/payment/releaseEscrow'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'payment_id': paymentId,
          'amount': amount,
        }),
      );

      if (response.statusCode == 200) {
        escrowStatus.value = 'released';
      } else {
        escrowStatus.value = 'failed';
      }
    } catch (e) {
      escrowStatus.value = 'failed';
      print("Error releasing escrow payment: $e");
    }
  }
}


import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentController extends GetxController {
  // Define the payment state variables
  var paymentStatus = ''.obs;
  var escrowStatus = ''.obs;
  var paymentUrl = ''.obs;

  // Method to initiate the payment
  Future<void> initiatePayment(int clientId, int freelancerId, int jobId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/payment/initialize'),
        headers: {'Content-Type': 'application/json'},
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
          paymentUrl.value = responseData['esewaRedirectUrl'];
          paymentStatus.value = 'initiated';
        } else {
          paymentStatus.value = 'error';
        }
      } else {
        paymentStatus.value = 'failed';
      }
    } catch (e) {
      paymentStatus.value = 'failed';
      print("Error initiating payment: $e");
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

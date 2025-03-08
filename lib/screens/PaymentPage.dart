// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:get/get.dart';
// import '../controllers/PaymentController.dart';
//
// class PaymentPage extends StatelessWidget {
//   final PaymentController paymentController = Get.put(PaymentController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Payment")),
//       body: Center(
//         child: Obx(() {
//           // Check the payment status and render accordingly
//           if (paymentController.paymentStatus.value == 'initiated') {
//             // Convert Uri to WebUri for compatibility with InAppWebView
//             WebUri webUri = WebUri(paymentController.paymentUrl.value);
//             // Redirect to eSewa payment page
//             return InAppWebView(
//               initialUrlRequest: URLRequest(
//                 url: webUri, // Use WebUri here
//               ),
//               onLoadStart: (controller, url) {
//                 if (url != null) {
//                   if (url.toString().contains('verify')) {
//                     // Handle success page: redirect to success page in your app
//                   } else if (url.toString().contains('failed')) {
//                     // Handle failure page: show failure message
//                   }
//                 }
//               },
//             );
//           } else if (paymentController.paymentStatus.value == 'verified') {
//             return Text('Payment Verified');
//           } else if (paymentController.paymentStatus.value == 'error') {
//             return Text('Error initiating payment');
//           } else if (paymentController.paymentStatus.value == 'failed') {
//             return Text('Payment Failed');
//           }
//
//           return ElevatedButton(
//             onPressed: () {
//               // Initiate payment with GetX
//               paymentController.initiatePayment(2, 1, 83, 500.00);
//             },
//             child: Text("Pay with eSewa"),
//           );
//         }),
//       ),
//     );
//   }
// }

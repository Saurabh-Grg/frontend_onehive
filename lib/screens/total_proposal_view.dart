// // views/total_proposals_view.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/total_proposal_controller.dart';
//
// class TotalProposalsView extends StatelessWidget {
//   final TotalProposalsController controller = Get.put(TotalProposalsController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Total Proposals Received (${controller.totalProposals.value})', style: TextStyle(fontWeight: FontWeight.bold),),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         return Center(
//           child: Text(
//             "Total Proposals: ${controller.totalProposals.value}",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//         );
//       }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           controller.fetchTotalProposals();
//         },
//         child: Icon(Icons.refresh),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/constants/apis_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../controllers/ThemeController.dart';
import '../controllers/UserController.dart';
import '../controllers/total_proposal_controller.dart';
import '../models/proposal_model.dart';
import 'agreement_screen.dart';
import 'escrow_payment_page.dart';
import 'freelancer_profile_page_clientView.dart';

class TotalProposalsView extends StatefulWidget {
  @override
  _TotalProposalsViewState createState() => _TotalProposalsViewState();
}

class _TotalProposalsViewState extends State<TotalProposalsView> {
  final TotalProposalsController controller =
      Get.put(TotalProposalsController());
  String? token;

  //for dark mode .to-do
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _getToken();
    _loadProposals();
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token'); // Retrieve the token
    print('Token: $token'); // Print the token for debugging
  }

  final UserController userController = Get.find();

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define a function to refresh the page
    Future<void> _refreshDashboard() async {
      // Simulate a network call or data refresh, e.g., fetch new data
      await Future.delayed(Duration(seconds: 1));
      // Optionally, update the state with new data
      setState(() {
        fetchProposals();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Total Proposals Received (${controller.totalProposals.value})',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // Wrap SingleChildScrollView with RefreshIndicator
      body: RefreshIndicator(
        onRefresh: _refreshDashboard, // The method to refresh the page
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          // Ensure the widget is scrollable to trigger refresh
          child: Column(
            children: [
              _buildProposalsSection(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  List<Proposal> proposals = [];
  bool isLoading = true;

  Future<List<Proposal>> fetchProposals() async {
    // Retrieve the token here
    await _getToken(); // Ensure to call this before fetching proposals
    if (token == null) {
      print('Token is null'); // Log if the token is null
      throw Exception('Token is null. Please log in.');
    }
    final response = await http.get(
      Uri.parse(ApiEndpoints.getProposalForAClient),
      headers: {
        'Authorization': 'Bearer $token',
        // Add the token in the header// Include the token in the request headers
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> proposalsList =
          jsonResponse['proposals']; // Extracting the list from the response
      return proposalsList
          .map((proposal) => Proposal.fromJson(proposal))
          .toList();
    } else {
      print(
          'Error: ${response.statusCode} - ${response.body}'); // Log the error response
      throw Exception('Failed to load proposals');
    }
  }

  Future<void> _loadProposals() async {
    try {
      final fetchedProposals = await fetchProposals();
      setState(() {
        proposals = fetchedProposals;
        isLoading = false;
      });
    } catch (e) {
      // Handle error appropriately
      print('Error loading proposals: $e');
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  void _handleAcceptProposal(BuildContext context, Proposal proposal) {
    if (proposal.useEscrow) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EscrowPaymentPage(proposal: proposal),
        ),
      );
    } else {
      _acceptProposal(proposal);
    }
  }

  void _acceptProposal(Proposal proposal) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AgreementScreen(
          proposalId: proposal.proposalId,
          clientName: 'Client Name',
          clientEmail: 'client@example.com',
          freelancerName: 'Freelancer Name',
          freelancerEmail: 'freelancer@example.com',
          jobTitle: 'Job Title',
          budget: 5000.0,
          // useEscrow: true,
        ),
      ),
    );

    // Show snackbar if agreement is confirmed
    if (result == 'agreement_confirmed') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('You have accepted the proposal for: ${proposal.title}'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    print('Proposal accepted without escrow for: ${proposal.title}');
  }

  void _handleDeclineProposal(Proposal proposal) {
    setState(() {
      proposals.remove(proposal); // Remove proposal from the client side
    });

    // Notify the freelancer about the declination
    // _notifyFreelancer(proposal.freelancerId, 'Your proposal has been declined.');
  }

  Widget _buildProposalsSection(double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loading Indicator
          if (isLoading)
            Center(child: CircularProgressIndicator(color: Colors.deepOrange)),

          // Check if there are any proposals
          if (!isLoading && proposals.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Text(
                  'No proposals at the moment.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          if (!isLoading && proposals.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: proposals.length,
              // Show only the latest 2 proposals
              itemBuilder: (context, index) {
                // Reverse the order of proposals
                final reversedIndex = proposals.length - 1 - index;
                final proposal = proposals[reversedIndex];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Rounded corners for cards
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Proposal from Section (kept as it is)
                        Row(
                          children: [
                            Icon(Icons.assignment_ind,
                                color: Colors.deepOrange,
                                size: screenWidth * 0.05),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              'Proposal from',
                              style: TextStyle(
                                fontSize: screenWidth * 0.038,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Using RichText and TextSpan to handle tap gesture
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' ${proposal.name}',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        if (proposal.freelancerId != null &&
                                            proposal.jobId != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FreelancerProfilePage(
                                                freelancerId:
                                                    proposal.freelancerId,
                                                jobId: proposal.jobId,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // ListTile for job title, proposed budget, and payment status
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Text(
                            'Job: "${proposal.title}"',
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenWidth * 0.01),
                              Text(
                                'Proposed Budget: Rs. ${proposal.budget}',
                                style: TextStyle(
                                    // color: Colors.green,
                                    ),
                              ),
                              SizedBox(height: screenWidth * 0.01),
                              Text(
                                proposal.useEscrow
                                    ? 'Payment will be held in Escrow'
                                    : 'Payment after job completion',
                                style: TextStyle(
                                  color: proposal.useEscrow
                                      ? Colors.deepOrange
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check_circle_outline,
                                    color: Colors.green),
                                iconSize: screenWidth * 0.08,
                                onPressed: () {
                                  _handleAcceptProposal(context, proposal);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.cancel_outlined,
                                    color: Colors.red),
                                iconSize: screenWidth * 0.08,
                                onPressed: () {
                                  _handleDeclineProposal(proposal);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

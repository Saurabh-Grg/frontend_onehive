import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/controllers/total_proposal_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../controllers/ThemeController.dart';
import '../controllers/UserController.dart';
import '../job_forms/API_development_integration.dart';
import '../job_forms/UI_UX_design.dart';
import '../job_forms/backend_development.dart';
import '../job_forms/database_design_management.dart';
import '../job_forms/frontend_development.dart';
import '../job_forms/full_stack_development.dart';
import '../job_forms/graphic_design_branding.dart';
import '../job_forms/mobile_app_development.dart';
import '../models/proposal_model.dart';
import '../providers/user_provider.dart';
import '../services/job_posting_service.dart';
import 'agreement_screen.dart';
import 'all_jobPostings.dart';
import 'client_profile_creation.dart';
import 'client_profile_update.dart';
import 'escrow_payment_page.dart';
import 'freelancer_profile_page.dart';
import 'job_details_page.dart';
import 'login_form.dart';

class ClientDashboard extends StatefulWidget {
  @override
  _ClientDashboardState createState() => _ClientDashboardState();
}

class _ClientDashboardState extends State<ClientDashboard> {
  // final UserController userController = Get.find();
  String? contactPerson;
  int? profileID;
  String? profileImageUrl;

  // Example token (you might fetch this from shared preferences or some other state management solution)
  String? token;

  String username = '';

  //for dark mode .to-do
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _getToken();
    _getUserId(); // Fetch the token when dashboard initializes
    _loadUserFullName(); // Load the username from preferences when the screen is initialized
    _fetchTotalJobPostings(); // Fetch the data when the widget is created
    fetchJobs(); // Fetch jobs when the widget is initialized
    _loadProposals();
    // Fetch total proposals when the dashboard is initialized
    totalProposalsController.fetchTotalProposals();
  }

  Future<void> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token'); // Retrieve the token
    print('Token: $token'); // Print the token for debugging

    // Once the token is fetched, you can load the user profile
    if (token != null) {
      _loadUserProfile();
    } else {
      print('No token found. User may not be logged in.');
    }
  }

  final UserController userController = Get.find();

  Future<void> _loadUserProfile() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/clientProfile/client-profile'),
      headers: {
        'Authorization': 'Bearer ${userController.token.value}',
        // Add the token in the header
        'Content-Type': 'application/json',
        // Optional, depending on your API
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var profileData = data['data']; // Access the nested 'data' key
      // Replace 'localhost' with your local IP address
      String localIp = '127.0.0.1'; // Replace this with your actual local IP

      setState(() {
        contactPerson = profileData['contactPerson'];
        profileID = profileData['id'];
        // Check if profileImageUrl is not null
        if (data['profileImageUrl'] != null) {
          profileImageUrl = data['profileImageUrl']
              .replaceFirst('localhost', localIp); // Update the image URL
        } else {
          profileImageUrl = ''; // or set to a default image URL
        }
        // Update the image URL
        profileImageUrl = profileData['profileImageUrl'];
        print('profile loaded successfully');
        print('Contact Person: $contactPerson');
        print('ProfileID: $profileID');
        print('Profile Image URL: $profileImageUrl');
      });
    } else {
      // Handle errors appropriately
      print("Error loading profile: ${response.statusCode}");
    }
  }

  // Fetch the user's full name from SharedPreferences
  Future<void> _loadUserFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username =
          prefs.getString('username') ?? 'User'; // Default to 'User' if null
    });
  }

  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define a function to refresh the page
    Future<void> _refreshDashboard() async {
      // Simulate a network call or data refresh, e.g., fetch new data
      await Future.delayed(Duration(seconds: 1));
      fetchJobs();

      // Optionally, update the state with new data
      setState(() {
        // Update state or refresh data here
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi! $username',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              _showNotifications(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                _navigateToProfileSettings(context);
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: profileImageUrl != null &&
                        profileImageUrl!.isNotEmpty
                    ? NetworkImage(profileImageUrl!) // Display profile image
                    : null,
                backgroundColor:
                    profileImageUrl == null ? Colors.deepOrange : null,
                child: profileImageUrl == null || profileImageUrl!.isEmpty
                    ? Text(
                        username.isNotEmpty
                            ? username[0]
                                .toUpperCase() // First letter of username
                            : 'C', // Default character if username is empty
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      // Wrap SingleChildScrollView with RefreshIndicator
      body: RefreshIndicator(
        onRefresh: _refreshDashboard, // The method to refresh the page
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          // Ensure the widget is scrollable to trigger refresh
          child: Column(
            children: [
              _buildSummaryCards(screenWidth),
              _buildJobPostingsSection(context, screenWidth),
              _buildProposalsSection(screenWidth),
              _buildOngoingProjectsSection(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    // This method will show the notifications in a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifications'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Notification 1: Your job has been posted.'),
                Text('Notification 2: You received a new proposal.'),
                Text('Notification 3: A freelancer accepted your job.'),
                // Add more notifications as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 150.0,
            child: DrawerHeader(
              child: Text(
                'Navigation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings), // Icon for Account Settings
            title: Text('Account Settings'),
            onTap: () {
              // Implement navigation to account settings
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Payment Information'),
            onTap: () {
              // Implement navigation to payment information
              // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentInformation()));
            },
          ),
          Obx(() => SwitchListTile(
                title: Text(
                  themeController.isDarkTheme.value
                      ? 'Dark Theme'
                      : 'Light Theme',
                  style: TextStyle(fontSize: 16),
                ),
                value: themeController.isDarkTheme.value,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
                secondary: Icon(themeController.isDarkTheme.value
                    ? Icons.dark_mode
                    : Icons.light_mode),
              )),
          //dark mode to-do

          ListTile(
            leading: Icon(Icons.logout), // Icon for Log Out
            title: Text('Log Out'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Future<String?> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('user_id'); // Retrieve user ID from Shared Preferences
  }

  Future<bool> _checkIfProfileExists(BuildContext context) async {
    String? user_id = await _getUserId(); // Get userId from Shared Preferences

    if (user_id == null) {
      // Handle the case where userId is not found
      print("User ID not found.");
      return false; // Or handle it accordingly
    }

    // Make an API call to check if the profile exists for the current user
    final response = await http.get(
      Uri.parse(
          'http://localhost:3000/api/clientProfile/check-profile/$user_id'),
      // Check your API endpoint
      headers: {
        'Authorization': 'Bearer ${userController.token.value}',
        // Ensure the token is included if necessary
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      return responseBody['profileExists'] ==
          true; // Return true if profile exists
    } else {
      // Handle errors appropriately
      print("Error checking profile existence: ${response.statusCode}");
      return false; // Default to false if there's an error
    }
  }

  void _navigateToProfileSettings(BuildContext context) async {
    bool profileExists = await _checkIfProfileExists(context);

    if (profileExists) {
      // Navigate to the profile update page
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ClientProfileUpdate(profileID: profileID.toString())));
    } else {
      // Suggest completing the profile creation process
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profile Incomplete'),
            content: Text(
                'You need to complete your profile creation before updating it.'),
            actions: <Widget>[
              TextButton(
                child: Text('Create Profile'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientProfileCreation()));
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  //log out
  Future<void> _logout(BuildContext context) async {
    // Show a confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
            ),
          ],
        );
      },
    );

    // If user confirmed logout, clear preferences and navigate to login
    if (shouldLogout == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all data
      print('Preferences cleared successfully.');

      // Show a message after successful logout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logged out successfully.'),
        ),
      );

      // Navigate to the login screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginForm()),
        // Replace with your login screen widget
        (Route<dynamic> route) => false, // Remove all routes
      );
    }
  }

  Color primaryColor = Colors.deepOrange;
  Color accentColor = Colors.orange;
  Color textColor = Colors.white;
  Color textColor2 = Colors.black;

  int totalJobPostings = 0;
  int activeProposals = 0; // You can later fetch this from the database as well
  int ongoingProjects = 0; // You can later fetch this from the database as well

  Future<void> _fetchTotalJobPostings() async {
    String? user_id = await _getUserId();
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:3000/api/jobPosting/totalJobPostings/$user_id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalJobPostings = data['totalJobPostings'];
          print(
              'Total Job Postings: $totalJobPostings'); // Print the total job postings for debugging
        });
      } else {
        print(
            'Failed with status code: ${response.statusCode}'); // Log status code
        throw Exception('Failed to load job postings');
      }
    } catch (e) {
      print(e); // Handle any errors
    }
  }

  final TotalProposalsController totalProposalsController =
      Get.put(TotalProposalsController());

  Widget _buildSummaryCards(double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Pass a different image for each card
          Expanded(
              child: _buildSummaryCard(
                  'Total Job Postings',
                  totalJobPostings.toString(),
                  screenWidth,
                  'assets/images/bg1.png')),
          Expanded(
            child: Obx(() {
              // Observe the value of `totalProposals`
              return _buildSummaryCard(
                'Active Proposals',
                totalProposalsController.totalProposals.value.toString(),
                screenWidth,
                'assets/images/bg2.png',
              );
            }),
          ),
          Expanded(
            child: _buildSummaryCard(
                'Ongoing Projects',
                ongoingProjects.toString(),
                screenWidth,
                'assets/images/bg3.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, double screenWidth, String bgImagePath) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.8),
      color: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Background Image: Make it fill the whole card
            Positioned.fill(
              child: Opacity(
                opacity: 0.2, // Adjust opacity for a subtle background effect
                child: Image.asset(
                  bgImagePath, // Use the passed image path
                  fit: BoxFit.cover, // Ensure the image covers the entire card
                ),
              ),
            ),

            // Foreground content (text)
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.03), // Responsive padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center, // Center the text
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ), // Responsive font size
                  ),
                  SizedBox(height: screenWidth * 0.02), // Responsive spacing
                  Text(
                    value,
                    textAlign: TextAlign.center, // Center the text
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ), // Responsive font size
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobPostingsSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Job Postings',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ), // Responsive font size
          ),
          SizedBox(height: screenWidth * 0.03),
          ElevatedButton(
            onPressed: () {
              _showJobTypeSelectionDialog(
                  context); // Show the job type selection dialog
            },
            style: ElevatedButton.styleFrom(
              // backgroundColor: Colors.white, // Button background color
              foregroundColor: primaryColor, // Button text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: Text('+ Create New Job Posting'),
          ),
          SizedBox(height: screenWidth * 0.05),
          _buildActiveJobPostingsList(screenWidth),
        ],
      ),
    );
  }

  void _showJobTypeSelectionDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('+ Create New Job Posting',
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Job Title TextField
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Job Title',
                    labelStyle: TextStyle(color: accentColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor, width: 1.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
                SizedBox(height: 16),
                // Job Description TextField
                TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Job Description',
                    labelStyle: TextStyle(color: accentColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: accentColor, width: 1.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                ),
                SizedBox(height: 16),
                // Category Dropdown
                DropdownButton<String>(
                  value: selectedCategory,
                  hint: Text('Select Category'),
                  isExpanded: true,
                  underline: SizedBox(),
                  items: [
                    'Backend Development',
                    'Frontend Development',
                    'Full-Stack Development',
                    'Mobile App Development',
                    'API Development & Integration',
                    'Database Design & Management',
                    'UI/UX Design',
                    'Graphic Design & Branding',
                  ].map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedCategory = newValue;
                    (context as Element).markNeedsBuild();
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Proceed', style: TextStyle(color: Colors.green)),
              onPressed: () async {
                if (_titleController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    selectedCategory != null) {
                  // Retrieve the current user from the UserProvider
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  String? currentUserIdStr =
                      userProvider.currentUser?.userId?.toString();

                  if (currentUserIdStr == null) {
                    print("User ID is not available.");
                    return; // Handle the case where the user ID is not found
                  }

                  // Convert currentUserId from String to int
                  int currentUserId = int.tryParse(currentUserIdStr) ??
                      0; // Use a default value if parsing fails

                  // Retrieve the job posting service
                  final jobPostingService =
                      Provider.of<JobPostingService>(context, listen: false);
                  // First, initialize job posting with user ID
                  jobPostingService.initializeJobPosting(currentUserId);
                  // Set the job posting data temporarily
                  jobPostingService.setJobPosting(
                    _titleController.text,
                    _descriptionController.text,
                    selectedCategory!,
                    currentUserId,
                  );

                  // Print current job posting details for debugging
                  // jobPostingService.printCurrentJobPostingDetails();

                  try {
                    // Store temp job posting
                    await jobPostingService.storeTempJob();

                    // Optionally, check the stored data after submission
                    jobPostingService
                        .printCurrentJobPostingDetails(); // For debugging

                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //   content: Text('Job posting stored successfully!'),
                    // ));

                    // Navigate to the respective form based on the selected category
                    Widget targetPage;

                    switch (selectedCategory) {
                      case 'Backend Development':
                        targetPage = BackendJobPostingForm();
                        break;
                      case 'Frontend Development':
                        targetPage = FrontendJobPostingForm();
                        break;
                      case 'Full-Stack Development':
                        targetPage = FullStackJobPostingForm();
                        break;
                      case 'API Development & Integration':
                        targetPage = ApiDevelopmentJobPostingForm();
                        break;
                      case 'Mobile App Development':
                        targetPage = MobileAppDevelopmentJobPostingForm();
                        break;
                      case 'Database Design & Management':
                        targetPage =
                            DatabaseDesignAndManagementJobPostingForm();
                        break;
                      case 'UI/UX Design':
                        targetPage = UIUXDesignJobPostingForm();
                        break;
                      case 'Graphic Design & Branding':
                        targetPage = GraphicDesignBrandingJobPostingForm();
                        break;
                      default:
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Invalid category selected.'),
                        ));
                        return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => targetPage,
                      ),
                    ).then((_) {
                      Navigator.of(context)
                          .pop(); // Close the dialog after navigating
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed to store job posting: $e'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Please fill out all fields and select a category.'),
                  ));
                }
              },
            ),
            TextButton(
              child: Text('Cancel', style: TextStyle(color: accentColor)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildJobTypeListTile(
      BuildContext context, String title, Widget page, Color color) {
    return ListTile(
      title: Text(title, style: TextStyle(color: color)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  // Sample job data (replace this with actual data from your API or state)
  List<Map<String, String>> jobs = [];

  // Function to fetch job postings from the backend
  Future<void> fetchJobs() async {
    String? user_id = await _getUserId();
    final String url = 'http://localhost:3000/api/jobPosting/jobs/$user_id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          jobs = List<Map<String, String>>.from(data['jobs'].map((job) => {
                'job_id': job['job_id'].toString(),
                // Include jobId here
                'title': job['title'].toString(),
                'description': job['description'].toString(),
                // Add description here
                'category': job['category'].toString(),
                // 'status': job['status']
              }));
        });
      } else {
        print('Failed to load jobs');
      }
    } catch (e) {
      print('Error fetching jobs: $e');
    }
  }

  Future<void> _deleteJob(int job_id) async {
    final url = 'http://localhost:3000/api/jobPosting/$job_id';
    print("Request URL: $url");

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        // Update the local list immediately
        // setState(() {
        //   jobs.removeAt(job_id); // Remove the job from the list using the index
        // });
        print("Job deleted successfully on the server.");
        _fetchTotalJobPostings(); // Update the UI after deletion
        await fetchJobs();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Job deleted successfully!")),
        );
      } else if (response.statusCode == 404) {
        print("Job not found.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Job not found.")),
        );
      } else if (response.statusCode == 403) {
        print("Unauthorized: You don't have permission to delete this job.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unauthorized action.")),
        );
      } else {
        print("Failed to delete job. Status code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete job. Please try again.")),
        );
      }
    } catch (e) {
      print("Exception occurred during job deletion: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting job.")),
      );
    }
  }

  Widget _buildActiveJobPostingsList(double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        jobs.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
                  child: Text(
                    "You haven't posted a job yet",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: jobs.length > 2 ? 2 : jobs.length,
                // Show only 2 jobs or fewer if not available
                itemBuilder: (context, index) {
                  final job = jobs.reversed
                      .toList()[index]; // Reverse the order of jobs
                  return Card(
                    // color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                    // Responsive margin
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text(
                        job['title']!,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description: ${job['description']}',
                            // Limit the description to 2 lines
                            maxLines: 2,
                            overflow: TextOverflow
                                .ellipsis, // Show "..." for long text
                          ),
                          // Display job description
                          Text('Category: ${job['category']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              // Implement edit functionality
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              final jobId =
                                  int.tryParse(job['job_id'] ?? '0') ?? 0;
                              print("Attempting to delete job ID: $jobId");
                              if (jobId > 0) {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirm Deletion"),
                                      content: Text(
                                          "Are you sure you want to delete this job?"),
                                      actions: [
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Delete",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            _deleteJob(
                                                jobId); // Call the delete function
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                print("Invalid job ID");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Invalid job ID")),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to JobDetailsPage when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetailsPage(
                                jobId: int.parse(job['job_id']!)),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end, // Align button to the right
          children: [
            TextButton(
              onPressed: () {
                // Navigate to AllJobPostingsPage when "View All" is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AllJobPostingsPage(), // Navigate to All Jobs Page
                  ),
                );
              },
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.deepOrange,
                  decoration:
                      TextDecoration.underline, // Adds underline to the text
                ),
              ),
            ),
          ],
        ),
      ],
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
      Uri.parse('http://localhost:3000/api/proposals/client'),
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
          clientName: 'Client Name',
          clientEmail: 'client@example.com',
          freelancerName: 'Freelancer Name',
          freelancerEmail: 'freelancer@example.com',
          jobTitle: 'Job Title',
          budget: 5000.0,
          useEscrow: true,
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

  void _notifyFreelancer(String freelancerId, String message) {
    // Send notification to freelancer (using notification system)
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
          Text(
            'Incoming Proposals',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange, // Adjust to your primary color
            ),
          ),
          SizedBox(height: screenWidth * 0.03),

          // Loading Indicator
          if (isLoading) Center(child: CircularProgressIndicator()),

          // Check if there are any proposals
          if (!isLoading && proposals.isEmpty)
            Center(
              child: Text(
                'No proposals at the moment.',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),

          if (!isLoading && proposals.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: proposals.length,
              itemBuilder: (context, index) {
                final proposal = proposals[index];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Proposal from ',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              TextSpan(
                                text: proposal.name,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.deepOrange,
                                  // Set the name color to black
                                  fontWeight: FontWeight.bold,
                                  // decoration: TextDecoration.underline, // Optional: underline to indicate clickability
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Debug: Ensure non-null IDs
                                    if (proposal.freelancerId != null &&
                                        proposal.jobId != null) {
                                      print(
                                          "Navigating to FreelancerProfilePage with jobId: ${proposal.jobId} and freelancerId: ${proposal.freelancerId}");
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
                                    } else {
                                      print(
                                          "Error: Missing jobId or freelancerId in proposal.");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Error: Missing job or freelancer details.")),
                                      );
                                    }
                                  },
                              ),
                              TextSpan(
                                text: ' for job "${proposal.title}"',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('Proposed Budget: Rs. ${proposal.budget}'),
                        SizedBox(height: screenWidth * 0.01),
                        Text(
                          proposal.useEscrow
                              ? 'Payment will be held in Escrow'
                              : 'Payment after job completion',
                          style: TextStyle(
                            color: proposal.useEscrow
                                ? Colors.deepOrange
                                : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenWidth * 0.02),

                        // Action buttons (Accept/Decline)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.35,
                              child: ElevatedButton(
                                onPressed: () {
                                  _handleAcceptProposal(context,
                                      proposal); // Pass context and useEscrow argument
                                },
                                style: ElevatedButton.styleFrom(
                                    // backgroundColor: Colors.white, // Button background color
                                    ),
                                child: Text('Accept'),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.35,
                              child: ElevatedButton(
                                onPressed: () {
                                  _handleDeclineProposal(proposal);
                                },
                                style: ElevatedButton.styleFrom(
                                    // backgroundColor: Colors.white, // Button background color
                                    ),
                                child: Text('Decline'),
                              ),
                            ),
                          ],
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

  Widget _buildOngoingProjectsSection(double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ongoing Projects',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              // color: Colors.green,
            ), // Responsive font size
          ),
          // Placeholder for ongoing projects
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 2, // Replace with actual project count
            itemBuilder: (context, index) {
              return Card(
                color: Colors.green[50],
                margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                // Responsive margin
                child: ListTile(
                  title: Text('Project Title $index',
                      style: TextStyle(fontSize: screenWidth * 0.04)),
                  // Responsive font size
                  subtitle: Text('Status: In Progress\nDeadline: 2023-12-01'),
                  trailing: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      // Implement messaging functionality
                    },
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

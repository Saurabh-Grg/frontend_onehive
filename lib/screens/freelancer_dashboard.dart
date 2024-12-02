import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onehive_frontend/constants/apis_endpoints.dart';
import 'package:onehive_frontend/screens/proposal_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'client_profile_page.dart';
import 'freelancer_profile_creation.dart';
import 'freelancer_profile_update.dart';
import 'job_details_page.dart';
import 'login_form.dart';

class FreelancerDashboard extends StatefulWidget {
  const FreelancerDashboard({Key? key}) : super(key: key);

  @override
  _FreelancerDashboardState createState() => _FreelancerDashboardState();
}

class _FreelancerDashboardState extends State<FreelancerDashboard> {
  String? profileImageUrl;
  int? profileID;

  // Example token (you might fetch this from shared preferences or some other state management solution)
  String? token;

  String username = '';

  //for dark mode .to-do
  bool isDarkMode = false;

  List<dynamic> jobs = []; // To store the list of jobs
  List<dynamic> filteredJobs = []; // List for filtered jobs
  List<dynamic> likedJobs = []; // List to store liked jobs

  String selectedCategory = 'All'; // Default category selection
  final TextEditingController _searchController = TextEditingController(); // Controller for search bar

  @override
  void initState() {
    super.initState();
    _getToken();
    _getUserId(); // Fetch the token when dashboard initializes
    _loadUserFullName(); // Load the username from preferences when the screen is initialized
    _fetchAllJobs(); // Fetch jobs when the dashboard initializes
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

  Future<void> _loadUserProfile() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/freelancerProfile'),
      headers: {
        'Authorization': 'Bearer $token', // Add the token in the header
        'Content-Type': 'application/json', // Optional, depending on your API
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var profileData = data['data']; // Access the nested 'data' key
      // Replace 'localhost' with your local IP address
      String localIp = '127.0.0.1'; // Replace this with your actual local IP

      setState(() {
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

  Future<void> _fetchAllJobs() async {
    try {
      // Make a GET request to fetch the jobs
      final response = await http
          .get(Uri.parse(ApiEndpoints.getJobs));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON data
        final data = json.decode(response.body);

        // Extract the list of jobs from the response
        setState(() {
          jobs = data[
              'jobs']; // Assuming 'jobs' is the key containing the job list
          filteredJobs = jobs; // Initially display all jobs
        });
      } else {
        print('Failed to load jobs');
      }
    } catch (error) {
      print('Error fetching jobs: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Define a function to refresh the page
    Future<void> _refreshDashboard() async {
      // Simulate a network call or data refresh, e.g., fetch new data
      await Future.delayed(Duration(seconds: 1));

      // Optionally, update the state with new data
      setState(() {
        // Update state or refresh data here
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi! $username',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange),
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
                            : 'F', // Default character if username is empty
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
              _buildSearchBar(), // Search bar at the top
              _buildCategoryDropdown(), // Dropdown for category selection
              _buildJobCards(), // Job listings
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search jobs...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          setState(() {
            if (value.isEmpty) {
              filteredJobs =
                  jobs; // Reset to show all jobs if search query is empty
            } else {
              // Filter jobs based on the search query
              filteredJobs = jobs
                  .where((job) =>
                      job['title'].toLowerCase().contains(value.toLowerCase()))
                  .toList();
            }
          });
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButton<String>(
        value: selectedCategory,
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue!;
            // Optionally, trigger a filter for the selected category
          });
        },
        items: <String>[
          'All',
          'Backend Development',
          'Frontend Development',
          'Full-Stack Development',
          'Mobile App Development',
          'API Development & Integration',
          'Database Design & Management',
          'UI/UX Design',
          'Graphic Design & Branding',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  // Function to handle job liking
  void _likeJob(int jobId) {
    setState(() {
      if (likedJobs.contains(jobId)) {
        likedJobs.remove(jobId); // Unlike if already liked
      } else {
        likedJobs.add(jobId); // Add to liked jobs if not already liked
      }

      // Optionally, you can send this information to the backend here
      // to persist the liked jobs to the freelancer's profile
    });
  }

  Set<int> visibleCommentFields = {}; // Keeps track of job IDs with visible comment fields
  final TextEditingController _commentController = TextEditingController();

  Widget _buildJobCards() {
    // Reverse the filteredJobs list once instead of in every build call
    final reversedJobs = filteredJobs.reversed.toList();
    // Check if there are any jobs to display
    if (filteredJobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No jobs available right now.',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: reversedJobs.length, // Use the reversed list for displaying
      itemBuilder: (context, index) {
        var job = reversedJobs[index]; // Get the job directly from the reversed list
        // Skip jobs not matching the selected category
        if (selectedCategory != 'All' && job['category'] != selectedCategory) {
          return SizedBox.shrink(); // Return an empty widget if not matched
        }
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              // Navigate to a detailed view of the job when the card is tapped
              _viewJobDetails(job['job_id']);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Client Profile Row
                  Row(
                    children: [
                      // Client Profile Picture or Initial
                      GestureDetector(
                        onTap: () {
                          _viewClientDetails(job['client_id'],
                              context); // Navigate to the client profile
                        },
                        child: ClipOval(
                          child: job['client_profile_picture'] != null &&
                                  job['client_profile_picture'].isNotEmpty
                              ? Image.network(
                                  job['client_profile_picture'],
                                  // URL for client's profile picture
                                  width: 40.0,
                                  height: 40.0,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 40.0,
                                  height: 40.0,
                                  alignment: Alignment.center,
                                  color: Colors.grey[300],
                                  // Background color for placeholder
                                  child: Text(
                                    job['client_name'][0].toUpperCase(),
                                    // Display first letter of client's name
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      // Client Name
                      GestureDetector(
                        onTap: () {
                          _viewClientDetails(job['client_id'],
                              context); // Navigate to the client profile
                        },
                        child: Text(
                          job['client_name'], // Display client's name
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  // Space between client info and job title
                  // Job Title
                  Text(
                    job['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    maxLines: 2, // Allow the title to wrap into 2 lines
                    overflow:
                        TextOverflow.ellipsis, // Show "..." if text is too long
                  ),
                  SizedBox(height: 4.0),
                  // Space between title and description
                  // Job Description
                  Text(
                    job['description'],
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    maxLines: 2, // Limit the description to 2 lines
                    overflow: TextOverflow.ellipsis, // Show "..." for long text
                  ),
                  SizedBox(height: 8.0),
                  // Space before the buttons
                  // Action Buttons Row
                  Row(
                    children: [
                      // Like and Comment Buttons on the left side
                      Row(
                        children: [
                          // Like Button
                          IconButton(
                            icon: Icon(
                              likedJobs.contains(job['job_id'])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: likedJobs.contains(job['job_id'])
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _likeJob(
                                  job['job_id']); // Handle like button press
                            },
                          ),
                          // Comment Button
                          // Comment Button
                          IconButton(
                            icon: Icon(Icons.comment),
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                if (visibleCommentFields.contains(job['job_id'])) {
                                  visibleCommentFields.remove(job['job_id']); // Hide the comment field if already visible
                                } else {
                                  visibleCommentFields.add(job['job_id']); // Show the comment field if hidden
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      // Spacer to push the Send Proposal button to the right
                      Spacer(),
                      // Send Proposal Button on the right side
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => ProposalForm(
                              jobId: job['job_id'],
                            ),
                          );
                        },
                        child: Text(
                          'Send Proposal',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  // Display the comment input field if the job is in the visibleCommentFields set
                  if (visibleCommentFields.contains(job['job_id']))
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Write a comment...',
                              border: UnderlineInputBorder( // Keep only the bottom border
                                borderSide: BorderSide(color: Colors.grey), // Set the color of the bottom border
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepOrange), // Color of the border when focused
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send), // Use the send icon
                                onPressed: () {
                                  String comment = _commentController.text.trim();
                                  if (comment.isNotEmpty) {
                                    _submitComment(job['job_id'], comment); // Submit the comment
                                    _commentController.clear(); // Clear the input after submission
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Method to navigate to the ClientProfilePage
  void _viewClientDetails(int clientId, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientProfilePage(
            clientId: clientId), // Pass the clientId to the profile page
      ),
    );
  }

  void _viewJobDetails(int jobId) {
    // Implement navigation or modal to show job details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            JobDetailsPage(jobId: jobId), // Navigate to a job details page
      ),
    );
  }

  void _submitComment(int jobId, String comment) {
    // You can implement the logic here to save the comment
    // For example, sending the comment to the backend:

    // Example: Call an API to submit the comment
    /*
  var response = await http.post(
    Uri.parse('https://yourapi.com/submit-comment'),
    body: jsonEncode({
      'job_id': jobId,
      'comment': comment,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    // Handle success (e.g., show a confirmation message or update the UI)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comment submitted successfully')),
    );
  } else {
    // Handle error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to submit comment')),
    );
  }
  */

    // For now, you can use this to simulate comment submission:
    // print('Comment submitted for job ID $jobId: $comment');
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
                style: TextStyle(color: Colors.deepOrange, fontSize: 24, fontWeight: FontWeight.bold),
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
            leading: Icon(Icons.work), // Icon for My Projects
            title: Text('My Projects'),
            onTap: () {
              // Implement navigation to My Projects
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money), // Icon for Earnings
            title: Text('Earnings'),
            onTap: () {
              // Implement navigation to Earnings
            },
          ),
          ListTile(
            leading: Icon(Icons.star), // Icon for Ratings
            title: Text('Ratings'),
            onTap: () {
              // Implement navigation to Ratings
            },
          ),

          ListTile(
            leading: Icon(Icons.leaderboard), // Icon for Leaderboard
            title: Text('Leaderboard'),
            onTap: () {
              // Implement navigation to Leaderboard
            },
          ),
          // Dark mode toggle
          Container(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.light_mode),
                  title: Text('Light theme'),
                  onTap: (){
                    Get.changeTheme(ThemeData.light());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.dark_mode),
                  title: Text('Dark theme'),
                  onTap: (){
                    Get.changeTheme(ThemeData.dark());
                  },
                ),
              ],
            ),
          ),
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
          'http://localhost:3000/api/freelancerProfile/check-profile/$user_id'),
      // Check your API endpoint
      headers: {
        'Authorization': 'Bearer $token',
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

    if (profileExists && profileID != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FreelancerProfileUpdate(profileID: profileID!),
        ),
      );
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
                          builder: (context) => FreelancerProfileCreation()));
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
}

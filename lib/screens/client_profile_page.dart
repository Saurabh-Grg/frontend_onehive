import 'package:flutter/material.dart';

class ClientProfilePage extends StatelessWidget {
  final int clientId; // ID of the client

  ClientProfilePage({required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchClientData(clientId), // Fetch client data from the backend
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching client data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          var clientData = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client Profile Section
                Row(
                  children: [
                    // Display client profile picture or placeholder
                    ClipOval(
                      child: clientData['profile_picture'] != null &&
                          clientData['profile_picture'].isNotEmpty
                          ? Image.network(
                        clientData['profile_picture'],
                        width: 80.0,
                        height: 80.0,
                        fit: BoxFit.cover,
                      )
                          : Container(
                        width: 80.0,
                        height: 80.0,
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: Text(
                          clientData['name'][0].toUpperCase(),
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // Client Name and Basic Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientData['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Member since: ${clientData['member_since']}',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Divider(),

                // Client Stats Section
                Text(
                  'Client Stats',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 16.0),
                _buildStatsRow('Jobs Posted', clientData['jobs_posted'].toString()),
                _buildStatsRow('Successful Payments', clientData['successful_payments'].toString()),
                _buildStatsRow('Average Rating', clientData['average_rating'].toString()),
                _buildStatsRow('Total Paid Amount', '\$${clientData['total_paid']}'),
                _buildStatsRow('Jobs Completed', clientData['jobs_completed'].toString()),
                SizedBox(height: 16.0),
                Divider(),

                // Client Job History Section
                Text(
                  'Job History',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: clientData['job_history'].length,
                  itemBuilder: (context, index) {
                    var job = clientData['job_history'][index];
                    return ListTile(
                      title: Text(job['title']),
                      subtitle: Text('Paid: \$${job['amount_paid']}'),
                      trailing: Text('Status: ${job['status']}'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Function to fetch client data from backend
  Future<Map<String, dynamic>> _fetchClientData(int clientId) async {
    // Make a request to the backend to get client details by client ID
    // Replace with actual API call
    // This is just an example structure
    return {
      'name': 'John Doe',
      'profile_picture': '',
      'member_since': 'January 2023',
      'jobs_posted': 12,
      'successful_payments': 10,
      'average_rating': 4.5,
      'total_paid': 2500.00,
      'jobs_completed': 9,
      'job_history': [
        {'title': 'Backend Developer', 'amount_paid': 500, 'status': 'Completed'},
        {'title': 'Frontend Developer', 'amount_paid': 300, 'status': 'In Progress'},
        // More jobs...
      ]
    };
  }

  // Helper method to build a stat row
  Widget _buildStatsRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

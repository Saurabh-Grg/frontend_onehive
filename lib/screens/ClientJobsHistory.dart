import 'package:flutter/material.dart';

class ClientJobsHistory extends StatelessWidget {
  const ClientJobsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Job History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}



// dictionary for filtering words, package
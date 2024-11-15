import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> leaderboard = [];
  String username = "";
  int currentScore = 0;

  @override
  void initState() {
    super.initState();
    loadLeaderboardData();
  }

  Future<void> loadLeaderboardData() async {
    final prefs = await SharedPreferences.getInstance();

    username = prefs.getString('username') ?? "Guest";

    currentScore = prefs.getInt('currentMarks') ?? 0;

    final List<dynamic> storedScores =
        jsonDecode(prefs.getString('userScores') ?? '[]');
    setState(() {
      leaderboard = List<Map<String, dynamic>>.from(storedScores);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 46, 43),
        title: Center(
          child: Text(
            'Dashboard',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 46, 43),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $username',
                        style: TextStyle(
                          fontSize: screenWidth < 400 ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 46, 43),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your Current Score: $currentScore',
                        style: TextStyle(
                          fontSize: screenWidth < 400 ? 16 : 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: screenWidth < 400 ? 20 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: leaderboard.isNotEmpty
                    ? ListView.builder(
                        itemCount: leaderboard.length,
                        itemBuilder: (context, index) {
                          final user = leaderboard[index];
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 128, 115),
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                user['name'],
                                style: TextStyle(
                                  fontSize: screenWidth < 400 ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                '${user['score']} pts',
                                style: TextStyle(
                                  fontSize: screenWidth < 400 ? 14 : 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No scores available.',
                          style: TextStyle(
                            fontSize: screenWidth < 400 ? 16 : 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

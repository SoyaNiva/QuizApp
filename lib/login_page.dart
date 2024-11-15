import 'package:flutter/material.dart';
import 'package:quizapp/quizround_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveUserInfo(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
    await prefs.setInt('totalMarks', 0);
    await prefs.setInt('currentMarks', 0);
  }

  Future<void> _checkUserInfo(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    int? totalMarks = prefs.getInt('totalMarks');
    int? currentMarks = prefs.getInt('currentMarks');

    print('Username: $username');
    print('Total Marks: $totalMarks');
    print('Current Marks: $currentMarks');

    if (username != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Username: $username, Total Marks: $totalMarks, Current Marks: $currentMarks'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              color: const Color.fromARGB(255, 0, 46, 43),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: screenWidth * 0.5,
                      height: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: screenWidth * 0.1,
                            child: Text(
                              'QUIZ',
                              style: TextStyle(
                                fontSize: screenWidth * 0.08,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 0, 46, 43),
                              ),
                            ),
                          ),
                          Positioned(
                            top: screenWidth * 0.22,
                            child: Text(
                              'Master',
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 0, 46, 43),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Enter your name',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Your Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: screenWidth * 0.03,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: screenWidth * 0.8,
                      child: ElevatedButton(
                        onPressed: () async {
                          final name = _nameController.text;
                          if (name.isNotEmpty) {
                            await _saveUserInfo(name);
                            await _checkUserInfo(context);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizQuestionPage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please enter your name')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 68, 90, 255),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Start Quiz',
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

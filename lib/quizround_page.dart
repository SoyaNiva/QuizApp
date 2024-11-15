import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quizapp/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class QuizQuestionPage extends StatefulWidget {
  @override
  _QuizQuestionPageState createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  int currentQuestionIndex = 0;
  int totalQuestions = 50;
  int timer = 30;
  int score = 0;
  Timer? countdownTimer;
  int? selectedOptionIndex;
  PageController _pageController = PageController();

  static const List<String> dummyQuestions = [
    "What is the capital of France?",
    "Who wrote 'Romeo and Juliet'?",
    "What is the chemical symbol for water?",
    "How many continents are there?",
    "What is the largest planet in our solar system?",
    "Which planet is known as the Red Planet?",
    "Who painted the Mona Lisa?",
    "What is the square root of 64?",
    "Who discovered gravity?",
    "Which is the longest river in the world?",
    "What is the largest mammal?",
    "Which element has the atomic number 1?",
    "Who was the first man on the moon?",
    "What is the boiling point of water in Celsius?",
    "Which country is famous for sushi?",
    "What is the tallest mountain in the world?",
    "What is the currency of Japan?",
    "Which planet has a ring system?",
    "What is the speed of light in vacuum (in m/s)?",
    "Who invented the telephone?",
    "What is the capital of Italy?",
    "How many players are there in a soccer team?",
    "What is the freezing point of water in Celsius?",
    "Which organ pumps blood in the human body?",
    "What is the currency of the United States?",
    "Which metal is liquid at room temperature?",
    "Who is known as the Father of Computers?",
    "How many colors are in a rainbow?",
    "What is the main gas found in the air we breathe?",
    "How many sides does a hexagon have?",
    "What is the largest ocean on Earth?",
    "Which language has the most native speakers?",
    "What is the smallest country in the world?",
    "Which animal is known as the King of the Jungle?",
    "Who invented the light bulb?",
    "What is the capital of Australia?",
    "What is the hardest natural substance?",
    "Who wrote 'Harry Potter'?",
    "How many letters are in the English alphabet?",
    "What is the main ingredient in bread?",
    "How many bones are in the human body?",
    "What is the color of chlorophyll?",
    "What is the nearest star to Earth?",
    "How many planets are in our solar system?",
    "Which organ is responsible for filtering blood?",
    "Who developed the theory of relativity?",
    "What is the capital of Canada?",
    "Which planet is closest to the sun?",
    "What is the process plants use to make food?",
    "Who painted the ceiling of the Sistine Chapel?",
    "What is the main language spoken in Brazil?",
  ];

  static const List<List<String>> dummyOptions = [
    ["Paris", "Berlin", "Rome", "Madrid"],
    ["Shakespeare", "Dickens", "Tolkien", "Austen"],
    ["H2O", "O2", "CO2", "NaCl"],
    ["5", "6", "7", "8"],
    ["Earth", "Mars", "Jupiter", "Saturn"],
    ["Mars", "Venus", "Jupiter", "Saturn"],
    ["Leonardo da Vinci", "Michelangelo", "Raphael", "Donatello"],
    ["8", "7", "6", "9"],
    ["Newton", "Einstein", "Galileo", "Darwin"],
    ["Nile", "Amazon", "Yangtze", "Mississippi"],
    ["Elephant", "Blue Whale", "Giraffe", "Shark"],
    ["Hydrogen", "Oxygen", "Nitrogen", "Carbon"],
    ["Armstrong", "Aldrin", "Glenn", "Gagarin"],
    ["100", "90", "80", "110"],
    ["Japan", "China", "Korea", "Vietnam"],
    ["Everest", "K2", "Kangchenjunga", "Lhotse"],
    ["Yen", "Dollar", "Euro", "Peso"],
    ["Saturn", "Mars", "Venus", "Mercury"],
    ["299,792,458", "300,000,000", "150,000,000", "1,000,000"],
    ["Bell", "Edison", "Tesla", "Newton"],
    ["Rome", "Venice", "Florence", "Milan"],
    ["11", "10", "9", "8"],
    ["0", "10", "-10", "100"],
    ["Heart", "Lung", "Liver", "Kidney"],
    ["Dollar", "Euro", "Pound", "Yen"],
    ["Mercury", "Lead", "Gold", "Silver"],
    ["Babbage", "Turing", "Gates", "Jobs"],
    ["7", "8", "6", "5"],
    ["Oxygen", "Nitrogen", "Carbon Dioxide", "Argon"],
    ["6", "7", "8", "5"],
    ["Pacific", "Atlantic", "Indian", "Arctic"],
    ["Chinese", "English", "Hindi", "Spanish"],
    ["Vatican City", "Monaco", "San Marino", "Malta"],
    ["Lion", "Tiger", "Elephant", "Wolf"],
    ["Edison", "Tesla", "Bell", "Newton"],
    ["Canberra", "Sydney", "Melbourne", "Perth"],
    ["Diamond", "Gold", "Iron", "Steel"],
    ["Rowling", "Tolkien", "Lewis", "King"],
    ["26", "24", "25", "27"],
    ["Flour", "Sugar", "Salt", "Yeast"],
    ["206", "210", "220", "205"],
    ["Green", "Blue", "Red", "Yellow"],
    ["Sun", "Alpha Centauri", "Sirius", "Betelgeuse"],
    ["8", "9", "10", "7"],
    ["Kidney", "Liver", "Heart", "Lungs"],
    ["Einstein", "Newton", "Galileo", "Hawking"],
    ["Ottawa", "Toronto", "Vancouver", "Montreal"],
    ["Mercury", "Venus", "Earth", "Mars"],
    ["Photosynthesis", "Respiration", "Evaporation", "Osmosis"],
    ["Michelangelo", "Da Vinci", "Raphael", "Donatello"],
    ["Portuguese", "Spanish", "English", "French"],
  ];

  static const List<int> dummyAnswers = [
    0, // Paris
    0, // Shakespeare
    0, // H2O
    2, // 7 continents
    2, // Jupiter
    0, // Mars
    0, // Leonardo da Vinci
    0, // 8
    0, // Newton
    1, // Amazon
    1, // Blue Whale
    0, // Hydrogen
    0, // Armstrong
    0, // 100
    0, // Japan
    0, // Everest
    0, // Yen
    0, // Saturn
    0, // 299,792,458 m/s
    0, // Bell
    0, // Rome
    3, // 8 players
    0, // 0 Celsius
    0, // Heart
    0, // Dollar
    0, // Mercury
    0, // Babbage
    0, // 7 colors
    1, // Nitrogen
    0, // 6 sides
    0, // Pacific Ocean
    0, // Chinese
    0, // Vatican City
    0, // Lion
    0, // Edison
    0, // Canberra
    0, // Diamond
    0, // Rowling
    0, // 26 letters
    0, // Flour
    0, // 206 bones
    0, // Green
    0, // Sun
    0, // 8 planets
    0, // Kidney
    0, // Einstein
    0, // Ottawa
    0, // Mercury
    0, // Photosynthesis
    0, // Michelangelo
    0, // Portuguese
  ];

  String username = "";

  @override
  void initState() {
    super.initState();
    loadUsername();
    startTimer();
    loadScore();
  }

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "Guest";
    });
  }

  Future<void> loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      score = prefs.getInt('currentMarks') ?? 0;
    });
  }

  Future<void> saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentMarks', score);
  }

  void startTimer() {
    countdownTimer?.cancel();
    setState(() {
      timer = 30;
    });
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (this.timer > 0) {
          this.timer--;
        } else {
          nextQuestion();
          timer.cancel();
        }
      });
    });
  }

  void nextQuestion() {
    if (selectedOptionIndex == dummyAnswers[currentQuestionIndex]) {
      setState(() {
        score++;
      });
      saveScore();
    }
    countdownTimer?.cancel();

    if (currentQuestionIndex < totalQuestions - 1) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      setState(() {
        currentQuestionIndex++;
        timer = 30;
        selectedOptionIndex = null;
      });
      startTimer();
    } else {
      saveScoreToLeaderboard(score).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      });
    }
  }

  Future<void> saveScoreToLeaderboard(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final List<dynamic> existingScores =
        jsonDecode(prefs.getString('userScores') ?? '[]');

    existingScores.add({'name': username, 'score': score});
    await prefs.setString('userScores', jsonEncode(existingScores));
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Score: $score',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Spacer(),
            Text(
              '${currentQuestionIndex + 1}/$totalQuestions',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 8),
                Text('Previous',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                Spacer(),
                Text('${currentQuestionIndex + 1}/$totalQuestions',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentQuestionIndex = index;
                    timer = 30;
                    selectedOptionIndex = null;
                  });
                  startTimer();
                },
                itemCount: dummyQuestions.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: CircularProgressIndicator(
                                  value: timer / 30,
                                  strokeWidth: 5,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.green),
                                ),
                              ),
                              Text('$timer',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(dummyQuestions[index],
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center),
                          SizedBox(height: 24),
                          Column(
                            children: List.generate(dummyOptions[index].length,
                                (optionIndex) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedOptionIndex = optionIndex;
                                  });
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: selectedOptionIndex == optionIndex
                                        ? Colors.green[100]
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: selectedOptionIndex == optionIndex
                                          ? Colors.green
                                          : Colors.grey,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(dummyOptions[index][optionIndex],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black)),
                                      Checkbox(
                                        value:
                                            selectedOptionIndex == optionIndex,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedOptionIndex = optionIndex;
                                          });
                                        },
                                        activeColor: Colors.green,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: nextQuestion,
                child: Text('Next',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

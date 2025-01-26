import 'package:flutter/material.dart';


class GameScoreScreen extends StatefulWidget {
  final List<String> playerNames;
  final int betValue;

  GameScoreScreen({required this.playerNames, required this.betValue});

  @override
  _GameScoreScreenState createState() => _GameScoreScreenState();
}

class _GameScoreScreenState extends State<GameScoreScreen> {
  late List<int> scores;

  @override
  void initState() {
    super.initState();
    scores = List.filled(widget.playerNames.length, 0);
  }

  void _adjustScore(int index, int adjustment) {
    setState(() {
      scores[index] += adjustment * widget.betValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust the number of columns dynamically based on screen width
    final crossAxisCount = screenWidth > 800 ? 3 : (screenWidth > 500 ? 2 : 1);

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Scores'),
        backgroundColor: Colors.green[800],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Dynamic columns
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            childAspectRatio: screenWidth / (screenHeight / 2.5),
          ),
          itemCount: widget.playerNames.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.green[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.playerNames[index],
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Score: ${scores[index]}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _adjustScore(index, 1),
                          icon: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: screenWidth * 0.05,
                          ),
                          label: Text(
                            'Add',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            backgroundColor: Colors.green[700],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _adjustScore(index, -1),
                          icon: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: screenWidth * 0.05,
                          ),
                          label: Text(
                            'Lose',
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            backgroundColor: Colors.red[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:black_jack/LeaderBoardScreen.dart'; 

class GameScoreScreen extends StatefulWidget {
  final List<String> playerNames;
  final int betValue;

  GameScoreScreen({required this.playerNames, required this.betValue});

  @override
  _GameScoreScreenState createState() => _GameScoreScreenState();
}

class _GameScoreScreenState extends State<GameScoreScreen> {
  late List<int> scores;
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    scores = List.filled(widget.playerNames.length, 0);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isTimerRunning = false;
    });
    _timer.cancel();
  }

  void _adjustScore(int index, int adjustment) {
    setState(() {
      scores[index] += adjustment * widget.betValue;
    });
  }

  void _winDouble(int index) {
    setState(() {
      scores[index] += 2 * widget.betValue;
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _endGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaderBoardScreen(
          playerNames: widget.playerNames,
          scores: scores,
          gameDuration: Duration(seconds: _elapsedSeconds),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust the number of columns dynamically based on screen width
    final crossAxisCount = screenWidth > 800 ? 3 : (screenWidth > 500 ? 2 : 1);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Game Score', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(
              'Timer: ${_formatTime(_elapsedSeconds)}',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.green[800],
        centerTitle: true,
        actions: [
          if (_isTimerRunning)
            IconButton(
              onPressed: _stopTimer,
              icon: Icon(Icons.pause),
            )
          else
            IconButton(
              onPressed: _startTimer,
              icon: Icon(Icons.play_arrow),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 2.5,
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
                              ElevatedButton(
                                onPressed: () => _adjustScore(index, 1),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(16.0),
                                  backgroundColor: Colors.green[700],
                                ),
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                              ElevatedButton(
                                onPressed: () => _winDouble(index),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(16.0),
                                  backgroundColor: Colors.blue[600],
                                ),
                                child: Icon(Icons.star, color: Colors.white),
                              ),
                              ElevatedButton(
                                onPressed: () => _adjustScore(index, -1),
                                style: ElevatedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(16.0),
                                  backgroundColor: Colors.red[400],
                                ),
                                child: Icon(Icons.remove, color: Colors.white),
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
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 16.0), // Adds space above the bottom edge
            child: ElevatedButton(
              onPressed: _endGame,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                backgroundColor: Colors.orange,
              ),
              child: Text(
                'End Game',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

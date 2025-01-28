import 'package:flutter/material.dart';
import 'dart:async';
import 'package:black_jack/LeaderBoardScreen.dart';

class GameScoreScreen extends StatefulWidget {
  final List<String> playerNames;
  final int betValue;

  const GameScoreScreen({super.key, required this.playerNames, required this.betValue});

  @override
  _GameScoreScreenState createState() => _GameScoreScreenState();
}

class _GameScoreScreenState extends State<GameScoreScreen> {
  late List<int> scores;
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isTimerRunning = false;
  late int _currentBetValue;

  @override
  void initState() {
    super.initState();
    scores = List.filled(widget.playerNames.length, 0);
    _currentBetValue = widget.betValue;
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

  void _changeBetValue() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController(text: '$_currentBetValue');
        return AlertDialog(
          backgroundColor: Colors.deepPurple[900],
          title: Text('Change Bet Value', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter new bet value',
              labelStyle: TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentBetValue = int.tryParse(controller.text) ?? _currentBetValue;
                });
                Navigator.pop(context);
              },
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _adjustScore(int index, int adjustment) {
    setState(() {
      scores[index] += adjustment * _currentBetValue;
    });
  }

  void _winDouble(int index) {
    setState(() {
      scores[index] += 2 * _currentBetValue;
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

    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Mystical Night Game',
              style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              'Timer: ${_formatTime(_elapsedSeconds)}',
              style: TextStyle(fontSize: 16.0, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: Colors.purple[900],
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _changeBetValue,
            icon: Icon(Icons.settings),
            tooltip: 'Change Bet Value',
            color: Colors.white,
          ),
          if (_isTimerRunning)
            IconButton(
              onPressed: _stopTimer,
              icon: Icon(Icons.pause),
              tooltip: 'Pause Timer',
              color: Colors.white,
            )
          else
            IconButton(
              onPressed: _startTimer,
              icon: Icon(Icons.play_arrow),
              tooltip: 'Start Timer',
              color: Colors.white,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bet Value: $_currentBetValue',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.orange[300]),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),  // Reduced padding here
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 800 ? 3 : (screenWidth > 500 ? 2 : 1),
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 2.5,
              ),
              itemCount: widget.playerNames.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.deepPurple[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),  // Reduced border radius
                  ),
                  elevation: 6.0,  // Reduced elevation
                  shadowColor: Colors.black54,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),  // Reduced padding inside the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.playerNames[index],
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Score: ${scores[index]}',
                          style: TextStyle(fontSize: 18.0, color: Colors.orange[300]),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // Used spaceEvenly for a balanced layout
                          children: [
                            ElevatedButton(
                              onPressed: () => _adjustScore(index, 1),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12.0),
                                backgroundColor: Colors.green[600],
                                elevation: 6.0,
                              ),
                              child: Icon(Icons.add, color: Colors.white, size: 25.0),
                            ),
                            ElevatedButton(
                              onPressed: () => _winDouble(index),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12.0),
                                backgroundColor: Colors.blue[700],
                                elevation: 6.0,
                              ),
                              child: Icon(Icons.star, color: Colors.white, size: 25.0),
                            ),
                            ElevatedButton(
                              onPressed: () => _adjustScore(index, -1),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(12.0),
                                backgroundColor: Colors.red[400],
                                elevation: 6.0,
                              ),
                              child: Icon(Icons.remove, color: Colors.white, size: 25.0),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: _endGame,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                backgroundColor: Colors.orange[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 8.0,
              ),
              child: Text(
                'End Game',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

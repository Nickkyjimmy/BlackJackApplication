import 'package:flutter/material.dart';
import 'dart:async';
import 'package:black_jack/LeaderBoardScreen.dart';

class GameScoreScreen extends StatefulWidget {
  final List<String> playerNames;
  final int betValue;
  final String hostName;

  const GameScoreScreen(
      {super.key, required this.hostName, required this.playerNames, required this.betValue});

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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        TextEditingController controller =
            TextEditingController(text: '$_currentBetValue');
        return AlertDialog(
          backgroundColor: Colors.deepPurple[900],
          title:
              const Text('Change Bet Value', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
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
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _currentBetValue =
                      int.tryParse(controller.text) ?? _currentBetValue;
                });
                Navigator.pop(context);
              },
              child: const Text('OK', style: TextStyle(color: Colors.white)),
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
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Xi Dach Game',
              style: TextStyle(
                fontSize: isLandscape ? 18.0 : 26.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Timer: ${_formatTime(_elapsedSeconds)}',
              style: TextStyle(
                fontSize: isLandscape ? 12.0 : 16.0,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple[900],
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _changeBetValue,
            icon: Icon(
              Icons.settings,
              size: isLandscape ? 20.0 : 30.0,
              color: Colors.white,
            ),
            tooltip: 'Change Bet Value',
          ),
          IconButton(
            onPressed: _isTimerRunning ? _stopTimer : _startTimer,
            icon: Icon(
              _isTimerRunning ? Icons.pause : Icons.play_arrow,
              size: isLandscape ? 20.0 : 30.0,
              color: Colors.white,
            ),
            tooltip: _isTimerRunning ? 'Pause Timer' : 'Start Timer',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(isLandscape ? 8.0 : 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bet Value: $_currentBetValue',
                  style: TextStyle(
                    fontSize: isLandscape ? 18.0 : 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[300],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(isLandscape ? 4.0 : 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 800 ? 3 : (screenWidth > 500 ? 2 : 1),
                crossAxisSpacing: isLandscape ? 8.0 : 16.0,
                mainAxisSpacing: isLandscape ? 8.0 : 16.0,
                childAspectRatio: screenWidth > 500 ? 2 : 2.5,
              ),
              itemCount: widget.playerNames.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.deepPurple[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 6.0,
                  child: Padding(
                    padding: EdgeInsets.all(isLandscape ? 8.0 : 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.playerNames[index],
                          style: TextStyle(
                            fontSize: isLandscape ? 16.0 : 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Score: ${scores[index]}',
                          style: TextStyle(
                            fontSize: isLandscape ? 14.0 : 18.0,
                            color: Colors.orange[300],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildScoreButton(Icons.add, Colors.green[600],
                                isLandscape, () {
                              _adjustScore(index, 1);
                            }),
                            _buildScoreButton(Icons.star, Colors.blue[700],
                                isLandscape, () {
                              _winDouble(index);
                            }),
                            _buildScoreButton(Icons.remove, Colors.red[400],
                                isLandscape, () {
                              _adjustScore(index, -1);
                            }),
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
            padding: EdgeInsets.only(
              bottom: isLandscape ? 8.0 : 16.0,
            ),
            child: ElevatedButton(
              onPressed: _endGame,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: isLandscape ? 8.0 : 16.0,
                  horizontal: isLandscape ? 16.0 : 32.0,
                ),
                backgroundColor: Colors.orange[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 8.0,
              ),
              child: Text(
                'End Game',
                style: TextStyle(
                  fontSize: isLandscape ? 18.0 : 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(isLandscape ? 4.0 : 8.0),
            child: const Text(
              '© 2025 ThaiTuNhaBe 🕹️. All Rights Reserved.',
              style: TextStyle(fontSize: 14.0, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreButton(
      IconData icon, Color? color, bool isLandscape, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(isLandscape ? 8.0 : 12.0),
        backgroundColor: color,
        elevation: 6.0,
      ),
      child: Icon(icon, color: Colors.white, size: isLandscape ? 20.0 : 25.0),
    );
  }
}

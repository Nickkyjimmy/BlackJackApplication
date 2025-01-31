import 'package:flutter/material.dart';
import 'dart:async';
import 'package:black_jack/LeaderBoardScreen.dart';

class GameScoreScreen extends StatefulWidget {
  final List<String> playerNames;
  final int betValue;
  final String hostName;

  const GameScoreScreen(
      {super.key,
      required this.hostName,
      required this.playerNames,
      required this.betValue});

  @override
  _GameScoreScreenState createState() => _GameScoreScreenState();
}

class _GameScoreScreenState extends State<GameScoreScreen> {
  late List<int> scores;
  late List<int> wins; // New list to track wins
  late List<int> losses; // New list to track losses
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _isTimerRunning = false;
  late int _currentBetValue;

  @override
  void initState() {
    super.initState();
    scores = List.filled(widget.playerNames.length, 0);
    wins = List.filled(widget.playerNames.length, 0); // Initialize wins
    losses = List.filled(widget.playerNames.length, 0); // Initialize losses
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
          title: const Text('Change Bet Value',
              style: TextStyle(color: Colors.white)),
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
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
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
      if (adjustment > 0) {
        wins[index] += 1; // Increment win for positive adjustment
      } else if (adjustment < 0) {
        losses[index] += 1; // Increment loss for negative adjustment
      }
    });
  }

  void _winDouble(int index) {
    setState(() {
      scores[index] += 2 * _currentBetValue;
      wins[index] += 1; // Increment win for winning double
    });
  }

  int _calculateBalance() {
    return (-(scores.fold(0, (sum, score) => sum + score)));
  }

  String _formatBalance(int balance) {
    String formattedBalance = balance.abs().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
    return balance >= 0 ? "+$formattedBalance" : "-$formattedBalance";
  }

  Color _getBalanceColor(int balance) {
    if (balance > 0) {
      return Colors.greenAccent;
    } else if (balance < 0) {
      return Colors.redAccent;
    }
    return Colors.white;
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // int _getTotalRound() {
  //   int totalRounds = 0;

  //   // Calculate total rounds by summing wins and losses for each player
  //   for (int i = 0; i < widget.playerNames.length; i++) {
  //     totalRounds += wins[i] + losses[i];
  //   }
  //   return totalRounds;
  // }

  void _endGame() {
    int hostEarnings = _calculateBalance();
    // int totalRounds = _getTotalRound();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaderBoardScreen(
            playerNames: widget.playerNames,
            // totalRounds: totalRounds,
            scores: scores,
            gameDuration: Duration(seconds: _elapsedSeconds),
            hostName: widget.hostName,
            winningPlayers : wins,
            hostEarnings: hostEarnings),
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
              'Host: ${widget.hostName}',
              style: TextStyle(
                fontSize: isLandscape ? 18.0 : 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Balance: ${_formatBalance(_calculateBalance())}',
              style: TextStyle(
                fontSize: isLandscape ? 12.0 : 16.0,
                fontWeight: FontWeight.bold,
                color: _getBalanceColor(_calculateBalance()),
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
          // Updated Padding for Bet Value and Duration
          Padding(
            padding: EdgeInsets.symmetric(vertical: isLandscape ? 4.0 : 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bet Value: $_currentBetValue',
                  style: TextStyle(
                    fontSize: isLandscape ? 15.0 : 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[300],
                  ),
                ),
              ],
            ),
          ),
          // The Duration padding updated here as well
          Padding(
            padding: EdgeInsets.symmetric(vertical: isLandscape ? 4.0 : 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Elapsed Time: ${_formatTime(_elapsedSeconds)}',
                  style: TextStyle(
                    fontSize: isLandscape ? 12.0 : 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(isLandscape ? 4.0 : 8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    screenWidth > 800 ? 3 : (screenWidth > 500 ? 2 : 1),
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
                        Text(
                          '${wins[index]}W-${losses[index]}L', // Show win-loss
                          style: TextStyle(
                            fontSize: isLandscape ? 14.0 : 18.0,
                            color: Colors.green[300],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildScoreButton(
                                Icons.add, Colors.green[600], isLandscape, () {
                              _adjustScore(index, 1);
                            }),
                            _buildScoreButton(
                                Icons.star, Colors.blue[700], isLandscape, () {
                              _winDouble(index);
                            }),
                            _buildScoreButton(
                                Icons.remove, Colors.red[400], isLandscape, () {
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

          // End Game Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _endGame,
              style: ElevatedButton.styleFrom(
                iconColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                textStyle:
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              child: Text('End Game'),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
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

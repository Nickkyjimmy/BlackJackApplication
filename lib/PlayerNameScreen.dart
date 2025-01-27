import 'package:flutter/material.dart';
import 'GameScoreScreen.dart';

class PlayerNameScreen extends StatelessWidget {
  final int playerCount;
  final TextEditingController betValueController = TextEditingController();
  final List<TextEditingController> playerControllers = [];

  PlayerNameScreen({super.key, required this.playerCount}) {
    for (int i = 0; i < playerCount; i++) {
      playerControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Info'),
        backgroundColor: Colors.green[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // This will pop the current screen and go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...List.generate(playerCount, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextField(
                    controller: playerControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Player ${index + 1} Name',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.green[50],
                    ),
                  ),
                );
              }),
              SizedBox(height: 12),
              TextField(
                controller: betValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Bet Value',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.green[50],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final betValue = int.tryParse(betValueController.text);
                  if (betValue != null && betValue > 0) {
                    final playerNames = playerControllers.map((c) => c.text).toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameScoreScreen(
                          playerNames: playerNames,
                          betValue: betValue,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Enter a valid bet value!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'GameScoreScreen.dart';

class PlayerNameScreen extends StatelessWidget {
  final int playerCount;
  final TextEditingController hostController = TextEditingController();
  final TextEditingController betValueController = TextEditingController();
  final List<TextEditingController> playerControllers = [];

  PlayerNameScreen({super.key, required this.playerCount}) {
    for (int i = 0; i < playerCount; i++) {
      playerControllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Player Info',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ),
          backgroundColor: Colors.deepPurpleAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Title Section
              Text(
                'Enter Game Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),

              // Host Section with Bet Value
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white24,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Host 🎩',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: hostController,
                        decoration: InputDecoration(
                          labelText: 'Host Name',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white24,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Bet Value 💰',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: betValueController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Bet Value',
                          labelStyle: TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white24,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Players Section
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white24,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Players 🎮',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      // Generate TextFields for Player Names dynamically
                      ...List.generate(playerCount, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: TextField(
                            controller: playerControllers[index],
                            decoration: InputDecoration(
                              labelText: 'Player ${index + 1} Name',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white24,
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Start Game Button
              ElevatedButton(
                onPressed: () {
                  final hostName = hostController.text.trim();
                  final betValue = int.tryParse(betValueController.text);
                  final playerNames =
                      playerControllers.map((c) => c.text.trim()).toList();

                  if (hostName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a host name!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  if (playerNames.any((name) => name.isEmpty)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter all player names!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  if (betValue == null || betValue <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Enter a valid bet value!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScoreScreen(
                        hostName: hostName,
                        playerNames: playerNames,
                        betValue: betValue,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.black54,
                  elevation: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Start Game',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

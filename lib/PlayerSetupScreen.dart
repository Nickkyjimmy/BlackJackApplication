import 'package:flutter/material.dart';
import 'package:black_jack/PlayerNameScreen.dart';

class PlayerCountScreen extends StatelessWidget {
  final TextEditingController playerCountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xi Dzach Time !!!!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter the number of players:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              controller: playerCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Players',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.green[50],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final playerCount = int.tryParse(playerCountController.text);
                if (playerCount != null && playerCount > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerNameScreen(playerCount: playerCount),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Enter a valid number of players!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: EdgeInsets.symmetric(vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text('Next', style: TextStyle(fontSize: 20,
                                                color: Colors.white)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:black_jack/PlayerSetupScreen.dart';
// import 'package:audioplayers/audioplayers.dart';

class LeaderBoardScreen extends StatelessWidget {
  final List<String> playerNames;
  final List<int> scores;
  final Duration gameDuration;

  const LeaderBoardScreen({
    super.key,
    required this.playerNames,
    required this.scores,
    required this.gameDuration,
  });

  // Future<void> playSound() async {
  //   final player = AudioPlayer();
  //   await player.play(AssetSource('win_sound.mp3'));
  // }

  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    // Play sound when entering the page
    // WidgetsBinding.instance.addPostFrameCallback((_) => playSound());

    final rankedPlayers = List.generate(playerNames.length, (index) {
      return {'name': playerNames[index], 'score': scores[index]};
    })
      ..sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

    final topPlayers = rankedPlayers.take(3).toList(); // Top 3 players
    final otherPlayers = rankedPlayers.skip(3).toList(); // Remaining players

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Game Duration Display
          Container(
            color: Colors.blue[100],
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Game Duration: ${formatTime(gameDuration)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
          ),
          // Top 3 players
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: List.generate(topPlayers.length, (index) {
                final player = topPlayers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  color: index == 0
                      ? Colors.amber[200]
                      : index == 1
                          ? Colors.grey[300]
                          : Colors.brown[200],
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[700],
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      player['name'] as String,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      'Score: ${player['score']}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              }),
            ),
          ),
          const Divider(thickness: 2.0), // Separate the top and other players
          // Remaining players
          Expanded(
            child: ListView.builder(
              itemCount: otherPlayers.length,
              itemBuilder: (context, index) {
                final player = otherPlayers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[700],
                      child: Text(
                        '#${index + 4}', // Starts from 4
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      player['name'] as String,
                      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      'Score: ${player['score']}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ),
          // Back to Home Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Clear all data
                 Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerCountScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

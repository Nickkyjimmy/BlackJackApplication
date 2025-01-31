import 'package:flutter/material.dart';
import 'package:black_jack/PlayerSetupScreen.dart';

class LeaderBoardScreen extends StatelessWidget {
  final List<String> playerNames;
  final List<int> scores;
  final Duration gameDuration;
  // final int totalRounds;
  final String hostName;
  final int hostEarnings;
  final List<int> winningPlayers;

  const LeaderBoardScreen({
    super.key,
    required this.playerNames,
    required this.scores,
    required this.gameDuration,
    required this.hostName,
    required this.hostEarnings,
    // required this.totalRounds,
    required this.winningPlayers,
  });

  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // Calculate the win rate (win/total rounds)
  // double getWinRate(int wins) {
  //   return (wins / totalRounds) * 100;
  // }

  @override
  Widget build(BuildContext context) {
    final winningPlayers = List.generate(playerNames.length, (index) {
      return {'name': playerNames[index], 'score': scores[index], 'wins': scores[index] > 0 ? 1 : 0};
    }).where((player) => (player['score'] as int) > 0).toList();

    final losingPlayers = List.generate(playerNames.length, (index) {
      return {'name': playerNames[index], 'score': scores[index], 'wins': scores[index] <= 0 ? 0 : 1};
    }).where((player) => (player['score'] as int) <= 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/champion.png',
              height: 30,
              width: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Game Duration: ${formatTime(gameDuration)}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[800]!, Colors.blue[900]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Host Info Section - at the top
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Host: $hostName | Earnings: $hostEarnings VND',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: hostEarnings > 0
                      ? Colors.green
                      : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Leaderboard Section - moved down
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        children: [
                          Text(
                            'Leaderboard',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(2, 2),
                                    blurRadius: 6),
                              ],
                            ),
                          ),
                          SizedBox(width: 20), // Spacing between leaderboard and rounds
                          Text(
                            '',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    offset: Offset(2, 2),
                                    blurRadius: 6),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (winningPlayers.isEmpty && losingPlayers.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'No winners or losers. All players have a score of 0.',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ] else ...[
                      if (winningPlayers.isNotEmpty)
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Winning Players',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.greenAccent,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: winningPlayers.length,
                                  itemBuilder: (context, index) {
                                    final player = winningPlayers[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      elevation: 6,
                                      shadowColor: Colors.black.withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      color: Colors.greenAccent[100],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.green[700],
                                            child: Text(
                                              '#${index + 1}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                          title: Text(
                                            player['name'] as String,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.yellow[700]),
                                                Text(
                                                  ' ${player['score']}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (losingPlayers.isNotEmpty)
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Losing Players',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: losingPlayers.length,
                                  itemBuilder: (context, index) {
                                    final player = losingPlayers[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      elevation: 6,
                                      shadowColor: Colors.black.withOpacity(0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      color: Colors.redAccent[100],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: Colors.red[700],
                                            child: Text(
                                              '#${index + 1}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                          title: Text(
                                            player['name'] as String,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(14.0),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.star,
                                                    color: Colors.yellow[700]),
                                                Text(
                                                  ' ${player['score']}',
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerCountScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    elevation: 5,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

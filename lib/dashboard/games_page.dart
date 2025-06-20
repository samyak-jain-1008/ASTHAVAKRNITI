import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GamesSection extends StatelessWidget {
  // List of games with their titles and real game URLs
  final List<Map<String, String>> games = [
    {'title': 'Game 1 - Tetris', 'url': 'https://tetris.com/play-tetris'},
    {'title': 'Game 2 - Pac-Man', 'url': 'https://www.google.com/logos/2010/pacman10-i.html'},
    {'title': 'Game 3 - Sudoku', 'url': 'https://www.websudoku.com/'},
    {'title': 'Game 4 - 2048', 'url': 'https://play2048.co/'},
    {'title': 'Game 5 - Chess', 'url': 'https://www.chess.com/play/online'},
    {'title': 'Game 6 - Snake Game', 'url': 'https://playsnake.org/'},
    {'title': 'Game 7 - Tic-Tac-Toe', 'url': 'https://playtictactoe.org/'},
    {'title': 'Game 8 - Slither.io', 'url': 'http://slither.io/'},
    {'title': 'Game 9 - Minesweeper', 'url': 'https://minesweeperonline.com/'},
    {'title': 'Game 10 - Checkers', 'url': 'https://www.itsyourturn.com/iyt.dll?act=playgame&game=Checkers'},
    // Additional games
    {'title': 'Game 11 - Solitaire', 'url': 'https://www.solitr.com/'},
    {'title': 'Game 12 - Pong', 'url': 'https://pong-2.com/'},
    {'title': 'Game 13 - Mahjong', 'url': 'https://www.247mahjong.com/'},
    {'title': 'Game 14 - Bejeweled', 'url': 'https://zone.msn.com/en/bejeweled/default.htm'},
    {'title': 'Game 15 - Connect 4', 'url': 'https://www.mathsisfun.com/games/connect4.html'},
    {'title': 'Game 16 - Ludo', 'url': 'https://www.ludo-online.com/'},
    {'title': 'Game 17 - Candy Crush', 'url': 'https://www.king.com/game/candycrush'},
    {'title': 'Game 18 - Word Search', 'url': 'https://thewordsearch.com/'},
    {'title': 'Game 19 - Bubble Shooter', 'url': 'https://www.bubbleshooter.net/'},
    {'title': 'Game 20 - Scrabble', 'url': 'https://poki.com/en/g/scrabble'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games to Refresh Your Mind'),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final url = games[index]['url'];
              if (url != null) {
                _launchURL(url);
              }
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  games[index]['title']!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.play_arrow),
              ),
            ),
          );
        },
      ),
    );
  }

  // Method to launch the game URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

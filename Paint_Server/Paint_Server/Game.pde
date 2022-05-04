// Represents a game of Paint!
class Game {

  boolean started = false;

  int id;
  String host;
  List<String> players = new ArrayList<String>();
  List<Integer> points = new ArrayList<Integer>();
  int nextPainterIndex = 0;
  String category;
  int roundsLeft;
  // How long a round is, in milliseconds
  int roundLengthInMillis = 10000;
  int preRoundLengthInMillis = 5000;

  String currentWord;
  int preRoundStartTime;

  Game(String host, int roundsLeft, int id) {
    this.host = host;
    this.roundsLeft = roundsLeft;
    this.category = "Food";
    this.id = id;
    players.add(host);
    points.add(0);
  }

  void update() {
    // If the current round's time limit is reached, end the round
    if (millis() - preRoundStartTime >= roundLengthInMillis + preRoundLengthInMillis) {
      endRound();
    }
  }

  // Ends one round of the game
  void endRound() {
    if (roundsLeft == 0) {
      endGame();
    } else {
      startNextPreRound();
    }
  }

  // Ends the entire game and removes the game from the idToGame map
  void endGame() {
    println("Game " + id + " ending");

    // Find the winner(s)
    String winner = "none";
    int winnerPoints = -99999;
    List<String> tiedWinners = new ArrayList<String>();
    for (int i=0; i < players.size(); i++) {
      if (points.get(i) > winnerPoints) {
        winner = players.get(i);
        winnerPoints = points.get(i);
        tiedWinners.clear();
        tiedWinners.add(winner);
      } else if (points.get(i) == winnerPoints) {
        tiedWinners.add(players.get(i));
      }
    }
    // Create the message to be sent to the players
    // If there's only one winner, then the message will look like "endGame winner <numPoints> <winnerName>"
    // If there are multiple winners, the message willl look like "endGame tiedWinners <numPoints> <winner1> <winner2> ..."
    String endGameString = "endGame ";
    if (tiedWinners.size() == 1) {
      endGameString += "winner " + winnerPoints + " " + winner;
    } else {
      endGameString += "tiedWinners " + winnerPoints;
      for (String tiedWinner : tiedWinners) {
        endGameString += " " + tiedWinner;
      }
    }
    for (String player : players) {
      messenger.writeMessage(player, endGameString);
    }
    idToGame.remove(id);
  }

  // Chooses a player to be the next painter
  String choosePainter() {
    String painter = players.get(nextPainterIndex);
    nextPainterIndex = (nextPainterIndex + 1) % players.size();
    return painter;
  }

  // Starts the next round by sending a message to each player in the game
  void startNextPreRound() {
    roundsLeft--;
    println("Game " + id + " starting new pre round");
    started = true;
    preRoundStartTime = millis();
    currentWord = generateWordFrom(category);
    String nextPainter = choosePainter();
    for (String player : players) {
      if (player.equals(nextPainter)) {
        messenger.writeMessage(player, "startPreRoundAsPainter " + currentWord);
      } else {
        messenger.writeMessage(player, "startPreRound " + nextPainter);
      }
    }
  }
}

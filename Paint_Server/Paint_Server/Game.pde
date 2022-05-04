// Represents a game of Paint!
class Game {

  boolean started = false;

  int id;
  String host;
  List<String> players = new ArrayList<String>();
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
  }

  void update() {
    if (millis() - preRoundStartTime >= roundLengthInMillis + preRoundLengthInMillis) {
      startNextPreRound();
    }
  }

  String choosePainter() {
    String painter = players.get(nextPainterIndex);
    nextPainterIndex = (nextPainterIndex + 1) % players.size();
    return painter;
  }

  void startNextPreRound() {
    if (roundsLeft == 0) {
      println("Game " + id + " ending");
      for (String player : players) {
        messenger.writeMessage(player, "endGame");
      }
    } else {
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
}

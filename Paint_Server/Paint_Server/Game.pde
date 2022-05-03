// Represents a game of Paint!
class Game {

  boolean started = false;

  String host;
  List<String> players = new ArrayList<String>();
  int nextPainterIndex = 0;
  String category;
  // How long a round is, in milliseconds
  int roundLengthInMillis = 60000;
  int preRoundLengthInMillis = 5000;

  String currentWord;
  int preRoundStartTime;

  Game(String host) {
    this.host = host;
    this.category = "Food";
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

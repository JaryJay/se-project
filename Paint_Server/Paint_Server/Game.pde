// Represents a game of Paint!
class Game {

  boolean started = false;

  String host;
  List<String> players = new ArrayList<String>();
  String category;

  Round round;

  Game(String host, String category) {
    this.host = host;
    this.category = category;
    players.add(host);
  }
  
  void start() {
    started = true;
    for (String player : players) {
      messenger.writeMessage(player, "begin");
    }
    startNewRound();
  }
  
  void startNewRound() {
    
  }
}

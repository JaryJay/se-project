// Represents a game of Paint!
class Game {

  boolean started = false;

  String host;
  List<String> players = new ArrayList<String>();
  int nextPainterIndex = 0;
  String category;

  Round round;

  Game(String host) {
    this.host = host;
    this.category = "Food";
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
  
  String choosePainter() {
    String painter = players.get(nextPainterIndex);
    nextPainterIndex = (nextPainterIndex + 1) % players.size();
    return painter;
  }
  
  String generateWord() {
    // TODO generate from a list of words
    if (category.equals("Food")) {
      return "Baguette";
    }
    return "Water bottle";
  }
}

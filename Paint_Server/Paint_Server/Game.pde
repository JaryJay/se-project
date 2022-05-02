// Represents a game of Paint!
class Game {

  boolean started = false;

  String host;
  List<String> players = new ArrayList<String>();
  int nextPainterIndex = 0;
  String category;

  String currentWord;

  Game(String host) {
    this.host = host;
    this.category = "Food";
    players.add(host);
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

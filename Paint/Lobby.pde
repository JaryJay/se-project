// Lobby stores the game data before a game starts
// such as category, players so far, 
class Lobby {
  int id; 
  String[] possibleCategories = loadStrings("category.txt");
  String category = possibleCategories[0];
  List<String> playersSoFar = new ArrayList<String>();
  int numberRounds = 10;
}

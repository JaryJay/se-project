ServerMessenger messenger = new ServerMessenger();
Map<Integer, Game> idToGame = new HashMap<Integer, Game>();

void setup() {
  size(400, 400);
  messenger.init();
  frameRate(3);
}

void draw() {
  messenger.update();

  List<Message> messages = messenger.readMessages();
  for (Message message : messages) {
    handleMessage(message);
  }
}


private void handleMessage(Message message) {
  String[] split = message.body.split(" ");
  String messageType = split[0];
  switch (messageType) {
  case "host":
    println(message.playerName + " tried to host a game");
    int gameID = generateID();
    messenger.writeMessage(message.playerName, "host " + gameID);
    // Create new Game
    idToGame.put(gameID, new Game(message.playerName));
    break;
  case "join":
    println(message.playerName + " tried to join a game");
    try {
      int id = Integer.parseInt(split[1]);
      if (idToGame.get(id) == null) {
        messenger.writeMessage(message.playerName, "invalidID");
      } else {
        Game game = idToGame.get(id);
        for (String player : game.players) {
          messenger.writeMessage(player, "joining " + message.playerName);
        }
        game.players.add(message.playerName);
        messenger.writeMessage(message.playerName, "joinSuccess " + game.category + " " + game.players);
      }
    } 
    catch (NumberFormatException e) {
      System.err.println("Invalid message, expected 2nd word to be a number, actual = " + split[1]);
    }
    break;
  default:
    println("Received message " + message);
    break;
  }
}

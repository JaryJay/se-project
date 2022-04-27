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


private void handleMessage(Message messageRecieved) {
  String[] split = messageRecieved.body.split(" ");
  String messageType = split[0];
  switch (messageType) {
  case "host":
    println(messageRecieved.playerName + " tried to host a game");
    int gameID = generateID();
    messenger.writeMessage(messageRecieved.playerName, "host " + gameID);
    // Create new Game
    idToGame.put(gameID, new Game(messageRecieved.playerName));
    break;
  case "join":
    println(messageRecieved.playerName + " tried to join a game");
    try {
      int id = Integer.parseInt(split[1]);
      if (idToGame.get(id) == null) {
        messenger.writeMessage(messageRecieved.playerName, "invalidID");
      } else {
        Game game = idToGame.get(id);
        for (String player : game.players) {
          messenger.writeMessage(player, "joining " + messageRecieved.playerName);
        }
        game.players.add(messageRecieved.playerName);
        messenger.writeMessage(messageRecieved.playerName, "joinSuccess " + game.category + " " + game.players);
      }
    } 
    catch (NumberFormatException e) {
      System.err.println("Invalid message, expected 2nd word to be a number, actual = " + split[1]);
    }
    break;
  default:
    println("Received message " + messageRecieved);
    break;
  }
}

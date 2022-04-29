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


private void handleMessage(Message messageReceived) {
  String[] split = messageReceived.body.split(" ");
  String messageType = split[0];
  switch (messageType) {
  case "host":
    println(messageReceived.playerName + " tried to host a game");
    int gameID = generateID();
    messenger.writeMessage(messageReceived.playerName, "host " + gameID);
    // Create new Game
    idToGame.put(gameID, new Game(messageReceived.playerName));
    break;
  case "join":
    println(messageReceived.playerName + " tried to join a game");
    try {
      int id = Integer.parseInt(split[1]);
      if (idToGame.get(id) == null) {
        messenger.writeMessage(messageReceived.playerName, "invalidID");
      } else {
        Game game = idToGame.get(id);
        for (String player : game.players) {
          messenger.writeMessage(player, "joining " + messageReceived.playerName);
        }
        game.players.add(messageReceived.playerName);
        String playersString = "";
        for (String player : game.players) {
          playersString += " " + player;
        }
        messenger.writeMessage(messageReceived.playerName, "joinSuccess " + game.category + playersString);
      }
    } 
    catch (NumberFormatException e) {
      System.err.println("Invalid message, expected 2nd word to be a number, actual = " + split[1]);
    }
    break;
  case "start":
    try {
      int id = Integer.parseInt(split[1]);
      if (idToGame.get(id) == null) {
        messenger.writeMessage(messageReceived.playerName, "invalidID");
      } else {
        Game game = idToGame.get(id);
        String painter = game.choosePainter();
        String word = game.generateWord();
        for (String player : game.players) {
          if (player.equals(painter)) {
            messenger.writeMessage(player, "painter " + word);
          } else {
            messenger.writeMessage(player, "starting " + painter);
          }
        }
        // TODO generate word, choose painter
        messenger.writeMessage(messageReceived.playerName, "startSuccess");
      }
    }
    catch (NumberFormatException e) {
      System.err.println("Invalid message, expected 2nd word to be a number, actual = " + split[1]);
    }
    println(messageReceived.playerName + " has started the game");
  case "paint":
    int id = int(split[1]);
    if (idToGame.get(id) == null) {
      messenger.writeMessage(messageReceived.playerName, "invalidID");
      break;
    }
    Game game = idToGame.get(id);
    for (String player : game.players) {
      if (!player.equals(messageReceived.playerName)) {
        messenger.writeMessage(player, messageReceived.body);
      }
    }
    break;
  default:
    println("Received message " + messageReceived);
    break;
  }
}

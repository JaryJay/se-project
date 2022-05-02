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
  if (split.length == 0) {
    messenger.writeMessage(messageReceived.playerName, "Error: server received an empty message");
    return;
  }
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
        game.currentWord = word;
        for (String player : game.players) {
          if (player.equals(painter)) {
            messenger.writeMessage(player, "startPreRoundAsPainter " + word);
          } else {
            messenger.writeMessage(player, "startPreRound " + painter);
          }
        }
      }
    }
    catch (NumberFormatException e) {
      System.err.println("Invalid message, expected 2nd word to be a number, actual = " + split[1]);
    }
    println(messageReceived.playerName + " has started the game");
    break;
  case "paint":
    try {
      int id = int(split[1]);
      if (idToGame.get(id) == null) {
        messenger.writeMessage(messageReceived.playerName, "invalidID");
        break;
      }
      Game game = idToGame.get(id);
      for (String player : game.players) {
        if (!player.equals(messageReceived.playerName)) {
          String m = "paint " + split[2] + " " + split[3] + " " + split[4] + " " + split[5] + " " + split[6] + " " + split[7];
          println("Sending " + m);
          messenger.writeMessage(player, m);
        }
      }
    }
    catch (NumberFormatException e) {
      System.err.println("Invalid message, expected 2nd word to be a number, actual = " + split[1]);
    }
    break;
  case "guess":
    int id = int(split[1]);
    if (idToGame.get(id) == null) {
      messenger.writeMessage(messageReceived.playerName, "invalidID");
      break;
    }
    Game game = idToGame.get(id);
    // if (split[2].equals(game.round.word) ) {...}
    boolean correct = split[2].equalsIgnoreCase("baguette");
    for (String player : game.players) {
      messenger.writeMessage(player, "guess " + messageReceived.playerName + " " + split[2] + " " + correct);
    }
    if (correct) {
      game.currentWord = game.generateWord();
      String nextPainter = game.choosePainter();
      for (String player : game.players) {
        if (player.equals(nextPainter)) {
          messenger.writeMessage(player, "startPreRoundAsPainter " + game.currentWord);
        } else {
          messenger.writeMessage(player, "startPreRound " + nextPainter);
        }
      }
    }
  default:
    println("Received message " + messageReceived);
    break;
  }
}

void keyPressed() {
  if (key == 'r') {
    // Restart the messenger and all the games
    messenger.close();
    messenger = new ServerMessenger();
    messenger.init();
    idToGame = new HashMap<Integer, Game>();
  }
}

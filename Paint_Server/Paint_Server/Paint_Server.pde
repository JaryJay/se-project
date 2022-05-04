ServerMessenger messenger = new ServerMessenger(); //<>//
Map<Integer, Game> idToGame = new HashMap<Integer, Game>();

void setup() {
  size(400, 400);
  messenger.init();
  frameRate(3);
  initWordGeneration();
}

void draw() {
  // If the server runs into any errors, continue the server without
  // terminating it (but still print the error message)
  try {
    tryToDraw();
  } catch (Exception e) {
    e.printStackTrace();
  }
}

void tryToDraw() {
  messenger.update();

  List<Message> messages = messenger.readMessages();
  for (Message message : messages) {
    handleMessage(message);
  }
  
  List<Integer> gamesToRemove = new ArrayList<Integer>();
  for (Game game : idToGame.values()) {
    if (messenger.nameToSocket.get(game.host) == null) {
      gamesToRemove.add(game.id);
    } else if (game.started) {
      game.update();
    }
  }
  for (Integer gameID : gamesToRemove) {
    idToGame.remove(gameID);
    println(gameID + " removed");
  }
}

private void handleMessage(Message messageReceived) {
  String[] split = messageReceived.body.split(" ");
  println("Received message from " + messageReceived.playerName + " " + messageReceived.body + millis());
  if (split.length == 0) {
    messenger.writeMessage(messageReceived.playerName, "Error: server received an empty message");
    return;
  }
  String messageType = split[0];
  switch (messageType) {
  case "host":
    int gameID = generateID();
    messenger.writeMessage(messageReceived.playerName, "host " + gameID);
    // Create new Game
    idToGame.put(gameID, new Game(messageReceived.playerName, 10, gameID));
    println(messageReceived.playerName + " hosted a game with ID " + gameID);
    break;
  case "join":
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
        println(messageReceived.playerName + " joined game ID=" + id);
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
        game.startNextPreRound();
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
          messenger.writeMessage(player, m);
        }
      }
      messenger.writeMessage(messageReceived.playerName, "paintSuccess");
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
    boolean correct = split[2].equalsIgnoreCase(game.currentWord);
    for (String player : game.players) {
      messenger.writeMessage(player, "guess " + messageReceived.playerName + " " + split[2] + " " + correct);
    }
    if (correct) {
      game.startNextPreRound();
    }
    break;
  case "restart":
    restart();
    break;
  case "quit":
    messenger.removePlayer(messageReceived.playerName);
    println("Kicked " + messageReceived.playerName); 
    break;
  case "ping":
    messenger.writeMessage(messageReceived.playerName, "pingResponse");
    break;
  default:
    //println("Received message " + messageReceived);
    break;
  }
}

void keyPressed() {
  if (key == 'r') {
    restart();
  }
}

// Pulls new code from GitHub (if any) and restarts the server
void restart() {
  println("Preparing to restart server");
  println("Closing messenger");
  messenger.close();
  println("Exiting processing program");
  exit();
  //println("Discarding changes");
  //exec("git", "reset", "-hard");
  println("Pulling changes from GitHub");
  exec("git", "pull");
  println("Executing Paint_Server");
  exec("C:/processing-3.5.4/processing-java.exe", "--sketch=" + sketchPath(), "--run");
}

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
    messenger.update();
    // Handle all messages
    List<Message> messages = messenger.readMessages();
    for (Message message : messages) {
      handleMessage(message);
    }
    
    // Remove games if their host has been kicked
    List<Integer> gamesToRemove = new ArrayList<Integer>();
    for (Game game : idToGame.values()) {
      if (messenger.nameToSocket.get(game.host) == null) {
        gamesToRemove.add(game.id);
      } else if (game.started) {
        game.update();
      }
    }
    // We remove games in a separate for loop to prevent "ConcurrentModificationException"s
    for (Integer gameID : gamesToRemove) {
      idToGame.remove(gameID);
      println(gameID + " removed");
    }
  } 
  catch (Exception e) {
    // Print the error message but don't terminate server
    e.printStackTrace();
  }
}

// Interprets a message based on the first word, then does something depending on what
// that first word is (e.g. if the message starts with "host", then create a new game)
private void handleMessage(Message messageReceived) {
  String[] split = messageReceived.body.split(" ");
  println("Received message from " + messageReceived.playerName + " " + messageReceived.body);
  if (split.length == 0) {
    messenger.writeMessage(messageReceived.playerName, "Error: server received an empty message");
    return;
  }
  String messageType = split[0];
  // Ctrl+click on the following handleXYZ() methods to see what they do
  switch (messageType) {
  case "host":
    handleHost(split, messageReceived);
    return;
  case "join":
    handleJoin(split, messageReceived);
    return;
  case "changeCategory":
    handleCategory(split, messageReceived);
    return;
  case "start":
    handleStart(split, messageReceived);
    return;
  case "paint":
    handlePaint(split, messageReceived);
    return;
  case "clearScreen":
    handleClearScreen(split, messageReceived);
    return;
  case "guess":
    handleGuess(split, messageReceived);
    return;
  case "restart":
    restart();
    return;
  case "quit":
    handleQuit(split, messageReceived);
    return;
  case "ping":
    handlePing(messageReceived);
    return;
  default:
    //println("Received message " + messageReceived);
    return;
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
  println("Pulling changes from GitHub");
  exec("git", "pull");
  println("Executing Paint_Server");
  // If you downloaded processing in a different place, then you have to change this
  exec("C:/processing-3.5.4/processing-java.exe", "--sketch=" + sketchPath(), "--run");
  exit();
}

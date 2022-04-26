ServerMessenger messenger = new ServerMessenger();

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
    break;
  case "join":
    println(message.playerName + " tried to join a game");
    try {
      int id = Integer.parseInt(split[1]);
      println(message.playerName + " tried to join game " + id);
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

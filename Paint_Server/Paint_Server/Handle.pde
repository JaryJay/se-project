void handleHost(String[] split, Message messageReceived) {
  int gameID = generateID();
  messenger.writeMessage(messageReceived.playerName, "host " + gameID);
  // Create new Game
  idToGame.put(gameID, new Game(messageReceived.playerName, 10, gameID));
  println(messageReceived.playerName + " hosted a game with ID " + gameID);
}

void handleJoin(String[] split, Message messageReceived) {
  int id = Integer.parseInt(split[1]);
  if (idToGame.get(id) == null) {
    messenger.writeMessage(messageReceived.playerName, "invalidID");
  } else {
    Game game = idToGame.get(id);
    for (String player : game.players) {
      messenger.writeMessage(player, "joining " + messageReceived.playerName);
    }
    game.players.add(messageReceived.playerName);
    game.points.add(0);
    String playersString = "";
    for (String player : game.players) {
      playersString += " " + player;
    }
    messenger.writeMessage(messageReceived.playerName, "joinSuccess " + game.category + playersString);
    println(messageReceived.playerName + " joined game ID=" + id);
  }
}

void handleCategory(String[] split, Message messageReceived) {
  int id = int(split[1]);
  Game game = idToGame.get(id);
  String newCat = split[2];
  game.category = newCat;
  for (String player : game.players) {
    if (!player.equals(messageReceived.playerName)) {
      messenger.writeMessage(player, "changeCategory " + newCat);
    }
  }
}

void handleStart(String[] split, Message messageReceived) {
  int id = Integer.parseInt(split[1]);
  if (idToGame.get(id) == null) {
    messenger.writeMessage(messageReceived.playerName, "invalidID");
  } else {
    Game game = idToGame.get(id);
    game.startNextPreRound();
  }
  println(messageReceived.playerName + " has started the game");
}

void handlePaint(String[] split, Message messageReceived) {
  int id = int(split[1]);
  if (idToGame.get(id) == null) {
    messenger.writeMessage(messageReceived.playerName, "invalidID");
    return;
  }
  Game game = idToGame.get(id);
  for (String player : game.players) {
    if (!player.equals(messageReceived.playerName)) {
      String m = "paint " + split[2] + " " + split[3] + " " + split[4] + " " + split[5] + " " + split[6] + " " + split[7];
      messenger.writeMessage(player, m);
    }
  }
}

void handleGuess(String[] split, Message messageReceived) {
  int id = int(split[1]);
  if (idToGame.get(id) == null) {
    messenger.writeMessage(messageReceived.playerName, "invalidID");
    return;
  }
  Game game = idToGame.get(id);
  // Check if strings match, without considering spaces
  boolean correct = split[2].replaceAll(" ","").equalsIgnoreCase(game.currentWord.replaceAll(" ",""));
  for (String player : game.players) {
    messenger.writeMessage(player, "guess " + messageReceived.playerName + " " + split[2] + " " + correct);
  }
  if (correct) {
    int indexOfPlayer = game.players.indexOf(messageReceived.playerName);
    game.points.set(indexOfPlayer, game.points.get(indexOfPlayer) + 100);
    game.endRound();
  }
}

void handleQuit(String[] split, Message messageReceived) {
  messenger.removePlayer(messageReceived.playerName);
  println("Kicked " + messageReceived.playerName);
}

void handlePing(Message messageReceived) {
  messenger.writeMessage(messageReceived.playerName, "pingResponse");
}

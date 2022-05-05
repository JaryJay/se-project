// Used to organize the separate game screens into different
// subclasses of State. Transition between different states
// with transitionState(new TheNewState());
abstract class State {

  // The guis owned by this state
  GAbstractControl[] guis;

  // Called every frame
  // Since this method is abstract, it must be overridden by
  // all subclasses of State
  abstract void update();

  void showGuis() {
    if (guis == null) {
      throw new RuntimeException("Guis not set. Use guis = new GAbstractControl[]{...}; in the constructor of "
        + getClass().getSimpleName() + " to indicate the guis that are belong to it.");
    }
    for (GAbstractControl gui : guis) {
      gui.setVisible(true);
    }
  }

  void hideGuis() {
    for (GAbstractControl gui : guis) {
      gui.setVisible(false);
    }
  }
  // Default implementations: do nothing
  void mousePressed() {
  }

  void mouseDragged() {
  }

  void keyPressed() {
    if (messenger != null && key == '\\') {
      messenger.writeMessage("ping");
    }
  }
}

// Below are the subclasses of State.

class MainMenuState extends State {

  MainMenuState() {
    guis = new GAbstractControl[]{ joinButton, hostButton, instructionsButton };
    background(255);
  }

  void update() {
    String title = "Paint!";
    fill(0, 140, 255);
    textAlign(CENTER);
    textSize(60);
    text( title, width/2, 100 );
  }
}

class JoinState extends State {

  JoinState() {
    guis = new GAbstractControl[]{ nameTextField, idTextField, joinGameButton };
  }

  void update() {
    background(255);
    fill(0, 140, 255);
    textSize(60);
    text( "Join!", width/2, 100 );
  }

  void keyPressed() {
    if (key == TAB) {
      if (nameTextField.hasFocus()) {
        idTextField.setFocus(true);
      } else {
        nameTextField.setFocus(true);
      }
    } else if (key == ENTER) {
      // Pressing enter does the same thing as clicking the button
      joinGameButton_click(null, null);
    } else if (key == ESC) {
      transitionState(new MainMenuState());
    }
  }
}

// The state where the host enters their name
class HostState extends State {

  HostState() {
    guis = new GAbstractControl[]{ nameTextField, hostGameButton };
  }

  void update() {
    background(255);
    fill(0, 140, 255);
    textSize(60);
    text( "Host!", width/2, 100 );
  }

  void keyPressed() {
    if (key == TAB) {
      nameTextField.setFocus(true);
    } else if (key == ENTER) {
      // Pressing enter does the same thing as clicking the button
      hostGameButton_click(null, null);
    } else if (key == ESC) {
      transitionState(new MainMenuState());
    }
  }
}

class InstructionsState extends State {
  PImage img; 

  InstructionsState() {
    guis = new GAbstractControl[]{  };
    img = loadImage("Rules.png");
  }

  void update() {
    background(255);
    fill(0, 140, 255);
    textSize(60);
    text( "Instructions!", width/2, 100 );
    fill(0);
    image(img, 150, 100, img.width/2.5, img.height/2.5);
  }

  void keyPressed() {
    if (key == ESC) {
      transitionState(new MainMenuState());
    }
  }
}

// The state where players lounge in before the game actually starts
class LobbyState extends State {
  Lobby lobby = new Lobby();
  boolean isHost;

  //Show number of rounds, show players, show category 
  LobbyState(boolean isHost) {
    this.isHost = isHost;
    if (isHost) {
      // Add # of rounds, and category drop down
      guis = new GAbstractControl[] {startGameButton, categoryDropList};
    } else {
      guis = new GAbstractControl[] {};
    }
  }

  void update() {
    background(255);
    fill(0, 140, 255);
    textAlign(CENTER);
    textSize(60);
    text( "Lobby!", width/2, 68 );
    textAlign(LEFT);
    textSize(32);
    if (!isHost) {
      text("Waiting for the host\nto start the game...", 500, 385);
    }
    text("Game ID:", 32, 150);
    text(lobby.id, 314, 150);
    text("Category:", 32, 200);
    if (!isHost) {
      text(lobby.category, 314, 200);
    }
    text("Number of rounds:", 32, 250);
    text(lobby.numberRounds, 314, 250);
    text("Players so far", 32, 350);
    fill(0, 255, 32);
    // Display players in lobby
    int x = 86;
    int y = 400;
    for (int i = 0; i < lobby.playersSoFar.size(); i++) {
      String tel = lobby.playersSoFar.get(i);
      text(tel, x, y);
      y+= 50;
    }
    List<String> messages = messenger.readMessages();
    for (String message : messages) {
      handleMessage(message);
    }
  }

  // Called in update(), handles a message from the server
  private void handleMessage(String message) {
    String[] split = message.split(" ");
    String messageType = split[0];
    println("Received message: " + message);
    // Do different things based on the first word in the message
    switch (messageType) {
    case "joining":
      String joiningPlayer = split[1];
      println(joiningPlayer + " has joined the lobby");
      lobby.playersSoFar.add(joiningPlayer);
      break;
    case "changeCategory":
      lobby.category = split[1].replaceAll("_", " ");
      break;
    case "startPreRound":
      // You are a guesser
      chat = new Chat();
      transitionState(new PreRoundState(split[1]));
      break;
    case "startPreRoundAsPainter":
      // You are the painter
      chat = new Chat();
      PreRoundState preRoundState = new PreRoundState(clientName);
      preRoundState.word = split[1];
      transitionState(preRoundState);
      break;
    default:
      // println("Received message " + message);
      break;
    }
  }

  // You get to draw in the lobby
  void mousePressed() {
    stroke(240, 240, 240);
    strokeWeight(40);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }


  void mouseDragged() {
    stroke(240, 240, 240);
    strokeWeight(40);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}

// The state before a round starts. It lasts 5 seconds and tells
// the player about who the painter is
class PreRoundState extends State {
  // The painter
  String painter;
  // The secret word, or null if you are not the painter
  String word;
  // The frame number at which this state started.
  // Used to determine when to transition to the RoundState
  int startTime = millis();

  //Show number of rounds, show players, show category 
  PreRoundState(String painter) {
    this.painter = painter;
    // Owns no guis
    guis = new GAbstractControl []{};
    // Clear the PreRoundState's drawings
    background(255);
  }

  void update() {
    textAlign(CENTER);
    textSize(60);
    // If you are the painter...
    fill(0, 140, 255);
    if (painter.equals(clientName)) {
      text("You are the painter!", width/2, 200);
      textSize(40);
      text("Your word is " + word + "!", width/2, 300);
    } else {
      text(painter + " is the painter!", width/2, 200);
      textSize(40);
      text("Try to guess what " + painter + " is painting!", width/2, 300);
    }
    textAlign(LEFT);
    textSize(20);
    fill(240, 205, 29);
    text("Points: ", 10, 570);
    fill(29, 134, 240);
    text(points, 100, 570);

    chat.display();
    // Transition to round state if 5 seconds have passed
    if (millis() - startTime >= 5000) {
      transitionState(new RoundState(painter, word));
      return;
    }
    List<String> messages = messenger.readMessages();
    for (String message : messages) {
      handleMessage(message);
    }
  }
  private void handleMessage(String message) {
    String[] split = message.split(" ");
    String messageType = split[0];
    println("In preround state. Received message " + message);
    switch (messageType) {
    case "penalty":
      points -= 10;
      chat.addMessage("-10 points :(");
      break;
    }
  }
}

// Finally, the RoundState! The painter paints, the guessers guess, you get to have fun.
// Whenever the painters paint, a message is sent to the server containing info about the
// line that you painted. Whenever a guesser guesses, their guess is sent to the server
// and the server replies whether or not they guessed correctly. The server also relays
// this information to other players so that they can also see.
class RoundState extends State {
  String painter;
  // The frame number at which this state started.
  // Used to determine when to transition to the next PreRoundState
  int startTime = millis();
  // The current stroke color for the brush
  color strokeColor = color(0, 0, 0);

  //Show number of rounds, show players, show category 
  RoundState(String painter, String word) {
    this.painter = painter;
    // If client is painting, then show painting tools
    // Otherwise show guessing textbox
    if (painter.equals(clientName)) {
      guis = new GAbstractControl []{redColourButton, blueColourButton, greenColourButton, yellowColourButton, orangeColourButton, purpleColourButton, cyanColourButton, eraserButton, clearAllButton, blackColourButton, brushSizeSlider, brushSizeLabel};
      chat.addMessage("Your word is " + word);
    } else {
      guis = new GAbstractControl []{guessTextBox};
      guessTextBox.setFocus(true);
    }
    // Clean up the screen left over from the PreRoundState 
    background(255);
  }

  void update() {
    chat.display();
    if (painter.equals(clientName)) {
      // Draw the box around the brush size slider
      fill(255);
      strokeWeight(0);
      stroke(0);
      rect(102, 29, 200, 51, 5);
    } else {
      // Display "Guess:" label beside the text box
      fill(100, 100, 255);
      text("Guess: ", width - 210, 585);
    }
    textAlign(LEFT);
    textSize(20);
    fill(240, 205, 29);
    text("Points: ", 10, 570);
    fill(29, 134, 240);
    text(points, 100, 570);
    // You've seen this enough times to know what this does, right?
    // Handles all messages (if any)
    List<String> messages = messenger.readMessages();
    for (String message : messages) {
      handleMessage(message);
    }
  }

  // Handles a message
  private void handleMessage(String message) {
    String[] split = message.split(" ");
    String messageType = split[0];
    println("In round state. Received message " + message);
    switch (messageType) {
    case "paint":
      // Paint onto the screen using info from the message
      int x1 = int(split[1]);
      int y1 = int(split[2]);
      int x2 = int(split[3]);
      int y2 = int(split[4]);
      color c = color(int(split[5]));
      int brushSize = int(split[6]);
      stroke(c);
      strokeWeight(brushSize);
      line(x1, y1, x2, y2);
      println("Received message " + message + c);
      break;
    case "clearScreen":
      background(255);
      return;
    case "guess":
      // Store a guess that another player has made
      String player = split[1];
      String word = split[2];
      boolean correct = boolean(split[3]);

      chat.addMessage(player + ":  " + word.replaceAll("_", " "));
      if (correct) {
        if (player.equals(clientName)) {
          chat.addMessage("Correct! +100 points!");
          points += 100;
        } else {
          chat.addMessage(player + " is correct!");
        }
      }
      break;
    case "revealWord":
      // Painter failed to paint well

      if (painter.equals(clientName)) {
        // -10 points!!!!!
        points -= 10;
        chat.addMessage("Time's up! -10 points :(");
      } else {
        // Reveal word to guesser
        chat.addMessage("Time's up!");
        chat.addMessage("The word was " + split[1]);
      }
      break;
    case "startPreRound":
      transitionState(new PreRoundState(split[1]));
      break;
    case "startPreRoundAsPainter":
      PreRoundState preRoundState = new PreRoundState(clientName);
      preRoundState.word = split[1];
      transitionState(preRoundState);
      break;
    case "endGame":
      chat.addMessage("Game has ended!");
      int winnerPoints = int(split[2]);
      List<String> winners = new ArrayList<String>();
      for (int i = 3; i < split.length; i++) {
        winners.add(split[i]);
      }
      transitionState(new EndedGameState(winners, winnerPoints));
    default:
      break;
    }
  }

  // When you press enter, this method sends your guess from the guessTextBox to the server
  void keyPressed() {
    if (key == ENTER && guessTextBox.isVisible() && guessTextBox.getText().length() != 0) {
      String guess = guessTextBox.getText();
      // For some reason, you can only call setText() when the text box isn't focused
      guessTextBox.setFocus(false);
      guessTextBox.setText("");
      // Refocus
      guessTextBox.setFocus(true);
      messenger.writeMessage("guess " + gameID + " " + guess.replaceAll(" ", "_"));
    } else if (key == TAB && guessTextBox.isVisible()) {
      guessTextBox.setFocus(true);
    }
    super.keyPressed();
  }

  void mousePressed() {
    paint();
  }

  void mouseDragged() {
    paint();
  }

  // If you are the painter, draw a line from your mouse pos to the mouse pos last frame
  // Then, send that info to the server. It will then be sent to all other clients
  void paint() {
    if (painter.equals(clientName)) {
      int brushSize = brushSizeSlider.getValueI();
      strokeWeight(brushSize);
      stroke(strokeColor);
      line(mouseX, mouseY, pmouseX, pmouseY);
      // paint <gameID> <x1> <y1> <x2> <y2> <color> <brushSize>
      messenger.writeMessage("paint " + gameID + " " + mouseX + " " + mouseY + " " + pmouseX + " " + pmouseY + " " + strokeColor + " " + brushSize);
    }
  }
}

// The state at the end of the game.
class EndedGameState extends State {

  List<String> winners;
  int winnerPoints;

  EndedGameState(List<String> winners, int winnerPoints) {
    this.winners = winners;
    this.winnerPoints = winnerPoints;
    // Owns no guis
    guis = new GAbstractControl []{};
  }

  void update() {
    // Display some end-of-game stuff
    background(255);
    textAlign(CENTER);
    textSize(60);
    fill(0, 140, 255);
    text("The game has ended!", width/2, 200);
    textAlign(LEFT);
    textSize(32);
    text("You finished with " + points + " points!", 100, 500);
    fill(30, 140, 255);
    text("The winner(s) finished with " + winnerPoints + " points!", 100, 560); 
    text("Winner(s):", 230, 300);
    fill(0, 255, 32);
    for (int i=0; i < winners.size(); i++) {
      text(winners.get(i), 400, 300 + i * 35);
    }

    chat.display();
    List<String> messages = messenger.readMessages();
    for (String message : messages) {
      handleMessage(message);
    }
  }

  // You shouldn't be receiving any messages here, but we handle the penalty
  // message just in case
  private void handleMessage(String message) {
    String[] split = message.split(" ");
    String messageType = split[0];
    println("In preround state. Received message " + message);
    switch (messageType) {
    case "penalty":
      points -= 10;
      chat.addMessage("-10 points :(");
      break;
    }
  }

  void keyPressed() {
    // Effectively restart the program
    if (key == ESC) {
      messenger.writeMessage("quit");
      messenger.close();
      messenger = null;
      clientName = null;
      points = 0;
      categoryDropList.setSelected(0);
      transitionState(new MainMenuState());
    }
  }
}

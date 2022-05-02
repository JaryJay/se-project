abstract class State {

  GAbstractControl[] guis;

  abstract void update();

  void showGuis() {
    for (GAbstractControl gui : guis) {
      gui.setVisible(true);
    }
  }

  void hideGuis() {
    for (GAbstractControl gui : guis) {
      gui.setVisible(false);
    }
  }

  void mousePressed() {
  }

  void mouseDragged() {
  }

  void keyPressed() {
  }
}

class MainMenuState extends State {

  MainMenuState() {
    guis = new GAbstractControl[]{ joinButton, hostButton, instructionsButton };
  }

  void update() {
    String title = "Paint!";
    fill(0, 140, 255);
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
    text( "Join!", width/2, 100 );
  }
}

class HostState extends State {

  HostState() {
    guis = new GAbstractControl[]{ nameTextField, hostGameButton };
  }

  void update() {
    background(255);
    fill(0, 140, 255);
    text( "Host!", width/2, 100 );
  }
}

class InstructionsState extends State {

  InstructionsState() {
    guis = new GAbstractControl[]{  };
  }

  void update() {
    background(255);
    fill(0, 140, 255);
    text( "Instructions!", width/2, 100 );
  }
}

class LobbyState extends State {
  Lobby lobby = new Lobby();
  boolean isHost;

  //Show number of rounds, show players, show category 
  LobbyState(boolean isHost) {
    this.isHost = isHost;
    if (isHost) {
      guis = new GAbstractControl[] {startGameButton};
    } else {
      guis = new GAbstractControl[] {};
    }
    background(255);
  }

  void update() {
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
    text(lobby.category, 314, 200);
    text("Number of rounds:", 32, 250);
    text(lobby.numberRounds, 314, 250);
    text("Players so far", 32, 350);
    fill(0, 255, 32);
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

  private void handleMessage(String message) {
    String[] split = message.split(" ");
    String messageType = split[0];
    switch (messageType) {
    case "joining":
      String joiningPlayer = split[1];
      println(joiningPlayer + " has joined the lobby");
      lobby.playersSoFar.add(joiningPlayer);
      break;
    case "startPreRound":
      {
        transitionState(new PreRoundState(split[1]));
      }
      break;
    case "startPreRoundAsPainter":
      {
        PreRoundState preRoundState = new PreRoundState(clientName);
        preRoundState.word = split[1];
        transitionState(preRoundState);
      }
      break;
    default:
      println("Received message " + message);
      break;
    }
  }

  void mousePressed() {
    fill(0);
    strokeWeight(40);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }


  void mouseDragged() {
    fill(0);
    strokeWeight(40);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}

class PreRoundState extends State {
  String painter;
  String word;
  // The frame number at which this state started.
  // Used to determine when to transition to the RoundState
  int startTime;

  //Show number of rounds, show players, show category 
  PreRoundState(String painter) {
    this.painter = painter;
    guis = new GAbstractControl []{};
    background(255);
    startTime = millis();
  }

  void update() {
    List<String> messages = messenger.readMessages();
    for (String message : messages) {
      handleMessage(message);
    }
    if (painter.equals(clientName)) {
      fill(0, 140, 255);
      text("You are the painter!", 200, 200);
      text("Your word is " + word + "!", 200, 300);
    }
    // Transition to round state after 5 seconds
    if (millis() - startTime >= 5000) {
      transitionState(new RoundState(painter));
    }
  }

  private void handleMessage(String message) {
    println("Received message " + message);
  }

  void mousePressed() {
    fill(0);
    strokeWeight(40);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }


  void mouseDragged() {
    fill(0);
    strokeWeight(40);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}

class RoundState extends State {
  String painter;
  // The frame number at which this state started.
  // Used to determine when to transition to the next PreRoundState
  int startTime;
  color strokeColor = color(0, 0, 0);

  //Show number of rounds, show players, show category 
  RoundState(String painter) {
    this.painter = painter;
    // If client is painting, then show painting tools
    // Otherwise show guessing textbox
    if (painter.equals(clientName)) {
      guis = new GAbstractControl []{redColourButton, blueColourButton, greenColourButton, yellowColourButton, orangeColourButton, purpleColourButton, cyanColourButton, eraserButton, clearAllButton, blackColourButton};
    } else {
      guis = new GAbstractControl []{guessTextBox};
    }
    background(255);
    startTime = millis();
  }

  void update() {
    List<String> messages = messenger.readMessages();
    for (String message : messages) {
      handleMessage(message);
    }
  }

  private void handleMessage(String message) {
    String[] split = message.split(" ");
    String messageType = split[0];
    switch (messageType) {
    case "paint":
      int x1 = int(split[1]);
      int y1 = int(split[2]);
      int x2 = int(split[3]);
      int y2 = int(split[4]);
      color c = color(int(split[5]));
      int brushSize = int(split[6]);
      fill(c);
      strokeWeight(brushSize);
      line(x1, y1, x2, y2);
      println("Received message " + message + c);
      break;
    default:
      println("Received message " + message);
      break;
    }
  }
  
  void keyPressed() {
    if (guessTextBox.isVisible() && guessTextBox.getText().length() != 0) {
      guessTextBox.setFocus(false);
      guessTextBox.setText("");
      guessTextBox.setFocus(true);
    }
  }

  void mousePressed() {
    paint();
  }

  void mouseDragged() {
    paint();
  }

  void paint() {
    if (painter.equals(clientName)) {
      fill(strokeColor);
      int brushSize = brushSizeSlider.getValueI();
      strokeWeight(brushSize);
      line(mouseX, mouseY, pmouseX, pmouseY);
      // paint <gameID> <x1> <y1> <x2> <y2> <color> <brushSize>
      messenger.writeMessage("paint " + gameID + " " + mouseX + " " + mouseY + " " + pmouseX + " " + pmouseY + " " + strokeColor + " " + brushSize);
    }
  }
}

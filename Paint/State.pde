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

  //Show number of rounds, show players, show category 
  LobbyState() {
    guis = new GAbstractControl []{startGameButton};
    background(255);
  }

  void update() {
    fill(0, 140, 255);
    textAlign(CENTER);
    textSize(60);
    text( "Lobby!", width/2, 68 );
    textAlign(LEFT);
    textSize(32);
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
    default:
      println("Received message " + message);
      break;
    }
  }
  
  void mousePressed() {
    fill(0);
    strokeWeight(20);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }


  void mouseDragged() {
    fill(0);
    strokeWeight(50);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}

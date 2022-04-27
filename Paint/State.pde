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
  }

  void update() {
    background(255);
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
    fill(0,255,32);
    int x = 86;
    int y = 400;
    for (int i = 0; i < lobby.playersSoFar.size(); i++) {
      String tel = lobby.playersSoFar.get(i);
      text(tel, x, y);
      y+= 50;
    }
  }
}

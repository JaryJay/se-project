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
    guis = new GAbstractControl[]{ nameTextField };
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

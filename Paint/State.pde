abstract class State { 
  
  GButton[] buttons;
  
  abstract void update();
  
  void showButtons() {
    for (GButton button : buttons) {
      button.setVisible(true);
    }
  }
  
  void hideButtons() {
    for (GButton button : buttons) {
      button.setVisible(false);
    }
  }
  
}

class MainMenuState extends State {
  
  MainMenuState() {
    buttons = new GButton[]{ joinButton, hostButton, instructionsButton };
  }
  
  void update() {
    String title = "Paint!";
    fill(0, 140, 255);
    text( title, 320, 100 );
  }
  
}

class JoinState extends State {
  
  JoinState() {
    buttons = new GButton[]{  };
  }
  
  void update() {
    background(255);
    fill(0, 140, 255);
    text( "Join!", 320, 100 );
  }
  
}

class HostState extends State {
  
  HostState() {
    buttons = new GButton[]{  };
  }
  
  void update() {
    background(255);
    fill(0, 140, 255);
    text( "Host!", 320, 100 );
  }
  
  
}

class InstructionsState extends State {
  
  InstructionsState() {
    buttons = new GButton[]{  };
  }
  
  void update() {
    background(255);
    fill(0, 140, 255);
    text( "Instructions!", 320, 100 );
  }
  
  
}

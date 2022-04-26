import g4p_controls.*;

ClientMessenger messenger;
State state;

void setup() {
  size(800, 800);
  background(255); 
  createGUI();
  PFont f1 = createFont("Cambria", 60);
  textFont( f1 );
  
  GAbstractControl[] allGuis = {joinButton, hostButton, instructionsButton, nameTextField};
  for (GAbstractControl gui : allGuis) {
    gui.setVisible(false);
  }
  state = new MainMenuState();
  state.showGuis();
}

void draw() {
  state.update();
}

void transitionState(State newState) {
  // Hide previous state
  state.hideGuis();
  state = newState;
  newState.showGuis();
}

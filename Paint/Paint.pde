import g4p_controls.*;

ClientMessenger messenger;
State state;

void setup() {
  size(800, 800);
  background(255); 
  createGUI();
  PFont f1 = createFont("Cambria", 60);
  textFont( f1 );
  textAlign(CENTER);

  GAbstractControl[] allGuis = {joinButton, hostButton, instructionsButton, nameTextField, idTextField, joinGameButton, hostGameButton};
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

// Tries to initialize a network connection with the server.
// Returns true if connected successfully, false otherwise
boolean connectToServer(String name) {
  messenger = new ClientMessenger();
  messenger.init();
  // Write the user's name
  messenger.writeMessage(name);
  // Wait for response
  String m = messenger.readOneMessage();
  if (!m.equals("success")) {
    println("Failed to connect to server because " + m);
    messenger.close();
    messenger = null;
    return false;
  } else {
    println("Connected to server.");
    return true;
  }
}

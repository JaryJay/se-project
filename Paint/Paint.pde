import g4p_controls.*;

// The messenger used to send messages to the server
ClientMessenger messenger;
// The current state
State state;

void setup() {
  size(800, 800);
  background(255);
  createGUI();
  // Use a font
  PFont f1 = createFont("Cambria", 60);
  textFont( f1 );
  textAlign(CENTER);

  // Hide all of the guis at the start
  GAbstractControl[] allGuis = {joinButton, hostButton, instructionsButton, nameTextField, idTextField, joinGameButton, hostGameButton, startGameButton, redColourButton, blueColourButton, greenColourButton, yellowColourButton, orangeColourButton, purpleColourButton, cyanColourButton, BrushSize, clearAllButton, eraserButton };
  for (GAbstractControl gui : allGuis) {
    gui.setVisible(false);
  }

  // Starting state is a main menu state
  state = new MainMenuState();
  // Show the guis in the main menu (join, host, 
  state.showGuis();
}

void draw() {
  state.update();
}

void mousePressed() {
  state.mousePressed();
}

void mouseDragged() {
  state.mouseDragged();
}

void keyPressed() {
  state.keyPressed();
}

void transitionState(State newState) {
  // Hide previous state
  state.hideGuis();
  state = newState;
  // Show new state
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

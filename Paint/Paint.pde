import g4p_controls.*;

// The messenger used to send messages to the server
ClientMessenger messenger;
// The current state
State state;
Chat chat;

String clientName;
int gameID;

void setup() {
  size(1000, 600);
  background(255);
  frameRate(20);
  createGUI();
  // Use a font
  PFont f1 = createFont("Cambria", 60);
  textFont( f1 );
  textAlign(CENTER);


  // Hide all of the guis at the start
  GAbstractControl[] allGuis = {joinButton, hostButton, instructionsButton, nameTextField, idTextField, joinGameButton, hostGameButton, startGameButton, redColourButton, blueColourButton, greenColourButton, yellowColourButton, orangeColourButton, purpleColourButton, cyanColourButton, blackColourButton, brushSizeSlider, brushSizeLabel, clearAllButton, eraserButton, guessTextBox, categoryDropList };
  for (GAbstractControl gui : allGuis) {
    gui.setVisible(false);
  }

  // Starting state is a main menu state
  state = new MainMenuState();
  // Show the guis in the main menu (join, host, 
  state.showGuis();
}

// draw(), mousePressed(), mouseDragged(), and keyPressed() delegated to the state

void draw() {
  state.update();
  // Push buffer if needed
  if (messenger != null) {
    messenger.pushMessageBufferIfNeeded();
  }
}

void mousePressed() {
  state.mousePressed();
}

void mouseDragged() {
  state.mouseDragged();
}

void keyPressed() {
  state.keyPressed();
  // Override default processing behaviour that terminates
  // the program when ESC is pressed
  if (key == ESC) {
    key = 0;
  }
}

// Changes the state to a new one
void transitionState(State newState) {
  // Hide previous state
  state.hideGuis();
  state = newState;
  // Show new state
  newState.showGuis();
  println("Transitioned to state " + newState.getClass().getSimpleName());
}

// Tries to initialize a network connection with the server.
// Returns true if connected successfully, false otherwise
boolean connectToServer(String name) {
  println("Creating messenger");
  messenger = new ClientMessenger();
  messenger.init();
  // Write the user's name
  println("Sending name");
  name = name.trim().replaceAll(" ", "_");
  messenger.writeMessage(name);
  messenger.pushMessageBuffer();
  // Wait for response
  println("Waiting for response");
  String m = messenger.readOneMessage();
  println("Received response " + m);
  if (m == null) {
    println("No response from server.");
    println("Try restarting this computer.");
    nameTextField.setPromptText("Error: no response");
    return false;
  } else if (!m.equals("success")) {
    println("Failed to connect to server because " + m);
    nameTextField.setFocus(false);
    nameTextField.setPromptText("Error: " + m);
    nameTextField.setText("");
    messenger.close();
    messenger = null;
    return false;
  } else {
    println("Connected to server.");
    // Store the client's name
    clientName = name;
    return true;
  }
}

// Override the exit() method to also close the messenger
void exit() {
  if (messenger != null) {
    println("Closing messenger");
    messenger.writeMessage("quit");
    messenger.pushMessageBuffer();
    messenger.close();
  }
  // Call the normal exit functionality
  super.exit();
}

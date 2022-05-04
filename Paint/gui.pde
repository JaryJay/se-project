/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void joinButtonClick(GButton source, GEvent event) { //_CODE_:joinButton:625211:
  transitionState(new JoinState());
} //_CODE_:joinButton:625211:

public void hostButtonClick(GButton source, GEvent event) { //_CODE_:hostButton:728375:
  transitionState(new HostState());
} //_CODE_:hostButton:728375:

public void instructionsButtonClick(GButton source, GEvent event) { //_CODE_:instructionsButton:373816:
  transitionState(new InstructionsState());
} //_CODE_:instructionsButton:373816:

public void nameTextField_change(GTextField source, GEvent event) { //_CODE_:nameTextField:264905:
} //_CODE_:nameTextField:264905:

public void joinGameButton_click(GButton source, GEvent event) { //_CODE_:joinGameButton:427819:
  // Name has to be at least 1 character
  if (nameTextField.getText().length() != 0) {
    // Game ID has to be a number, and the text field cannot be empty
    if (idTextField.getText().length() != 0) {
      // Check that the ID is a proper number (and not other characters)
      try {
        gameID = int(idTextField.getText());
      } 
      catch (Exception e) {
        println("Invalid game ID!");
        return;
      }
      if (connectToServer(nameTextField.getText())) {
        // Ask to join game with the gameID
        messenger.writeMessage("join " + gameID);
        messenger.pushMessageBuffer();
        String receivedMessage = messenger.readOneMessage();
        // Should check whether that message is a success message or not
        // If success, go to lobby state

        if (receivedMessage.startsWith("joinSuccess"))
        {
          LobbyState lobbyState = new LobbyState(false);
          // Get player names from received message
          // Create a lobby state
          // Add the player names to the lobby.playersSoFar
          String [] split = receivedMessage.split(" ");
          String category = split[1];

          for (int i = 2; i < split.length; i++) {
            String playerName = split[i];
            lobbyState.lobby.playersSoFar.add(playerName);
          }
          lobbyState.lobby.category = category;
          lobbyState.lobby.id = gameID;

          transitionState(lobbyState);
        } else {
          println("Couldn't join game because " + receivedMessage);
        }
      }
    } else {
      println("Ask your host for the game ID!");
    }
  } else {
    println("You have to fill in a name!");
  }
} //_CODE_:joinGameButton:427819:

public void idTextfield_change(GTextField source, GEvent event) { //_CODE_:idTextField:408355:
} //_CODE_:idTextField:408355:

public void hostGameButton_click(GButton source, GEvent event) { //_CODE_:hostGameButton:769528:
  // Name has to be at least 1 character
  if (nameTextField.getText().length() != 0) {
    if (connectToServer(nameTextField.getText())) {
      // Ask to join game with the gameID
      messenger.writeMessage("host");
      messenger.pushMessageBuffer();
      String received = messenger.readOneMessage();
      println("After host button was pressed: received " + received);
      // Game ID is the second word in the message
      gameID = int(received.split(" ")[1]);
      println("Hosting game with ID = " + gameID + ". Woohoo!");
      // Go to lobby state (with ability to change settings)
      LobbyState state = new LobbyState(true);
      state.lobby.id = gameID;
      state.lobby.playersSoFar.add(nameTextField.getText());
      transitionState(state);
    }
  } else {
    println("You have to fill in a name!");
  }
} //_CODE_:hostGameButton:769528:

public void startGameButton_click(GButton source, GEvent event) { //_CODE_:startGameButton:473074:
  int id = ((LobbyState)state).lobby.id;
  messenger.writeMessage("start "+ id);
} //_CODE_:startGameButton:473074:

public void redButtonClick(GButton source, GEvent event) { //_CODE_:redColourButton:831488:
  ((RoundState) state).strokeColor = color(255, 0, 0);
} //_CODE_:redColourButton:831488:

public void blueButtonClick(GButton source, GEvent event) { //_CODE_:blueColourButton:313958:
  ((RoundState) state).strokeColor = color(0, 0, 255);
} //_CODE_:blueColourButton:313958:

public void greenButtonClick(GButton source, GEvent event) { //_CODE_:greenColourButton:860283:
  ((RoundState) state).strokeColor = color(0, 128, 0);
} //_CODE_:greenColourButton:860283:

public void brushSizeSlider_change(GCustomSlider source, GEvent event) { //_CODE_:brushSizeSlider:266565:
} //_CODE_:brushSizeSlider:266565:

public void yellowButtonClick(GButton source, GEvent event) { //_CODE_:yellowColourButton:363535:
  ((RoundState) state).strokeColor = color(255, 191, 0);
} //_CODE_:yellowColourButton:363535:

public void orangeButtonClick(GButton source, GEvent event) { //_CODE_:orangeColourButton:859722:
  ((RoundState) state).strokeColor = color(255, 165, 0);
} //_CODE_:orangeColourButton:859722:

public void purpleButtonClick(GButton source, GEvent event) { //_CODE_:purpleColourButton:749936:
  ((RoundState) state).strokeColor = color(138,43,226);
} //_CODE_:purpleColourButton:749936:

public void cyanButtonClick(GButton source, GEvent event) { //_CODE_:cyanColourButton:517638:
  ((RoundState) state).strokeColor = color(0,150,152);
} //_CODE_:cyanColourButton:517638:

public void eraserButtonClick(GButton source, GEvent event) { //_CODE_:eraserButton:740076:
  ((RoundState) state).strokeColor = color(255, 255, 255);
} //_CODE_:eraserButton:740076:

public void clearButtonClick(GButton source, GEvent event) { //_CODE_:clearAllButton:474814:
  background(255, 255, 255);
} //_CODE_:clearAllButton:474814:

public void blackButtonClick(GButton source, GEvent event) { //_CODE_:blackColourButton:553256:
  ((RoundState) state).strokeColor = color(0, 0, 0);
} //_CODE_:blackColourButton:553256:

public void guessTextBox_change(GTextField source, GEvent event) { //_CODE_:guessTextBox:812170:
  println("guessTextBox - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:guessTextBox:812170:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  joinButton = new GButton(this, 422, 131, 166, 62);
  joinButton.setText("JOIN");
  joinButton.addEventHandler(this, "joinButtonClick");
  hostButton = new GButton(this, 422, 207, 165, 57);
  hostButton.setText("HOST");
  hostButton.addEventHandler(this, "hostButtonClick");
  instructionsButton = new GButton(this, 423, 279, 163, 62);
  instructionsButton.setText("INSTRUCTIONS");
  instructionsButton.addEventHandler(this, "instructionsButtonClick");
  nameTextField = new GTextField(this, 403, 359, 200, 30, G4P.SCROLLBARS_NONE);
  nameTextField.setPromptText("Name");
  nameTextField.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  nameTextField.setOpaque(true);
  nameTextField.addEventHandler(this, "nameTextField_change");
  joinGameButton = new GButton(this, 425, 465, 163, 32);
  joinGameButton.setText("Join");
  joinGameButton.addEventHandler(this, "joinGameButton_click");
  idTextField = new GTextField(this, 402, 401, 200, 30, G4P.SCROLLBARS_NONE);
  idTextField.setPromptText("Game ID - Ask the host!");
  idTextField.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  idTextField.setOpaque(true);
  idTextField.addEventHandler(this, "idTextfield_change");
  hostGameButton = new GButton(this, 422, 464, 163, 32);
  hostGameButton.setText("Host!");
  hostGameButton.addEventHandler(this, "hostGameButton_click");
  startGameButton = new GButton(this, 722, 402, 180, 60);
  startGameButton.setText("Start Game!");
  startGameButton.addEventHandler(this, "startGameButton_click");
  redColourButton = new GButton(this, 12, 29, 49, 30);
  redColourButton.setText("Red");
  redColourButton.setLocalColorScheme(GCScheme.RED_SCHEME);
  redColourButton.addEventHandler(this, "redButtonClick");
  blueColourButton = new GButton(this, 11, 76, 51, 30);
  blueColourButton.setText("Blue");
  blueColourButton.addEventHandler(this, "blueButtonClick");
  greenColourButton = new GButton(this, 11, 123, 51, 30);
  greenColourButton.setText("Green");
  greenColourButton.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  greenColourButton.addEventHandler(this, "greenButtonClick");
  brushSizeSlider = new GCustomSlider(this, 102, 29, 200, 51, "blue18px");
  brushSizeSlider.setLimits(40, 1, 100);
  brushSizeSlider.setNbrTicks(21);
  brushSizeSlider.setShowTicks(true);
  brushSizeSlider.setNumberFormat(G4P.INTEGER, 0);
  brushSizeSlider.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  brushSizeSlider.setOpaque(false);
  brushSizeSlider.addEventHandler(this, "brushSizeSlider_change");
  yellowColourButton = new GButton(this, 12, 170, 49, 30);
  yellowColourButton.setText("Yellow");
  yellowColourButton.setLocalColorScheme(GCScheme.YELLOW_SCHEME);
  yellowColourButton.addEventHandler(this, "yellowButtonClick");
  orangeColourButton = new GButton(this, 12, 217, 51, 30);
  orangeColourButton.setText("Orange");
  orangeColourButton.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  orangeColourButton.addEventHandler(this, "orangeButtonClick");
  purpleColourButton = new GButton(this, 13, 262, 52, 30);
  purpleColourButton.setText("Purple");
  purpleColourButton.setLocalColorScheme(GCScheme.PURPLE_SCHEME);
  purpleColourButton.addEventHandler(this, "purpleButtonClick");
  cyanColourButton = new GButton(this, 13, 309, 53, 30);
  cyanColourButton.setText("Cyan");
  cyanColourButton.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  cyanColourButton.addEventHandler(this, "cyanButtonClick");
  eraserButton = new GButton(this, 193, 99, 70, 30);
  eraserButton.setText("Eraser");
  eraserButton.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  eraserButton.addEventHandler(this, "eraserButtonClick");
  clearAllButton = new GButton(this, 104, 99, 70, 30);
  clearAllButton.setText("Clear All");
  clearAllButton.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  clearAllButton.addEventHandler(this, "clearButtonClick");
  blackColourButton = new GButton(this, 13, 354, 54, 30);
  blackColourButton.setText("Black");
  blackColourButton.setLocalColorScheme(GCScheme.GOLD_SCHEME);
  blackColourButton.addEventHandler(this, "blackButtonClick");
  guessTextBox = new GTextField(this, 848, 568, 150, 30, G4P.SCROLLBARS_NONE);
  guessTextBox.setPromptText("Guess!");
  guessTextBox.setOpaque(true);
  guessTextBox.addEventHandler(this, "guessTextBox_change");
  brushSizeLabel = new GLabel(this, 103, 28, 80, 20);
  brushSizeLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  brushSizeLabel.setText("Brush Size");
  brushSizeLabel.setOpaque(true);
}

// Variable declarations 
// autogenerated do not edit
GButton joinButton; 
GButton hostButton; 
GButton instructionsButton; 
GTextField nameTextField; 
GButton joinGameButton; 
GTextField idTextField; 
GButton hostGameButton; 
GButton startGameButton; 
GButton redColourButton; 
GButton blueColourButton; 
GButton greenColourButton; 
GCustomSlider brushSizeSlider; 
GButton yellowColourButton; 
GButton orangeColourButton; 
GButton purpleColourButton; 
GButton cyanColourButton; 
GButton eraserButton; 
GButton clearAllButton; 
GButton blackColourButton; 
GTextField guessTextBox; 
GLabel brushSizeLabel; 

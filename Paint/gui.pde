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
  println("nameTextField - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:nameTextField:264905:

public void joinGameButton_click(GButton source, GEvent event) { //_CODE_:joinGameButton:427819:
  println("joinGameButton - GButton >> GEvent." + event + " @ " + millis());
  // Name has to be at least 1 character
  if (nameTextField.getText().length() != 0) {
    // Game ID has to be a number, and the text field cannot be empty
    if (idTextField.getText().length() != 0) {
      int gameID;
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
        // Receive a message and just print it
        println(messenger.readOneMessage());
        // Should check whether that message is a success message or not
        // If success, go to lobby state
        if(messenger.readOneMessage().startsWith("joinSuccess"))
         {
          transitionState(new LobbyState());
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

public void roundTextField_change(GTextField source, GEvent event) { //_CODE_:roundTextField:875643:
  println("roundTextField - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:roundTextField:875643:

public void playerListArea_change(GTextArea source, GEvent event) { //_CODE_:playerListArea:812414:
  println("playerListArea - GTextArea >> GEvent." + event + " @ " + millis());
} //_CODE_:playerListArea:812414:

public void startGameButton_click(GButton source, GEvent event) { //_CODE_:startGameButton:767185:
  println("startGameButton - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:startGameButton:767185:

public void hostGameButton_click(GButton source, GEvent event) { //_CODE_:hostGameButton:884544:
  println("hostGameButton - GButton >> GEvent." + event + " @ " + millis());
  // Name has to be at least 1 character
  if (nameTextField.getText().length() != 0) {
    if (connectToServer(nameTextField.getText())) {
      // Ask to join game with the gameID
      messenger.writeMessage("host");
      String received = messenger.readOneMessage();
      println(received);
      // Game ID is the second word in the message
      int gameID = int(received.split(" ")[1]);
      println("Hosting game with ID = " + gameID + ". Woohoo!");
      // Go to lobby state (with ability to change settings)
      transitionState(new LobbyState());
    }
  } else {
    println("You have to fill in a name!");
  }
} //_CODE_:hostGameButton:884544:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  joinButton = new GButton(this, 311, 129, 166, 62);
  joinButton.setText("JOIN");
  joinButton.addEventHandler(this, "joinButtonClick");
  hostButton = new GButton(this, 313, 207, 165, 57);
  hostButton.setText("HOST");
  hostButton.addEventHandler(this, "hostButtonClick");
  instructionsButton = new GButton(this, 315, 280, 163, 62);
  instructionsButton.setText("INSTRUCTIONS");
  instructionsButton.addEventHandler(this, "instructionsButtonClick");
  nameTextField = new GTextField(this, 297, 354, 200, 30, G4P.SCROLLBARS_NONE);
  nameTextField.setPromptText("Name");
  nameTextField.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  nameTextField.setOpaque(true);
  nameTextField.addEventHandler(this, "nameTextField_change");
  joinGameButton = new GButton(this, 315, 465, 163, 32);
  joinGameButton.setText("Join");
  joinGameButton.addEventHandler(this, "joinGameButton_click");
  idTextField = new GTextField(this, 297, 403, 200, 30, G4P.SCROLLBARS_NONE);
  idTextField.setPromptText("Game ID - Ask the host!");
  idTextField.setLocalColorScheme(GCScheme.CYAN_SCHEME);
  idTextField.setOpaque(true);
  idTextField.addEventHandler(this, "idTextfield_change");
  roundTextField = new GTextField(this, 141, 217, 120, 30, G4P.SCROLLBARS_NONE);
  roundTextField.setPromptText("# Of Rounds");
  roundTextField.setOpaque(true);
  roundTextField.addEventHandler(this, "roundTextField_change");
  playerListArea = new GTextArea(this, 138, 260, 120, 80, G4P.SCROLLBARS_NONE);
  playerListArea.setPromptText("Player List");
  playerListArea.setOpaque(true);
  playerListArea.addEventHandler(this, "playerListArea_change");
  startGameButton = new GButton(this, 338, 246, 127, 59);
  startGameButton.setText("START!");
  startGameButton.addEventHandler(this, "startGameButton_click");
  hostGameButton = new GButton(this, 315, 465, 163, 32);
  hostGameButton.setText("Host!");
  hostGameButton.addEventHandler(this, "hostGameButton_click");
}

// Variable declarations 
// autogenerated do not edit
GButton joinButton; 
GButton hostButton; 
GButton instructionsButton; 
GTextField nameTextField; 
GButton joinGameButton; 
GTextField idTextField; 
GTextField roundTextField; 
GTextArea playerListArea; 
GButton startGameButton; 
GButton hostGameButton; 

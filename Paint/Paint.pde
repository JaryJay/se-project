import g4p_controls.*;

String state = "main";


void setup() {
  size(800, 800);
  background(255); 
  createGUI();
  PFont f1 = createFont("Cambria", 60);
  textFont( f1 );
}

void draw() {


  if (state == "main")
  {
    String title = "Paint!";
    fill(0, 140, 255);
    text( title, 320, 100 );
  } else if (state == "join")
  {
    background(255);
    fill(0, 140, 255);
    text( "Join!", 320, 100 );
  }else if (state == "host")
  {
    background(255);
    fill(0, 140, 255);
    text( "Host!", 320, 100 );
  }else if(state == "instructions")
  {
    background(255);
    fill(0, 140, 255);
    text( "Instructions!", 320, 100 );
  }
}

void hideMainMenuButtons()
{
  hostButton.setVisible(false);
  instructionButton.setVisible(false);
  joinButton.setVisible(false);
}

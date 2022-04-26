import g4p_controls.*;

String state = "main";

void setup() {
  size(800, 800);
  background(255); 
  createGUI();
}

void draw() {
  
  PFont f1 = createFont("Cambria", 60);
  if(state == "main")
  {
    String title = "Paint!";
    fill(0, 140, 255);
    textFont( f1 );
    text( title, 320, 100 );
  }
  

  if (state == "join")
  {
    background(255);
    fill(0, 140, 255);
    textFont( f1 );
    text( "Join!", 320, 100 );
  }
}

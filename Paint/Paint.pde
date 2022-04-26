import g4p_controls.*;

void setup() {
  size(800,800);
  background(255); 
  createGUI();
}

void draw() {
  PFont f1 = createFont("Cambria", 60);
  
  String title = "Paint!";
  
  fill(0, 140, 255);
  textFont( f1 );
  text( title, 320, 100 );
}

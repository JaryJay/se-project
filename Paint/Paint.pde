import g4p_controls.*;

State state;

void setup() {
  size(800, 800);
  background(255); 
  createGUI();
  PFont f1 = createFont("Cambria", 60);
  textFont( f1 );

  state = new MainMenuState();
}

void draw() {
  state.update();
}

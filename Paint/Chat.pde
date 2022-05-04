import java.util.*;

// A smooth, cutting-edge chat displayer imported from one of Jay's
// previous projects (which is also smooth and cutting-edge)
class Chat {
  ArrayList<String> messages = new ArrayList<String>();

  float offset = 0;

  void addMessage(String message) {
    messages.add(message);
    offset += 30;
  }

  void display() {
    textSize(18);
    textAlign(LEFT);
    fill(255);
    strokeWeight(0);
    stroke(0);
    rect(width-240, height-270, 240, 270, 5);
    fill(0);
    while (messages.size() > 8) {
      messages.remove(0);
    }
    for (int i = messages.size() - 1; i >= 0; i--) {
      text(messages.get(i), width - 240, height - (messages.size() - i) * 30 + offset - 30, 240, 1000);
    }
    offset = max(offset * 0.6, 1);
  }
}

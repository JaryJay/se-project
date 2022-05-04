import java.util.*;

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
    fill(255, 255, 255);
    strokeWeight(1);
    rect(width-240, height-240, 240, 240);
    fill(0);
    while (messages.size() > 8) {
      messages.remove(0);
    }
    for (int i = messages.size() - 1; i >= 0; i--) {
      text(messages.get(i), width - 240, height - (messages.size() - i) * 30 + offset, 240, height);
    }
    offset = max(offset * 0.9, 1);
  }
}

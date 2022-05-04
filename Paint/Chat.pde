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
    rect(width-100, height-240, 100, 240);
    fill(0);
    for (int i = messages.size() - 1; i >= 0; i--) {
      if (i > 8) {
        messages.remove(i);
        continue;
      }
      text(messages.get(i), width - 100, height - (messages.size() - i - 1) * 30 + offset - 70, 100, height);
    }
    offset = max(offset * 0.9, 1);
  }
}

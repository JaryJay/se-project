import java.util.*;

class Chat {
  ArrayList<String> messages = new ArrayList<String>();
  ArrayList<Integer> messageTimes = new ArrayList<Integer>();
  
  float offset = 0;

  void addMessage(String message) {
    messages.add(message);
    messageTimes.add(millis());
    offset += 30;
  }

  void display() {
    textSize(18);
    textAlign(LEFT);
    for (int i = messages.size() - 1; i >= 0; i--) {
      int age = millis() - messageTimes.get(i);
      
      if (age == 8000) {
        messages.remove(i);
        messageTimes.remove(i);
      } else {
        if (age > 7500) {
          fill(0, 0, 0, (8000 - age) * 225.0 / 500);
        } else {
          fill(0);
        }
        text(messages.get(i), width - 500, height - (messages.size() - i - 1) * 30 + offset - 70, 500, height);
      }
    }
    offset = max(offset * 0.9, 1);
  }
}


//void draw() {
//  textAlign(RIGHT);
//  text(text, width/2, height/2); 
//}

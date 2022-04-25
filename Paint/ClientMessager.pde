import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

class ClientMessager {

  Socket socket;
  BufferedReader reader;
  PrintWriter writer;

  void init() {
    try {
      socket = new Socket("99.250.93.242", 45000);
      reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
      writer = new PrintWriter(socket.getOutputStream(), true);
    } catch (IOException e) {
      throw new RuntimeException("Could not initialize client messenger.");
    }
  }

  void update() {
    List<String> messages = readMessages();
    for (String message : messages) {
      handleMessage(message);
    }
  }

  private void handleMessage(String message) {
    String[] split = message.split(" ");
    String messageType = split[0];
    switch (messageType) {
      case "host":
        break;
      case "join":
        break;
      default:
        println("Received message " + message);
        break;
    }
  }

  private List<String> readMessages() {
    List<String> messages = new ArrayList<String>();
    String message;
    try {
      while ((message = reader.readLine()) != null) {
        messages.add(message);
      }
    } catch (IOException e) {
      e.printStackTrace();
    }
    return messages;
  }

  private void writeMessage(String message) {
    writer.write(message);
  }

}

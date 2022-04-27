import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

class ClientMessenger {

  private Socket socket;
  private BufferedReader reader;
  private PrintWriter writer;
  
  List<String> fakeMessages = new ArrayList<String>();

  void init() {
    try {
      socket = new Socket("99.250.93.242", 45000);
      reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
      writer = new PrintWriter(socket.getOutputStream(), true);
      println("Client messenger initialized.");
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
  
  String readOneMessage() {
    try {
      return reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
    }
    return null;
  }

  private List<String> readMessages() {
    List<String> messages = new ArrayList<String>(fakeMessages);
    fakeMessages.clear();
    if (reader == null) {
      println("No new messages. The server isn't running!");
      return messages;
    }
    String message;
    try {
      while (reader.ready() && (message = reader.readLine()) != null) {
        messages.add(message);
      }
    } catch (IOException e) {
      e.printStackTrace();
    }
    return messages;
  }

  private void writeMessage(String message) {
    if (writer != null) {
      writer.println(message);
      writer.flush();
      println("Wrote message: " + message);
    } else {
      println("Pretended to write message '" + message + "' because the server isn't running.");
    }
  }
  
  void close() {
    try {
      reader.close();
      writer.close();
      socket.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

}

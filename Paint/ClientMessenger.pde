import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

// Used to communicate with the server
class ClientMessenger {

  private Socket socket;
  private BufferedReader reader;
  private PrintWriter writer;
  
  List<String> fakeMessages = new ArrayList<String>();

  // Initializes the socket, reader, and writer
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
  
  // Blocks until a message is ready and reads it
  String readOneMessage() {
    try {
      return reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
    }
    return null;
  }

  // Returns a list of received messages. If the server hasn't responded yet, then this list will be empty.
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

  // Writes a message to the server.
  private void writeMessage(String message) {
    if (writer != null) {
      writer.println(message);
      writer.flush();
      println("Wrote message: " + message);
    } else {
      println("Pretended to write message '" + message + "' because the server isn't running.");
    }
  }
  
  // Ends the client messenger. Call this when the user is exiting the program
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

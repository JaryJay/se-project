import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.util.List;

// Used to communicate with the server
class ClientMessenger {

  private Socket socket;
  private BufferedReader reader;
  private PrintWriter writer;

  String messageBuffer = "";
  List<String> fakeMessages = new ArrayList<String>();

  // Initializes the socket, reader, and writer
  void init() {
    try {
      // WARNING
      // If you try to use another computer as the server, you MUST set up port forwarding
      // See https://portforward.com/ for more details

      // Connect to the IP of Jay's personal computer at port 45000
      socket = new Socket("99.250.93.242", 45000);
      // Create a BufferedReader around the socket's input stream
      reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
      // Create a PrintWriter around the socket's output stream
      writer = new PrintWriter(socket.getOutputStream(), true);

      println("Client messenger initialized.");
    } 
    catch (IOException e) {
      println("Could not initialize client messenger.");
      // Terminate program (you can't play this game unless you connect to the server)
      throw new RuntimeException(e);
    }
  }

  // Blocks until a message is ready and reads it
  String readOneMessage() {
    try {
      return reader.readLine();
    } 
    catch (IOException e) {
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
    } 
    catch (IOException e) {
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

  void pushMessageBuffer() {
    // TODO
  }

  // Ends the client messenger. Call this when the user is exiting the program
  void close() {
    try {
      reader.close();
      writer.close();
      socket.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}

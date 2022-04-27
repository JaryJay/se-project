import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// Sends and receives messages through TCP connections.
public class ServerMessenger {

  ServerSocket serverSocket;
  Map<String, Socket> nameToSocket = new HashMap<String, Socket>();
  Map<String, BufferedReader> nameToReader = new HashMap<String, BufferedReader>();
  Map<String, PrintWriter> nameToWriter = new HashMap<String, PrintWriter>();

  // Initializes the server socket.
  void init() {
    try {
      serverSocket = new ServerSocket(45000);
      serverSocket.setSoTimeout(200);
      println("Server initialized.");
    } 
    catch (IOException e) {
      throw new RuntimeException("Could not initialize server socket.");
    }
  }

  void update() {
    receiveNewPlayersIfAny();
  }

  // Accepts any new socket connections.
  private void receiveNewPlayersIfAny() {
    try {
      Socket newClient = serverSocket.accept();
      BufferedReader reader = new BufferedReader(new InputStreamReader(newClient.getInputStream()));
      PrintWriter writer = new PrintWriter(newClient.getOutputStream());
      println("Waiting for client name.");
      String clientName = reader.readLine();
      // Don't allow multiple people with the same name
      if (nameToSocket.get(clientName) != null) {
        println("Player already exists!");
        writer.println("duplicateName");
        writer.flush();
        writer.close();
        reader.close();
        newClient.close();
      } else {
        nameToSocket.put(clientName, newClient);
        nameToReader.put(clientName, reader);
        nameToWriter.put(clientName, writer);
        println("Player joined: " + clientName);
        writeMessage(clientName, "success");
      }
    }     
    catch (SocketTimeoutException e) {
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }


  void removePlayer(String player) {
    try {
      nameToReader.get(player).close();
      nameToWriter.get(player).close();
      nameToSocket.get(player).close();
      nameToReader.remove(player);
      nameToWriter.remove(player);
      nameToSocket.remove(player);
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  List<Message> readMessages() {
    List<Message> messages = new ArrayList<Message>();
    String messageBody;
    // Get messages from all connected clients
    for (String name : nameToReader.keySet()) {
      BufferedReader reader = nameToReader.get(name);
      // Read messages until there are none left
      try {
        while (reader.ready() && (messageBody = reader.readLine()) != null) {
          messages.add(new Message(name, messageBody));
        }
      }
      catch (IOException e) {
        e.printStackTrace();
        println(name + " has been kicked");
        removePlayer(name);
      }
    } 
    return messages;
  }

  void writeMessage(String playerName, String message) {
    PrintWriter writer = nameToWriter.get(playerName);
    writer.println(message);
    writer.flush();
  }

  void writeMessageToAllPlayers(String message) {
    for (PrintWriter writer : nameToWriter.values()) {
      writer.println(message);
      writer.flush();
    }
  }
}

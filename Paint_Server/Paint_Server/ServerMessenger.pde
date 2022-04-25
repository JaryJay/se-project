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

public class ServerMessenger {

  ServerSocket serverSocket;
  Map<String, Socket> nameToSocket = new HashMap<String, Socket>();
  Map<String, BufferedReader> nameToReader = new HashMap<String, BufferedReader>();
  Map<String, PrintWriter> nameToWriter = new HashMap<String, PrintWriter>();

  void init() {
    try {
      serverSocket = new ServerSocket(45000);
      serverSocket.setSoTimeout(200);
    } 
    catch (IOException e) {
      throw new RuntimeException("Could not initialize server socket.");
    }
  }

  void update() {
    receiveNewPlayersIfAny();

    List<Message> messages = readMessages();
    for (Message message : messages) {
      handleMessage(message);
    }
  }

  private void receiveNewPlayersIfAny() {
    try {
      Socket newClient = serverSocket.accept();
      BufferedReader reader = new BufferedReader(new InputStreamReader(newClient.getInputStream()));
      PrintWriter writer = new PrintWriter(newClient.getOutputStream());
      String clientName = reader.readLine();
      nameToSocket.put(clientName, newClient);
      nameToReader.put(clientName, reader);
      nameToWriter.put(clientName, writer);
    } 
    catch (SocketTimeoutException e) {
      println("No new players");
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }

  private void handleMessage(Message message) {
    String[] split = message.body.split(" ");
    String messageType = split[0];
    switch (messageType) {
    case "host":
      println(message.playerName + " tried to host a game");
      break;
    case "join":
      println(message.playerName + " tried to join a game");
      try {
        int id = Integer.parseInt(split[1]);
        println(message.playerName + " tried to join game " + id);
      } 
      catch (NumberFormatException e) {
        System.err.println("Invalid message, expected 2nd word to be a number, actual = " + split[1]);
      }
      break;
    default:
      println("Received message " + message);
      break;
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
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  List<Message> readMessages() {
    List<Message> messages = new ArrayList<Message>();
    String messageBody;
    try {
      for (String name : nameToReader.keySet()) {
        BufferedReader reader = nameToReader.get(name);
        while ((messageBody = reader.readLine()) != null) {
          messages.add(new Message(name, messageBody));
        }
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
    return messages;
  }

  void writeMessage(String playerName, String message) {
    PrintWriter writer = nameToWriter.get(playerName);
    writer.write(message);
  }

  void writeMessageToAllPlayers(String message) {
    for (PrintWriter writer : nameToWriter.values()) {
      writer.write(message);
    }
  }
}

# se-project
👋Welcome to our grade 12 CS Sofware Engineering project!
Team Members: Jay, Nancy, Moid

## What is "Paint!"?

Paint! is a multiplayer turn-based drawing game🎨. Each round, one player tries their best to artistically depict🖌️ a given word. The others try to guess🤔 what the word is, and if they guess correctly🎉, they are rewarded with 100 points. The next round then begins. At the end of the game, the player with the highest number of points is victorious.🥇

## Features
Main Menu
Players can access a variety of buttons from the main menu:
- Host Game
- Join Game
- Instructions
- Quit

### Host or Join Games
Players can join other players’ games using the join button, or host a game to let other players join.
When a player joins a game, they need to enter their name and the ID of the game. The server receives this info and checks whether the player can join that game. If the player is able to join, then the server notifies the player that they joined successfully, and the server also notifies the host that another player has joined.

### Start Games
When a host thinks that enough players have joined, they can start the game’s first round. After the game has been started, no new players can join.
A host cannot start a game if there is only one player (the host). There has to be at least 2 players for a multiplayer game!
The host can customize the following (before the game starts):
- number of rounds
- word category
The number of rounds has to be at least the number of players (so that everyone gets to Paint!)

### Rounds
Each round, the server picks a player and picks a word. The server sends the word to the chosen player, and sends the name of the chosen player to all other players.
Rounds have a time limit that can be customized by the host. A round ends when

a) A player guesses correctly

b) The time limit has been reached

When a round ends, points are awarded/deducted accordingly and the next round starts.
When the last round ends, the game ends and the top three players’ scores are sent to everyone.

### Drawing
Each round one player is chosen to paint while the other players guess what the chosen player is painting. The painter can use different colors and brush sizes to paint whatever their heart desires.

### Guessing
Guessing players have access to a textbox into which they can enter their guesses. By pressing enter, the guess is sent to the server, and if it is correct, then the current round ends and the guesser is awarded 100 points for their efforts.
If no one guesses correctly and the time limit is reached, then the painter loses 10 points for painting badly.

# Four-in-row

Implementation of classic board game four in a row as iOS and iPadOS mobile game with 2 game mode: single player where you play vs AI, and multiplayer where 2 players play against each other. The whole application is developed in SpriteKie which I use for every aspect of the game, from menus through board mechanic. Board mechanic is based on a matrix that represents the current state of the board, and after each move, I search for a specific pattern in horizontal, vertical, and diagonal lines on board. This mechanic is also used to determine the next move of a CPU player, which is prioritized to defend from winning the move of the opponent, next if there is a possibility to win a match.

App can be splited into 4 section:
- Home screen - menu with game mode selection
- Game scree - view where we play game
- Board mechanic - alghoritm which determinate win on board, also selecting best move for our cpu player.
- Over screen - view showing result of game, allowing to restart game and go back to Home screen.

## Home Screen
Fist view of app, this is main menu allowing user to pick mode and start game. 
For menu button i use circle node from SpriteKit with falling animation after initial loading.
To determinate which button is taped I use coordinate, and chaking if coordinate of button are equal with tap coordinate.

## Game Screen
Screen where game take place.
Depending on the game mode players make moves in turns.
At this screen each object is created programmatically, via code. I use mask to create holes in game board node; animation are base on matrix of content rather that gravity.

## Board mechanic.
To determinate win situation on board, I've create algorithm which return all sequance on current board. Thats means alghoritm return array of 4-elements array which are sequence of coin on board in all possible diraction: horizontal, vertical, and diagonals in 2 directions. Algorithm skip empty slots on board to optimize searching of wining sequence.
This algorithm is also used to determinate next cpu moves, because goal of cpu player is win he always try to do best moves, 
exception is few first moves because alghoritm cannot determinate which is best move.

## Over screen
This screen is showed after game is compleat. It's show result of game: who wins, and allow to restart game in current mode ore go back to Home Screen to re-pick game mode.

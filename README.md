# Four-in-row

Swift implementation of classic game 'Four in row' using UIKit and SpriteKit

Game include 2 modes: single player - versus cpu, and multiplayer - player vs player.

This app uses SpriteKit which I use to every aspect of the game, from menus through game screen and over/result screen.

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

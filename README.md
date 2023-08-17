# Vintage Frozen Bubble for iOS Re-Implementation

I have always liked to play "Frozen Bubble" both on Linux Systems way back in the 90s and later on Android due to its simplicity and its lovely penguin artwork.

When I switched back to using an iPhone again, I missed this game. There were similar games in the AppStore but nothing that would compare to what I had in mind. 

So I decided to completely re-write this game from scratch using parts of the original artwork and sound effects. And, as opposed to fiddling around with old Java code I wanted to create a  modern implementation using Swift and the SpriteKit physics engine so that I wouldn't have to bother too much with object dynamics. 

The current implementation is fairly straightforward without too many bells and whistles. It is a pure single player game where the user can switch between two different bubble styles (plain or with marks for color blind people), and sound effects can be toggled. It also was designed to be vintage by default so I kept the original appearance and scale ratio even though the game does not occupy the entire screen (which is not a flaw to game experience - at least to my observation).

Additionally, the game provides to playmodes: a puzzle mode where you can solve levels of varying difficulty, and an arcade mode where the game provides a continuous flow of bubbles moving down.


#### Reset Highscores:

Then, there is there is a hidden code to separately reset the high score tables for either puzzle or arcade mode without re-installing the game. This code can be entered by tapping the top 3 buttons in the settings screen using following sequences:

##### Reset Puzzle Highscores:

1st button - 3 taps</br>
2nd button - 2 taps</br>
2nd button - 5 taps</br>

##### Reset Arcade Highscores:

1st button - 4 taps</br>
2nd button - 2 taps</br>
2nd button - 6 taps</br>


While I built this game for myself, I am happy to share! If you encounter any odd behaviour I'd be greatful if you dropped me a line.

Enjoy!


<img src="https://github.com/ulritter/FrozenBubbleSwift/blob/main/fb1.png" width = "200" height = "286">  <img src="https://github.com/ulritter/FrozenBubbleSwift/blob/main/fb2.png" width = "200" height = "286"> <img src="https://github.com/ulritter/FrozenBubbleSwift/blob/main/fb3.png" width = "200" height = "286">
<img src="https://github.com/ulritter/FrozenBubbleSwift/blob/main/fb4.png" width = "200" height = "286"> <img src="https://github.com/ulritter/FrozenBubbleSwift/blob/main/fb5.png" width = "200" height = "286"> <img src="https://github.com/ulritter/FrozenBubbleSwift/blob/main/fb6.png" width = "200" height = "286"> <img src="https://github.com/ulritter/FrozenBubbleSwift/blob/main/fb7.png" width = "200" height = "286"> <img src="https://github.com/ulritter/FrozenBubbleSwift/blob/main/fb8.png" width = "200" height = "286">


### Thanks and Credits to:

Guillaume Cottenceau: design & original programming
Alexis Younes (Ayo73): graphics & original website design
Matthias Le Bidan (Matths): sound & music
Kim and David Joham: level editor
Amaury Amblard-Ladurantie: original website coding & graphics support

and special thanks to:

Nicolas Ramz - http://www.warpdesign.fr/

for his code to be able to play Amiga Tracker Music xxx.mod files as low footprint background music!

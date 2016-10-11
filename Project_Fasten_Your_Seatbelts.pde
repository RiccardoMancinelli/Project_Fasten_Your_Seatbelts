//Hier komt alle code om de objecten uit ons spel te laden.

// This main tab will set up and run the game

Player player = new player();
World world = new world();

  boolean leftDown, rightDown;
  
  
void setup() {
  size(640, 480);

  // Initialize the ball and the paddle
  player.init();
  world.init();  
}

// All the code that alters the Game World goes here
void updateGame(){
  player.update();
  world.update();
}

// All the code that draws the Game World goes here
void drawGame(){
  player.draw();
  world.draw();
}

void draw() {
  background(0);
  
  updateGame(); // Update your game first
  drawGame();   // Draw your game after everything is updated
 
}

    void keyPressed(){
    if(keyCode == LEFT){leftDown = true;}
    if(keyCode == RIGHT){rightDown = true;}
    }
    void keyReleased(){
    if(keyCode == LEFT){leftDown = false;}
    if(keyCode == RIGHT){rightDown = false;}
    }
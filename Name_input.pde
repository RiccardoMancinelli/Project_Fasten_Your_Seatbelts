class nameInput{

 void draw() {
   background(namescreen);
    //textSize(62);
    fill(255);
    textAlign(CENTER, CENTER);
    //text("What is your name?", width/2, height/4);
    text(playerName, 0, 0, width, height);
    text("_ _ _", 0, 0, width, height);
    textSize(32);
    //text("Enter 3 letters.", width/2, height-64);
    textAlign(0,0);
    
  }
    
}
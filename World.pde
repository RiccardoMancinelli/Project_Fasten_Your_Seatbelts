class World {
  int nCloud = 10;
  int wolkid = 0;
  int nEnemy = 2;
  int nBird = 1;
  boolean alive = true;
  
  int[][] spawn = new int[8][100];    //maakt 8 locaties aan waarop we dingen kunnen spawnen (hokjes van 80 pixels) en maakt in totaal 100 waves 

  Player player = new Player();
  Camera camera = new Camera();
  Cloud [] cloud = new Cloud[nCloud];
  Enemy [] enemy = new Enemy[nEnemy];
  Bird_Pick_Up [] bird = new Bird_Pick_Up[nBird];

 //Initialize the game world
  void init(){
    player.init();
    camera.init();
    
    
    for (int i=0; i<nCloud; i++)
    {
    cloud[i] = new Cloud();
    cloud[i].init();
    cloud[i].x = int(random(width-80));
    cloud[i].origny = int(random(height-50));
    }
    
    for (int k=0; k<nBird; k++)
    {
    bird[k] = new Bird_Pick_Up();
    bird[k].init();
    }
    
    for (int j=0; j<nEnemy; j++)
    {
    enemy[j] = new Enemy();
    enemy[j].init();
    enemy[j].x = int(random(width-80));
    enemy[j].origny = int(random(height-50))-64;
    }
    

  }
 //Update the game 
  void update()
  {
   camera.update();
   player.update();
   for (int i=0; i<nCloud; i++)
    {
   cloud[i].update();
    }
   for (int j=0; j<nEnemy; j++)
    {
   enemy[j].update();
    }
    for (int k=0; k<nBird; k++)
    {
     bird[k].update();
    }
          
          
    for (int i=0; i<nCloud; i++)
    {
     if (player.y < cloud[i].y+12 && player.y > cloud[i].y && player.x>cloud[i].x && player.x<cloud[i].x+cloud[i].w && player.vy >=0 && player.landed == false) 
       {player.landed = true;  player.vy = 0; wolkid = i;}

     if ((player.x< cloud[wolkid].x || player.x > cloud[wolkid].x+cloud[wolkid].w) && player.landed == true && player.y != height-26+hoogte)
     {player.landed = false;}
    }
    
    if (player.y < height/2 && cameraSwitch == false ){        //activeert de camera
      cameraSwitch = true;
    }
  
      for (int j=0; j<nBird; j++)                              //pickup bird
    {
     if (player.y < bird[j].y+bird[j].h && player.y > bird[j].y && player.x>bird[j].x && player.x< bird[j].x+ bird[j].w) 
       {
       score += 50;
       bird[j].originy = int(random(-64))-hoogte;        //verbergt de item uit het scherm
       bird[j].x = int(random(width-80));
       bird[j].movey=0;
       }
    }
    
    if (player.y < height/2 && cameraSwitch == false ){        //activeert de camera
      cameraSwitch = true;
    }
  
    /* Collision met enemy , enemy raakt, alive false player valt naar beneden */
   for (int j = 0; j < nEnemy; j++) {
   if (player.y < enemy[j].y+20 && player.y > enemy[j].y && player.x>enemy[j].x && player.x<enemy[j].x+enemy[j].w+80 && alive == true) 
       {alive = false; 
        cameraSwitch = false;}
   }
   /*for (int j = 0; j < nEnemy; j++) {
   if (player.y < enemy[j].y+30 && player.x>enemy[j].x && alive == true) 
       {alive = false; 
       player.vy = 50; }
   }*/
   
   /*  NOG NIET AFGEMAAKT
    if (player.y < height/2 && cameraSwitch == true ){        //Zorgt dat de camera mee beweegt met de speler.  && player.vy<0
      camera.difference = 1;
      //camera.y += player.vy;
      //camera.starty = (height/2-player.y);
    } else
    {
     camera.difference = 0; 
    } */
    
    
  }
  //Draw the game
  void draw(){
    player.draw();
    camera.draw();
    for (int i=0; i<nCloud; i++)
    {
    cloud[i].draw();
    }
    for (int j=0; j<nEnemy; j++)
    {
    enemy[j].draw();
    }
    for (int k=0; k<nBird; k++)
    {
    bird[k].draw();
    }
    noStroke();
    fill(0,180,0); rect(0,464+hoogte,640,480-hoogte);  //tekent de grond
     
    fill(0,0,0); rect(16,16,64,16);    //tekent de achtergrond van de mana bar op x=16, y=16, x2=64, y2=16
    fill(255,0,0); rect(15,15,mana,15);    //tekent de hoeveelheid mana die je hebt lol
    fill(0,0,0);
    textSize(16);
    text("Hoogte:" +hoogte, 10, 64); 
    text("Score:" + score, 10, 128); 
    
  }
 

};
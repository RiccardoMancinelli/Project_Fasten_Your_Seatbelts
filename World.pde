class World {

  int wolkid = 0, cloudMax = 128, itemMax = 64, totalLevels = 80, totalLevelshard = 50, hardlimit = 140;        //Alle plaatsbare items initializen. Hardlimit is de level cap waarop we de moeilijke levels gaan gebruiken.
  float timer3;
  boolean showScore = false, showScore2 = false;
  int nCloud = 0, nEnemy = 0, nPowerUp = 0, nBird = 0, waves = 1000, horizontalItems = 11, leftOff = 0, fase = 0;
  boolean alive = true;
  int[][] spawn = new int[horizontalItems][waves];    //maakt 8 locaties aan waarop we dingen kunnen spawnen (hokjes van 80 pixels) en maakt in totaal ... waves 
  boolean[][] created = new boolean[horizontalItems][waves];  //variable om te kijken of het object dat gemaakt moetst worden ook echt gemaakt is.
  PImage img;
  Player player = new Player();
  Camera camera = new Camera();
  Cloud [] cloud = new Cloud[cloudMax];
  Enemy [] enemy = new Enemy[itemMax];
  Bird_Pick_Up [] bird = new Bird_Pick_Up[itemMax];
  Power_up [] powerUp = new Power_up[itemMax];
  
  void init() {
    
    img = loadImage("jetpackhud.png");  //laad HUD sprite voor jetpack
    
    ///////////////////////////////////////////////////////////////////
    ///////////////////Random generation///////////////////////////////
    /////////////////////////////////////////////////////////////////// 
    for (int y = 0; y<waves; y++)
    {
      for (int x = 0; x<horizontalItems; x++)
      {
        spawn[x][y] = 0;
        created[x][y]=false;          //This resets the previous random generation if the player went game over first
      }
    }
    layouts(0, 0);    //Maakt elke eerste scherm dezelfde layout
    for (int y = 4; y<waves; y+=4)
    {
      if (y <hardlimit)
      {
      layouts(int(random(totalLevels))+1, y);    //spawns random level layout
      } else
      {
       layoutshard(int(random(totalLevelshard)), y);    //spawns random level layout 
      }
    }


    ///////////////////////////////////////////////////////////////////
    ///////////////////Initialiseren van objecten//////////////////////
    /////////////////////////////////////////////////////////////////// 

    player.init();
    camera.init();       

    for (int i=0; i<cloudMax; i++)
    {        //maakt de wolken aan.
      cloud[i] = new Cloud();
      cloud[i].init();
      cloud[i].x = -128;        //hides the unused clouds from view
      cloud[i].y = 0;
      cloud[i].specialCloud = 0;
    }

    for (int j=0; j<itemMax; j++)
    {
      enemy[j] = new Enemy();
      enemy[j].init();
      enemy[j].d = 7;
      enemy[j].x = -128;
      enemy[j].origny = 0;

      bird[j] = new Bird_Pick_Up();
      bird[j].init();
      bird[j].x = -128;
      bird[j].y = 0;

      powerUp[j] = new Power_up();
      powerUp[j].init();
      powerUp[j].x = -128;        //hides the unused powerups from view
      powerUp[j].y = 0;
      powerUp[j].oldx = 0;
      powerUp[j].oldy = 0;
    }
  }


  void update()
  {
    ///////////////////////////////////////////////////////////////////
    ///////////////////Updates de objecten/////////////////////////////
    /////////////////////////////////////////////////////////////////// 

    camera.update();
    player.update();

    for (int i=0; i<cloudMax; i++)
    {
      cloud[i].update();
    }
    for (int j=0; j<itemMax; j++)
    {
      enemy[j].update();
      bird[j].update();
      powerUp[j].update();
    }

    ///////////////////////////////////////////////////////////////////
    ////////////////////////////Generation related/////////////////////
    ///////////////////////////////////////////////////////////////////
    if (hoogte>=leftOff*128-(height)) {
      generate(leftOff);
    }                    
    //Hij gaat verder met genereren waar hij gebleven was (leftOff)

    ///////////////////////////////////////////////////////////////////
    ////////////////////////////Wolk Collision/////////////////////////
    ///////////////////////////////////////////////////////////////////
    for (int i=0; i<cloudMax; i++)
    {
      if (player.y < cloud[i].y+12 && player.y > cloud[i].y && player.x>cloud[i].x && player.x<cloud[i].x+cloud[i].w+1 && player.vy >=0)
      {
        if  (cloud[i].specialCloud == 0 && player.landed == false)  
        {
          if (player.dir == 1) {
            player.img = player.spr_player_stand_left;
          }
          if (player.dir == 0) {
            player.img = player.spr_player_stand_right;
          }
          player.landed = true;  
          player.vy = 0; 
          wolkid = i; 
          player.bounce = false;
        }
        // jump cloud
        if  (cloud[i].specialCloud == 1 && player.landed == false)  
        { 
          if (player.dir == 1) {
            player.img = player.spr_player_stand_left;
          }
          if (player.dir == 0) {
            player.img = player.spr_player_stand_right;
          }
          player.vy = 0; 
          wolkid = i; 
          mana = maxmana; 
          player.landed = true; 
          player.bounce = true;
        }

       // moving cloud
        if  (cloud[i].specialCloud == 2)  
        { 
          player.vy = 0; 
          if (cloud[i].toggle == false){player.x += cloud[i].cloudSpeed;}
          if (cloud[i].toggle == true){player.x -= cloud[i].cloudSpeed;}
          wolkid = i; 
          mana = maxmana; 
          player.landed = true;        
          if (player.dir == 1) {
            player.img = player.spr_player_stand_left;
          }
          if (player.dir == 0) {
            player.img = player.spr_player_stand_right;
          }
        }
        
      } 
      }


      if ((player.x< cloud[wolkid].x || player.x > cloud[wolkid].x+cloud[wolkid].w) && player.landed == true && player.y != height-26+hoogte)
      {
        player.landed = false;
      }
    


    if (player.y < height/2 && cameraSwitch == false && alive == true) {        //activeert de camera
      cameraSwitch = true; 
      scrollsnelheid = 1;
    }
    ///////////////////////////////////////////////////////////////////
    ////////////////////////////Music//////////////////////////////////
    ///////////////////////////////////////////////////////////////////
    if (hoogte > 16000 && fase == 0)    //Fase is there to check wether the game is easy (0) or hard (1)
    {
        music.stop(); 
        music2.loop();
        fase = 1;
    } 
    if (hoogte < 16000 && fase == 1)    //Fase is there to check wether the game is easy (0) or hard (1)
    {
        music2.stop(); 
        music.loop();
        fase = 0;
    }
    ///////////////////////////////////////////////////////////////////
    ////////////////////////////Item Collision/////////////////////////
    ///////////////////////////////////////////////////////////////////

    for (int j=0; j<itemMax; j++)                              //pickup bird
    {

      if (player.y < bird[j].y+bird[j].h && player.y > bird[j].y && player.x>bird[j].x && player.x< bird[j].x+ bird[j].w && alive == true)  
      {
        file2.play();
        score += 500;
        bird[j].x = -125;        //verbergt de item uit het scherm. (Alternatief van instance_Destroy())
        bird[j].movey=0;
        spawn[bird[j].oldx][bird[j].oldy]=0;
        created[bird[j].oldx][bird[j].oldy]=false;
        showScore = true;
        timer3 = 30;
      }
      
    }
    for (int l=0; l<itemMax; l++)
    {

      if (player.y < powerUp[l].y+powerUp[l].h && player.y > powerUp[l].y && player.x>powerUp[l].x && player.x< powerUp[l].x+ powerUp[l].w && alive == true)  
      {
        score += 200;
        powerUp[l].x = -256;
        spawn[powerUp[l].oldx][powerUp[l].oldy]=0;
        created[powerUp[l].oldx][powerUp[l].oldy]=false;
       if (powerUp[l].powerID == 1){ player.timer = 600; mana = maxmana = 128;} //jetpack
       if (powerUp[l].powerID == 2){player.timer2 = 600; player.shield = true;} //schild
        file5.play();
        file.play();
        showScore2 = true;
        timer3 = 30;
      }
    }
    if (player.y < height/2 && cameraSwitch == false && alive == true ) {        //activeert de camera
      cameraSwitch = true;
    }

    /* Collision met enemy , enemy raakt, alive false player valt naar beneden */
    for (int j = 0; j < itemMax; j++) {
      if (player.y < enemy[j].y+enemy[j].h+10 && player.y > enemy[j].y && player.x>enemy[j].x && player.x<enemy[j].x+enemy[j].w && alive == true && player.shield == false) 
      {
        alive = false; 
        cameraSwitch = false;
        player.img = player.spr_player_dead;
       file1.play();
      }
    }
  }
  ///////////////////////////////////////////////////////////////////
  ////////////////////////////Draws the game world///////////////////
  ///////////////////////////////////////////////////////////////////
  void draw() {
    player.draw();
    camera.draw();
    for (int i=0; i<cloudMax; i++)
    {
      cloud[i].draw();
    }
    for (int j=0; j<itemMax; j++)
    {
      enemy[j].draw();
      powerUp[j].draw();
      bird[j].draw();
    }

    noStroke();
    fill(0, 180, 0); 
    rect(0, 476+hoogte, width, 495-hoogte);  //tekent de grond

    fill(0, 0, 0); 
    rect(player.x-maxmana/4-1, player.y-26, maxmana/2+1, 6);    //tekent de achtergrond van de mana bar op x=16, y=16, x2=64, y2=16
    img.resize(20, 20);
    fill(255, 0, 0); 
    rect(player.x-maxmana/4, player.y-25, mana/2, 5);    //tekent de hoeveelheid mana die je hebt.
    fill(0, 0, 0, 127);
    rect(2, 0, 128,44);
    
    fill(0, 0, 0, 127);
    rect(width-136, 0, width-4,54);
    fill(255);
    textSize(16);
    text("Hoogte:" +hoogte, 10, 16); 
    text("Score:" + (score + hoogte), 10, 32);
    Score score = highscores.getScore(0);
    text("Highscore:",width-128,16);
    text(score.score, width-128, + 32);
    text("By:"+ score.name, width-128, + 48);
    
    // Dit zorgt ervoor dat de score wordt weergeven en weer weg gaat als de tijd om is.
    if (showScore == true && timer3 > 0)
      {
        timer3 -=1;
        textSize(16);
        fill(#6C0E0E);
        text("+500", player.x - 20, player.y - 32); 
       // text(timer3, player.x, player.y); // timer3 test
      }
      if (showScore == true && timer3 == 0)
      {
        showScore = false;
      }
       if (showScore2 == true && timer3 > 0)
      {
        timer3 -=1;
        textSize(16);
        fill(#6C0E0E);
        text("+200", player.x - 20, player.y - 32); 
       // text(timer3, player.x, player.y); // timer3 test
      }
      if (showScore2 == true && timer3 == 0)
      {
        showScore2 = false;
      }
  }

  ///////////////////////////////////////////////////////////////////
  ////////////////////////////RANDOM GENERATION//////////////////////
  ///////////////////////////////////////////////////////////////////
  /* Deze code plaatst onze items aan de hand van de lijst die we eerder hebben gemaakt.*/
  void generate(int startCount)
  {
    for (int y = startCount; y<startCount+16; y++)                      //index staat voor het getal waarop we beginnen met tellen. +8 want 8 rijen objects per scherm.
    {
      for (int x = 0; x<horizontalItems; x++)
      {
          if (nEnemy==itemMax) {
            nEnemy=0;
          }
          if (nCloud==cloudMax) {
            nCloud=0;
          }
          
        //Spawning clouds.
        if (spawn[x][y] == 1 && created[x][y]==false)
        {

          cloud[nCloud].x = x*80;
          cloud[nCloud].origny = height-65-(128*y);
          cloud[nCloud].oldy = y;
          cloud[nCloud].oldx = x;
          cloud[nCloud].specialCloud = 0; 
          created[x][y]=true; 

          nCloud+=1;
        }
        //Spawning Enemies.
        if (spawn[x][y] == 2 && created[x][y]==false)
        {
          enemy[nEnemy].x = x*80 + (80-enemy[nEnemy].w)/2; //the '+ (80-enemywidth)/2' puts enemy in the middle of the grid.;
          enemy[nEnemy].origny = height-65-(128*y);
          created[x][y]=true; 
          enemy[nEnemy].d=2;
          nEnemy+=1;
        }
        //Spawning powerups.
        if (spawn[x][y] == 3 && created[x][y]==false)
        {

          if (nPowerUp==itemMax) {
            nPowerUp=0;
          }
          powerUp[nPowerUp].oldy = y;
          powerUp[nPowerUp].oldx = x;
          powerUp[nPowerUp].x = x*80+ (80-powerUp[nPowerUp].w)/2;
          powerUp[nPowerUp].origny = height-65-(128*y);
          powerUp[nPowerUp].powerID = 1;
          created[x][y]=true; 
          nPowerUp+=1;
        }
        //Spawning Jumpclouds.
        if (spawn[x][y] == 4 && created[x][y]==false)
        {
          cloud[nCloud].x = x*80;
          cloud[nCloud].origny = height-65-(128*y);
          cloud[nCloud].oldy = y;
          cloud[nCloud].oldx = x;
          cloud[nCloud].specialCloud = 1; 
          created[x][y]=true; 

          nCloud+=1;
        }
        //Spawning Birds
        if (spawn[x][y] == 5 && created[x][y]==false)
        {

          if (nBird==itemMax) {
            nBird=0;
          }
          bird[nBird].oldy = y;
          bird[nBird].oldx = x;
          bird[nBird].x = x*80+ (80- bird[nBird].w)/2;
          bird[nBird].originy = height-65-(128*y);
          created[x][y]=true; 
          nBird+=1;
        }
                //Spawning enemy cloud.
        if (spawn[x][y] == 6 && created[x][y]==false)
        {
          enemy[nEnemy].x = x*80; //the '+ (80-enemywidth)/2' puts enemy in the middle of the grid.;
          enemy[nEnemy].origny = height-65-(128*y);
          created[x][y]=true; 
          enemy[nEnemy].d=3;
          nEnemy+=1;
        }
                //Spawning moving enemy cloud.
        if (spawn[x][y] == 7 && created[x][y]==false)
        {
          enemy[nEnemy].x = x*80; //the '+ (80-enemywidth)/2' puts enemy in the middle of the grid.;
          enemy[nEnemy].origny = height-65-(128*y);
          created[x][y]=true; 
          enemy[nEnemy].d=4;
          nEnemy+=1;
        }
         //Spawning Rockets.
        if (spawn[x][y] == 8 && created[x][y]==false)
        {
          enemy[nEnemy].x = x*80 + (80-enemy[nEnemy].w)/2; //the '+ (80-enemywidth)/2' puts enemy in the middle of the grid.;
          enemy[nEnemy].origny = height-65-(128*y);
          created[x][y]=true; 
          enemy[nEnemy].d=5;
          nEnemy+=1;
        }
        //Spawning powerups. BARRIER
        if (spawn[x][y] == 9 && created[x][y]==false)
        {

          if (nPowerUp==itemMax) {
            nPowerUp=0;
          }
          powerUp[nPowerUp].oldy = y;
          powerUp[nPowerUp].oldx = x;
          powerUp[nPowerUp].x = x*80+ (80-powerUp[nPowerUp].w)/2;
          powerUp[nPowerUp].origny = height-65-(128*y);
          powerUp[nPowerUp].powerID = 2;
          created[x][y]=true; 
          nPowerUp+=1;
        }
              // Spawning Move clouds
        if (spawn[x][y] == 10 && created[x][y]==false)
        {

          cloud[nCloud].x = x*80;  
          cloud[nCloud].origny = height-65-(128*y);
          cloud[nCloud].oldy = y; // x en y in de tabel (level editor), niet laten bewegen 
          cloud[nCloud].oldx = x; // niet laten bewegen 
          cloud[nCloud].specialCloud = 2; // 2 variabelen start/end , 1 om bewegend te maken velocity
          created[x][y]=true; 

          nCloud+=1;
        }
        //Squirrel
        if (spawn[x][y] == 11 && created[x][y]==false)
        {
          enemy[nEnemy].x = x*80 + (80-enemy[nEnemy].w)/2; //the '+ (80-enemywidth)/2' puts enemy in the middle of the grid.;
          enemy[nEnemy].origny = height-65-(128*y);
          created[x][y]=true; 
          enemy[nEnemy].d=int(random(2));
          enemy[nEnemy].oldx=x;
          enemy[nEnemy].oldy=y;
          nEnemy+=1;
        }
      }
      leftOff = y;              //Dit is de Y waar het genereren de vorige keer ophield.
      }
    }
  
  ///////////////////////////////////////////////////////////////////
  ////////////////////////////RESET THE GAME/////////////////////////
  ///////////////////////////////////////////////////////////////////
  void reset()
  {
    wolkid = 0; 
    cloudMax = 128; 
    itemMax = 64;   //Alle plaatsbare items initializen
    nCloud = 0; 
    nEnemy = 0; 
    nPowerUp = 0; 
    nBird = 0; 
    waves = 500; 
    leftOff = 0;
    alive = true;
    player.bounce = false;
        
    player.reset();
    camera.init();     

    for (int y = 0; y<waves; y++)
    {
      for (int x = 0; x<horizontalItems; x++)
      {
        spawn[x][y] = 0;
        created[x][y]=false;          //This resets the previous random generation if the player went game over first
      }
    }
        layouts(0, 0);    //Maakt elke eerste scherm dezelfde layout
    for (int y = 4; y<waves; y+=4)
    {
      if (y <hardlimit)
      {
      layouts(int(random(totalLevels))+1, y);    //spawns random level layout
      } else
      {
       layoutshard(int(random(totalLevelshard)), y);    //spawns random level layout 
      }
    }

    for (int i=0; i<cloudMax; i++)
    {        //maakt de wolken aan.
      cloud[i].x = -128;        //hides the unused clouds from view
      cloud[i].y = 0;
      cloud[i].specialCloud = 0;
    }

    for (int j=0; j<itemMax; j++)
    {
      enemy[j].reset();
      bird[j].reset();
      powerUp[j].reset();
    }
  }
}
/*
boolean collisionCheck(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2)        //Doet alle collision checking.
 {
 boolean collision = false;
 
 if (y1 < y2 && y1 > y2 + h2 && x1>x2 && x1<x2 + w2) 
 {collision = true;}
 else
 {collision = false;}
 return collision;
 }*/
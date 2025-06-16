//declare variable of ControlP5
import controlP5.*;
ControlP5 controlP5;
Button playAgain;

import ddf.minim.*;

PVector upAcc, leftAcc, rightAcc, gravForce;
boolean up, left, right;
float acc = 2;  // Increase movement and jumping
float grav = 2;
float worldOffset = 0;

// Images and tokens
PImage coinImg, keyImage, aladdinImage, bgImage, bgTwoImg, treasureImg, bgThreeImg, healthImg;
PImage[] coinImages;
int score;
Background bg, bgTwo, bgThree;

// Minim audio variables
Minim minim = new Minim(this);
AudioPlayer bgMusic, gameMusic, celebration, coinCollect, keyCollect, jumpSound, bumpSound, deadSound, nLevelSound;

int gameState = 0;  // 0 = Title Screen, 1 = Instructions, 2 = Game
PImage couple, reunion, jinn, rArrow, lArrow, letterImg, spaceImg;
int keyMessageTimer = 0;
int treasureSpawnTimer = 240;  // 4 seconds
boolean treasureSpawned = false;
int treasureMessageTimer = 0;
int jasmineTimer = 420;  // 7 seconds at 60 FPS
boolean jasmineAppeared = false;
boolean victorySoundPlayed = false;
boolean playerIsDead = false;

Character player;
Princess princessJasmine;
ArrayList<Block> blocks = new ArrayList<>();
ArrayList<Token> tokens = new ArrayList<>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

float minDistance = 200;  // Minimum distance between blocks

void setup() {
  PFont arial = loadFont("Luminari-Regular-48.vlw");
  textFont(arial, 44);
  controlP5 = new ControlP5(this);
  playAgain = controlP5.addButton("playAgain", 0, width/2-60, height-200, 150, 50);
  // styling the button
  playAgain.getCaptionLabel().setFont(arial);
  playAgain.getCaptionLabel().setColor(color(245, 242, 66));  // Yellow text
  playAgain.setColorBackground(color(56, 10, 79));             // Button fill color
  playAgain.getCaptionLabel().setSize(20);
  playAgain.setColorActive(color(201, 173, 131));                 // hover color
  playAgain.setColorForeground(color(201, 173, 131));
  playAgain.setCaptionLabel("Play Again");
  playAgain.hide();  // So it doesn't show at start
  size(1000, 600);
  stroke(200);
  strokeWeight(2);
  fill(63);

  // Load background images
  bgImage = loadImage("./data/background2.png");
  bgTwoImg = loadImage("./data/background.png");
  bgThreeImg = loadImage("./data/background3.png");
  bgTwo = new Background(bgTwoImg, 5, 0.5);
  bgThree = new Background(bgThreeImg, 5, 0.5);
  bg = new Background(bgImage, 5, 0.5);

  // Load character and other images
  couple = loadImage("./data/couple.png");
  reunion = loadImage("./data/united.png");
  jinn = loadImage("./data/jinnS1.png");
  rArrow = loadImage("./data/rightArrow.png");
  lArrow = loadImage("./data/leftArrow.png");
  letterImg = loadImage("./data/letter.png");
  spaceImg = loadImage("./data/spaceBar.png");

  // Load sound files
  bgMusic = minim.loadFile( "theme.wav");
  gameMusic = minim.loadFile("data/gameMusic.mp3");
  coinCollect = minim.loadFile("data/coinCollect.wav");
  keyCollect = minim.loadFile("data/keyCollect.wav");
  jumpSound = minim.loadFile("data/jumpSound.wav");
  bumpSound = minim.loadFile("data/bumpSound.wav");
  celebration = minim.loadFile("data/celebration.mp3");
  deadSound = minim.loadFile("data/playerDied.mp3");
  nLevelSound = minim.loadFile("data/levelComp.wav");
  bgMusic.loop();

  // Load coin images
  coinImg = loadImage("./data/coin_0.png");
  coinImages = new PImage[8];
  for (int i = 0; i < 8; i++) {
    coinImages[i] = loadImage("./data/coin_" + i + ".png");
  }

  keyImage = loadImage("./data/key.png");
  healthImg = loadImage("./data/healthToken.png");
  treasureImg = loadImage("./data/treasure2.png");
  aladdinImage = loadImage("./data/aladdin_0.png");



  // Set up player movement vectors
  upAcc = new PVector(0, -acc * 24);
  leftAcc = new PVector(-acc, 0);
  rightAcc = new PVector(acc, 0);
  gravForce = new PVector(0, grav);

  player = new Character(new PVector(width / 20, height / 4));
  player.jumping = true;

  // Initial block generation
  createInitialBlocks();
  blocks.add(new Block(new PVector(width / 2, height - 20), new PVector(width * 30, 40))); // Example block

  // Adding tokens on the blocks
  for (int i = 1; i < blocks.size() - 1; i++) {
    if (random(1) < 0.8) {  // Places tokens on blocks randomly...
      tokens.add(new Coin(blocks.get(i), new PVector(50, -50), 35, coinImages));
      tokens.add(new Coin(blocks.get(i), new PVector(-50, -50), 35, coinImages));
      tokens.add(new Coin(blocks.get(i), new PVector(0, -50), 35, coinImages));
    }
  }

  // Spawn only one Key on a block toward the end
  int minBlockIndex = blocks.size() / 2;
  int maxBlockIndex = blocks.size() - 1;
  int randomBlockIndex = int(random(minBlockIndex, maxBlockIndex));
  tokens.add(new Key(blocks.get(randomBlockIndex), new PVector(0, -130), 100, keyImage));
}

void draw() {
  background(255);

  switch(gameState) {
  case 0:
    screenOneBg();
    screenOneText();
    coupleScreenOne();
    break;
  case 1:
    screenTwoBg();
    screenTwoText();
    break;
  case 2:
    mainGame();
    if (!gameMusic.isPlaying()) {
      bgMusic.pause();
      gameMusic.loop();
    }
    break;
  case 3:
    mainGame2(); // LEVEL TWO
    break;
  case 4:
    mainGame3();// LEVEL THREE
    break;
  case 5:
    victoryScreen();
    break;
  case 6:
    playerDied();
    gameMusic.pause();
    deadSound.play();
    break;
  }
}


void mousePressed() {
  if (gameState < 2) {
    gameState++;  // Move to the next game state
  }
}

void mainGame() {
  playAgain.hide();
  bg.drawMe(new PVector(worldOffset, 0));  // Moves background with world offset

  // SCORE DISPLAY
  image(coinImg, 40, 40, 50, 50);
  textAlign(LEFT);
  textSize(40);
  fill(56, 10, 79);
  text("Score: "+ score, 80, 55);


   // if player just collected the key, show message and wait 4 seconds before moving to level 2
  if (keyMessageTimer > 0) {
    KeySecuredMSG();
    keyMessageTimer--;
    if (keyMessageTimer <= 0) {
      gameState = 3;  // Transition to Level 2 after 4 seconds
      levelTwoInitialization();
    }
    return;  // Pause game while message is displayed
  }

  //if health is 0, player is dead — show death screen
  if (player.health <= 0 && gameState != 6) {
    gameState = 6;
    playerDied();
    return;
  }

  player.handleInput(up, left, right, upAcc, leftAcc, rightAcc);
  player.update();
  player.gravtityAndCollision(blocks, gravForce);  // Check player block collision and handle jumping
  worldOffset = player.pos.x - width / 2;  // Scroll the world with the player
  player.wrapHorizontal(width);// player wrapping LEFT TO RIGHT

  // Draw and handle blocks
  handleBlockRespawn();//remove old blocks and add new ones as player moves forward
  for (Block b : blocks) {
    if (b instanceof MovingBlock) {
      ((MovingBlock) b).update(player);  // Update moving blocks
    } else if (b instanceof SlipperyBlock) {
      ((SlipperyBlock) b).update(player);  // Apply slippery effect
    }
    b.drawMe(player);
  }

  // Handle token collisions
  for (int i = 0; i < tokens.size(); i++) {
    if (tokens.get(i).collisionDetection(player)) {
      if (tokens.get(i) instanceof Coin) {
        score++;
        coinCollect.rewind();
        coinCollect.play();
      } else if (tokens.get(i) instanceof Key) {
        score += 5;
        gameMusic.setGain(-40);  // Lower volume before pausing (range: -80 to 6)
        gameMusic.pause();
        nLevelSound.rewind();
        nLevelSound.play();
        keyMessageTimer = 240;  // 4 seconds
      }
      tokens.remove(i);
      i--;
    }
  }

  // Draw tokens
  for (Token t : tokens) {
    t.drawMe(player);
    if (t instanceof Coin) {
      ((Coin) t).updateAnimation();
    }
  }
  player.drawMe();
}

void levelTwoInitialization() {
  // Slower movement for Level 2
  acc = 1;                         // slower movement
  grav = 2.5;                        // Slightly heavier gravity


  // new bg for levek 2
  background(255);
  bgTwo.drawMe(new PVector(worldOffset, 0));




  // resetting player's position for Level 2
  player.pos = new PVector(width -950, height/4);

  // Clear previous level's objects
  blocks.clear();
  tokens.clear();

  // Initialize new level layout
  createInitialBlocks();
  blocks.add(new Block(new PVector(width / 2, height - 20), new PVector(width * 30, 40))); // Example block
  for (int i = 1; i < blocks.size() - 1; i++) {
    if (random(1) < 0.6) {
      tokens.add(new Coin(blocks.get(i), new PVector(50, -50), 35, coinImages));
      tokens.add(new Coin(blocks.get(i), new PVector(-50, -50), 35, coinImages));
      tokens.add(new Coin(blocks.get(i), new PVector(0, -50), 35, coinImages));
    }
  }

  // Add 10 snakes on random blocks
  for (int i = 0; i < 10; i++) {
    int index = int(random(1, blocks.size()));  // skip first block (player's block)
    Block b = blocks.get(index);
    PVector rel = new PVector(random(-b.dim.x/2 + 32, b.dim.x/2 - 32), -32);
    enemies.add(new Enemy(b, rel));
  }

  // Spawn 1 health token on a random block
  int hIndex = int(random(1, blocks.size())); // Skip first block
  Block hBlock = blocks.get(hIndex);
  tokens.add(new Health(hBlock, new PVector(0, -130), 100, healthImg));

  // Reset the treasure spawn variables
  treasureSpawnTimer = 480; //treasure will appear after 8 seconds
  treasureSpawned = false;



  //gameState = 3;
}

void mainGame2() {
  playAgain.hide();

  // Display treasure secured message when the timer is active
  if (treasureMessageTimer > 0) {
    TreasureSecuredMSG();
    treasureMessageTimer--;
    if (treasureMessageTimer <= 0) {
      gameState = 4;
      levelThreeInitialization();
    }
    return;  // Pause game while message is displayed
  }

  bgTwo.drawMe(new PVector(worldOffset, 0));
  gameMusic.setGain(100);

  // Display score
  image(coinImg, 40, 40, 50, 50);
  textAlign(LEFT);
  textSize(40);
  fill(56, 10, 79);
  text("Score: " + score, 80, 55);


  player.handleInput(up, left, right, upAcc, leftAcc, rightAcc);  // Player movement
  player.update();
  player.gravtityAndCollision(blocks, gravForce);
  worldOffset = player.pos.x - width / 2;
  player.wrapHorizontal(width);// player wrapping

  if (player.health <= 0 && gameState != 6) {
    gameState = 6;
    playerDied();
    return;
  }



  handleBlockRespawn();
  for (Block b : blocks) {
    if (b instanceof MovingBlock) {
      ((MovingBlock) b).update(player);
    } else if (b instanceof SlipperyBlock) {
      ((SlipperyBlock) b).update(player);
    }
    b.drawMe(player);
  }

  for (int i = 0; i < tokens.size(); i++) {
    if (tokens.get(i).collisionDetection(player)) {
      if (tokens.get(i) instanceof Coin) {
        score++;
        coinCollect.rewind();
        coinCollect.play();
      } else if (tokens.get(i) instanceof Treasure) {
        score += 10;  // Adjust score for treasure
        gameMusic.setGain(-40);  // Lower volume before pausing
        gameMusic.pause();
        nLevelSound.rewind();
        nLevelSound.play();
        treasureMessageTimer = 240;  // Set timer for treasure message (4 seconds)
        bgMusic.pause();
      } else if (tokens.get(i) instanceof Health) {
        player.health += 40;
        if (player.health > 100) player.health = 100; // Optional max cap
      }

      tokens.remove(i);
      i--;
    }
  }


  for (Enemy e : enemies) {
    e.update();
    e.drawMe(player);
    if (checkCollision(player, e)) {
      player.health -= 1;
      if (player.health <= 0) {
        player.health = 0;
        gameState = 6;
        playerDied();
        return;
      }
    }
  }





  // Treasure appears after 4 seconds
  if (!treasureSpawned && treasureSpawnTimer > 0) {
    treasureSpawnTimer--;
  } else if (!treasureSpawned) {
    int minBlockIndex = (blocks.size() * 2) / 3;     // start near the end
    int maxBlockIndex = blocks.size() - 1;           // very last block
    int randomBlockIndex = int(random(minBlockIndex, maxBlockIndex + 1));

    tokens.add(new Treasure(blocks.get(randomBlockIndex), new PVector(0, -130), 100, treasureImg));
    treasureSpawned = true;
  }





  for (Token t : tokens) {
    t.drawMe(player);
    if (t instanceof Coin) {
      ((Coin) t).updateAnimation();
    }
  }

  /*
      // Spawn only one healthToken on a block toward the end
   int minBlockIndex = blocks.size() / 3;
   int maxBlockIndex = blocks.size() * 2 / 3;
   int randomBlockIndex = int(random(minBlockIndex, maxBlockIndex));
   tokens.add(new Health(blocks.get(randomBlockIndex), new PVector(0, -50), 100, healthImg));
   
   */

  player.drawMe();
}

void mainGame3() {

  playAgain.hide();
  bgThree.drawMe(new PVector(worldOffset, 0));




  // Display score
  image(coinImg, 40, 40, 50, 50);
  textAlign(LEFT);
  textSize(40);
  fill(56, 10, 79);
  text("Score: " + score, 80, 55);


  player.handleInput(up, left, right, upAcc, leftAcc, rightAcc);// Player movement
  player.update();
  player.gravtityAndCollision(blocks, gravForce);
  worldOffset = player.pos.x - width / 2;
  player.wrapHorizontal(width);

  if (player.health <= 0 && gameState != 6) {
    gameState = 6;
    playerDied();
    return;
  }


  handleBlockRespawn();
  for (Block b : blocks) {
    if (b instanceof MovingBlock) {
      ((MovingBlock) b).update(player);
    } else if (b instanceof SlipperyBlock) {
      ((SlipperyBlock) b).update(player);
    }
    b.drawMe(player);
  }

  for (int i = 0; i < tokens.size(); i++) {
    if (tokens.get(i).collisionDetection(player)) {
      if (tokens.get(i) instanceof Coin) {
        score++;
        coinCollect.rewind();
        coinCollect.play();
      } else if (tokens.get(i) instanceof Treasure) {
        score += 10;  // Adjust score for treasure
        keyCollect.rewind();
        keyCollect.play();
        treasureMessageTimer = 240;  // Set timer for treasure message (4 seconds)
        bgMusic.pause();
      } else if (tokens.get(i) instanceof Health) {
        player.health += 40;
        if (player.health > 100) player.health = 100; // Optional max cap
      }

      tokens.remove(i);
      i--;
    }
  }




  for (Enemy e : enemies) {
    e.update();
    e.drawMe(player);
    if (checkCollision(player, e)) {// if player hits the snake
      player.health -= 1;// reduce health
      if (player.health <= 0) {
        player.health = 0;
        gameState = 6;// go to death screen
        playerDied();
        return;
      }
    }
  }


  for (Token t : tokens) {
    t.drawMe(player);
    if (t instanceof Coin) {
      ((Coin) t).updateAnimation();
    }
  }

  player.drawMe();

  // Countdown Jasmine timer
  if (!jasmineAppeared) {
    jasmineTimer--;
    if (jasmineTimer <= 0) {
      princessJasmine = new Princess();  // Create Jasmine after 7 seconds
      jasmineAppeared = true;
    }
  }

  // Draw Princess Jasmine if she has appeared
  if (jasmineAppeared && princessJasmine != null) {
    princessJasmine.update();
    princessJasmine.drawMe();
  }
  // Trigger victory screen if player touches Jasmine
  if (princessJasmine != null && checkCollision(player, princessJasmine)) {
    gameState = 5;  // Use a new state to display victory screen

    if (!victorySoundPlayed) {
      gameMusic.pause();           // Stop game music
      celebration.rewind();        // Make sure it plays from the beginning
      celebration.play();        // Play celebration sound
      victorySoundPlayed = true;   // So it doesn't repeat
    }
  }
}

void levelThreeInitialization() {
  // even more Slower movement for Level 3
  acc = 0.2;                         // Even slower
  grav = 5.5;                        // Higher gravity



  // darker background for Level 3
  background(255);
  bgTwo.drawMe(new PVector(worldOffset, 0));

  // reset player pos
  player.pos = new PVector(width -950, height/4);  // New position (can adjust as needed)

  // Clear previous level's objects
  blocks.clear();
  tokens.clear();
  enemies.clear();

  // Initialize new level layout
  createInitialBlocks();
  blocks.add(new Block(new PVector(width / 2, height - 20), new PVector(width * 30, 40))); // Example block
  for (int i = 1; i < blocks.size() - 1; i++) {
    if (random(1) < 0.6) {
      tokens.add(new Coin(blocks.get(i), new PVector(50, -50), 35, coinImages));
      tokens.add(new Coin(blocks.get(i), new PVector(-50, -50), 35, coinImages));
      tokens.add(new Coin(blocks.get(i), new PVector(0, -50), 35, coinImages));
    }
  }

  // Add 20 snakes on random blocks
  for (int i = 0; i < 20; i++) {
    int index = int(random(1, blocks.size()));  // skip first block (player's block)
    Block b = blocks.get(index);
    PVector rel = new PVector(random(-b.dim.x/2 + 32, b.dim.x/2 - 32), -32);
    enemies.add(new Enemy(b, rel));
  }

  // Spawn 2 health tokens on random blocks
  for (int i = 0; i < 2; i++) {
    int hIndex = int(random(1, blocks.size()));
    Block hBlock = blocks.get(hIndex);
    tokens.add(new Health(hBlock, new PVector(0, -50), 100, healthImg));
  }
  // Restart the game music for Level 3
  gameMusic.rewind();
  gameMusic.setGain(0);
  gameMusic.play();
}


void createInitialBlocks() {
  blocks.add(new Block(new PVector(0, height - 20), new PVector(200, 40))); // Start block

  for (int i = 1; i < 12; i++) {
    boolean validPosition = false;
    float newX = 0;
    float newY = 0;

    while (!validPosition) {
      newX = i * 200 + random(100, 300);
      newY = height - random(120, 360);

      validPosition = true;

      // Check against existing blocks to avoid clustering
      for (Block b : blocks) {
        float distance = dist(newX, newY, b.pos.x, b.pos.y);
        if (distance < minDistance) {
          validPosition = false;
          break;
        }
      }
    }

    float blockType = random(1);
    if (blockType < 0.2) {
      blocks.add(new SlipperyBlock(new PVector(newX, newY), new PVector(200, 40)));
    } else if (blockType < 0.5) {
      blocks.add(new MovingBlock(new PVector(newX, newY), new PVector(200, 40)));
    } else {
      blocks.add(new Block(new PVector(newX, newY), new PVector(200, 40)));
    }
  }
}

void handleBlockRespawn() {
  for (int i = blocks.size() - 1; i >= 0; i--) {
    Block b = blocks.get(i);

    if (b.pos.x + b.dim.x < worldOffset - width / 2) {
      blocks.remove(i);
      boolean validPosition = false;
      float newX = 0;
      float newY = 0;

      while (!validPosition) {
        newX = blocks.get(blocks.size() - 1).pos.x + random(300, 600);  // Random position
        newY = height - random(120, 360);  // Random height

        validPosition = true;

        for (Block b2 : blocks) {
          float distance = dist(newX, newY, b2.pos.x, b2.pos.y);
          if (distance < minDistance) {
            validPosition = false;
            break;
          }
        }
      }

      blocks.add(new Block(new PVector(newX, newY), new PVector(200, 40)));
    }
  }
}

// collision detection between aladdin and jasmine
boolean checkCollision(Character a, Character b) {
  return !(a.pos.x + a.dim.x / 2 < b.pos.x - b.dim.x / 2 ||
    a.pos.x - a.dim.x / 2 > b.pos.x + b.dim.x / 2 ||
    a.pos.y + a.dim.y / 2 < b.pos.y - b.dim.y / 2 ||
    a.pos.y - a.dim.y / 2 > b.pos.y + b.dim.y / 2);
}

// collision detection between aladdin and snakes enemy
boolean checkCollision(Character player, Enemy enemy) {
  float ex = -2 * player.pos.x + enemy.block.pos.x + enemy.relPos.x;
  float ey = enemy.block.pos.y - 10 + enemy.relPos.y;

  float px = player.pos.x;
  float py = player.pos.y;

  return !(px + player.dim.x / 2 < ex - enemy.dim.x / 2 ||
    px - player.dim.x / 2 > ex + enemy.dim.x / 2 ||
    py + player.dim.y / 2 < ey - enemy.dim.y / 2 ||
    py - player.dim.y / 2 > ey + enemy.dim.y / 2);
}

//-----------------------------------------ALL THE SCREENS---------------------------------------------------


void KeySecuredMSG() {
  pushMatrix();

  image(letterImg, width/2, 500, 912, 980);
  image(keyImage, 455, 180, 256, 64);
  textSize(70);
  fill(56, 10, 79);
  textAlign(CENTER);
  text("Well Done!", width/2, height-510);
  textSize(30);
  fill(82, 12, 7);
  text("You have secured the key!\nNow you have advanced to Level 2.\n Your next step is to find the treasue.", width/2, 300);


  popMatrix();
}

void TreasureSecuredMSG() {
  pushMatrix();
  tint(255, 255, 255, 156);
  image(bgImage, 500, 300, 1068, 1080);
  tint(255, 255, 255, 255);
  image(letterImg, width/2, 500, 912, 980);
  image(treasureImg, 530, 185, 511 *0.25, 590*0.25);
  textSize(70);
  fill(56, 10, 79);
  textAlign(CENTER);
  text("Excellent!", width/2, height-510);
  textSize(30);
  fill(82, 12, 7);
  text("You have unlocked the Treasure!\nNow you have advanced to Level 3.\n Find your beloved Princess Jasmine\n and rescue her .", width/2, 300);


  popMatrix();
}

void screenOneBg() {
  pushMatrix();
  tint(255, 255, 255, 156);
  image(bgImage, -30, -300, 1068, 1080);
  popMatrix();
}

void screenOneText() {
  pushMatrix();
  textSize(70);
  fill(56, 10, 79);
  textAlign(CENTER);
  text("Aladdin's Treasure\n Quest", width/2, height-460);
  textSize(19);
  text("Click anywhere on the screen\n to view Instructions", 740, 500);
  textSize(24);
  fill(82, 12, 7);
  text("Help Aladdin find the key\n to unlock the treasure\nand reconcile with his beloved \nPrincess Jasmine!", 740, 330);
  popMatrix();
}

void coupleScreenOne() {
  pushMatrix();
  tint(255, 255, 255, 255);
  scale(0.5);
  image(couple, width-700, 600, 835, 596);
  image(jinn, 0, 300, 402, 288);
  popMatrix();
}
void screenTwoBg() {
  pushMatrix();
  tint(255, 255, 255, 156);
  image(bgImage, -30, -300, 1068, 1080);
  tint(255, 255, 255, 255);
  image(letterImg, 40, 0, 912, 980);
  popMatrix();
}

void screenTwoText() {
  pushMatrix();
  textSize(70);
  fill(56, 10, 79);
  textAlign(CENTER);
  text("Instructions", width/2, height-510);
  textSize(19);
  text("Click anywhere on the screen\n to start Playing :))", width/2, 550);
  textSize(20);
  fill(82, 12, 7);
  textAlign(LEFT);
  text("- Use the arrow keys to move Aladdin left and right", 250, 200);
  text("- Press the space bar to make Aladdin jump", 250, 300);
  text("- First, you will find the key to the treasure", 250, 350);
  text("- Reach the treasure to rescue Princess Jasmine", 250, 400);
  text("- Avoid dangerous obstacles and tricky platforms", 250, 450);
  text("- Keep Track of your health", 250, 500);
  image(lArrow, 500, 220, 45.36, 44.94);
  image(rArrow, 550, 220, 45.36, 44.94);
  image(spaceImg, 350, 220, 120.26, 33.32);

  popMatrix();
}

void playerDied() {
  if (!playerIsDead) {
    playerIsDead = true;
    gameMusic.pause();
    bgMusic.pause();
    playAgain.show();
  }



  pushMatrix();
  tint(255, 255, 255, 156);
  image(bgImage, 500, 300, 1068, 1080);
  tint(255, 255, 255, 255);
  image(letterImg, width/2, 500, 912, 980);
  textSize(70);
  fill(56, 10, 79);
  textAlign(CENTER);
  text("Too Bad :(", width/2, height-510);
  textSize(30);
  fill(82, 12, 7);
  text("Unfortunately,\n Aladdin couldn't handle everything\nHe died :(", width/2, 300);
  popMatrix();
}


void victoryScreen() {
  pushMatrix();
  tint(255, 255, 255, 156);
  image(bgImage, 500, 300, 1068, 1080);
  tint(255, 255, 255, 255);
  image(letterImg, width/2, 500, 912, 980);
  image(reunion, 500, 300, 175, 352);
  textSize(70);
  fill(56, 10, 79);
  textAlign(CENTER);
  text("WOHOOO!", width/2, height-510);
  textSize(30);
  fill(82, 12, 7);
  text("You succesfully\n rescued your beloved Princess Jasmine", width/2, 500);
  textSize(35);
  fill(56, 10, 79);
  text("Your Total\n Score: "+ score, 300, 300);


  popMatrix();
  playAgain.show();  // Show Play Again button
}

void playAgain(int value) {
  // Reset all key gameplay states
  score = 0;
  player = new Character(new PVector(width / 20, height / 4));
  player.jumping = true;
  player.health = 100;
  playerIsDead = false;

  worldOffset = 0;
  keyMessageTimer = 0;
  treasureMessageTimer = 0;
  treasureSpawned = false;
  treasureSpawnTimer = 240;
  jasmineTimer = 420;
  jasmineAppeared = false;
  victorySoundPlayed = false;

  blocks.clear();
  tokens.clear();
  enemies.clear();

  createInitialBlocks();
  blocks.add(new Block(new PVector(width / 2, height - 20), new PVector(width * 30, 40)));

  for (int i = 1; i < blocks.size() - 1; i++) {
    if (random(1) < 0.8) {
      tokens.add(new Coin(blocks.get(i), new PVector(50, -50), 35, coinImages));
      tokens.add(new Coin(blocks.get(i), new PVector(-50, -50), 35, coinImages));
      tokens.add(new Coin(blocks.get(i), new PVector(0, -50), 35, coinImages));
    }
  }

  // Spawn a new key
  int minBlockIndex = blocks.size() / 2;
  int maxBlockIndex = blocks.size() - 1;
  int randomBlockIndex = int(random(minBlockIndex, maxBlockIndex));
  tokens.add(new Key(blocks.get(randomBlockIndex), new PVector(0, -50), 100, keyImage));

  // Reset music
  celebration.pause();
  celebration.rewind();
  gameMusic.rewind();
  gameMusic.loop();
  bgMusic.pause();

  gameState = 2;  // Back to main game
  playAgain.hide();
}




void keyPressed() {
  if (keyCode == RIGHT) right = true;
  if (keyCode == LEFT) left = true;
  if (keyCode == ' ') up = true;
}

void keyReleased() {
  if (keyCode == RIGHT) right = false;
  if (keyCode == LEFT) left = false;
  if (keyCode == ' ') up = false;
}

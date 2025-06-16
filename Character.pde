// character class that handles movement, animation, health, and interaction with blocks
// image refernce: https://gamehistory.org/aladdin-source-code/

class Character {

  PVector pos, vel, dim;
  float damp = 0.7; // Constant damping factor
  boolean jumping = false;
  int health = 100; // Health starts at 100
  int maxHealth = 100;
  Block block = null;



  PImage[] standing;
  PImage[] walking;
  int currentImgIdx = 0;
  PImage[] activeImgSeq;
  int state = 0;  // 0 = standing, 1 = walking


  Character(PVector pos) {
    this.pos = pos;
    this.vel = new PVector();
    this.dim = new PVector(32, 48);

    // Load animation sequences
    standing = new PImage[1]; // aladdin_0.png
    walking = new PImage[13];


    standing[0] = loadImage("./data/aladdin_0.png");

    // Load walking animation sequence from aladdin_1.png to aladdin_13.png
    for (int i = 0; i < 13; i++) {
      walking[i] = loadImage("./data/aladdin_" + (i + 1) + ".png"); // Start from 1 to 13
    }

    // initially set to standing image
    activeImgSeq = standing;
  }


  void move(PVector acc) {
    this.vel.add(acc);
  }


  void update() {
    this.vel.mult(this.damp);
    this.pos.add(this.vel);

    if (this.pos.y + this.dim.y / 2 > height) { // Land on the floor if falling off
      this.pos.y = height - this.dim.y / 2;
      this.vel.y = 0;
    }

    // Only update animation if the character is moving
    if (this.vel.mag() > 0.1) {
      if (frameCount % 6 == 0) {
        currentImgIdx++;
        if (currentImgIdx >= activeImgSeq.length) { // Loop animation
          currentImgIdx = 0;
        }
      }

      // Switch to walking state if moving horizontally
      if (this.vel.x != 0) {
        state = 1; // walking
        activeImgSeq = walking;
      }
    } else {
      // If character not moving i.e. vel.x == 0 then switch to standing state
      state = 0; // standing
      activeImgSeq = standing;
      currentImgIdx = 0; // Reset to aladdin_0.png
    }
  }

  // handle player movement
  void handleInput(boolean up, boolean left, boolean right, PVector upAcc, PVector leftAcc, PVector rightAcc) {
    if (up && !jumping) jump(upAcc);
    if (left) move(leftAcc);
    if (right) move(rightAcc);
  }

  // Check player block collision and handle jumping
  void gravtityAndCollision(ArrayList<Block> blocks, PVector gravForce) {
    if (block != null && !block.isOn(this)) {
      jumping = true;
    }

    if (jumping) {
      move(gravForce);
      for (Block b : blocks) {
        if (b.bump(this)) {
          if (vel.y > 0) {
            landOn(b);
          } else {
            fall();
          }
        }
      }
    }
  }

  // player wrapping
  void wrapHorizontal(float screenWidth) {
    if (pos.x > screenWidth) pos.x = 20;
    if (pos.x < 0) pos.x = screenWidth - 20;
  }



  void jump(PVector upAcc) {
    this.move(upAcc);
    this.jumping = true;
    jumpSound.rewind();
    jumpSound.play();
  }

  void landOn(Block b) { // Pass block as an argument
    this.jumping = false;
    this.block = b;
    this.pos.y = b.pos.y - this.dim.y / 2 - b.dim.y / 2;
    this.vel.y = 0;
  }

  void fall() {
    this.vel.y *= -1; // Keep existing fall effect
    this.health -= 10; // Reduce health when falling/hitting the blocks from below(head bumping)
    if (this.health < 0) {
      this.health = 0; // Prevent negative health
    }
  }

  // Draw the health bar on screen
  void drawHealthBar() {

    // Draw background for the health bar
    fill(0, 0, 0, 100);
    rect(-100, -300, 400, 40);

    // Draw the current health bar
    fill(255, 0, 0);
    float healthWidth = map(health, 0, maxHealth, 0, 400); // Map health to bar width
    rect(-100, -300, healthWidth, 40);
  }





  void drawMe() {
    pushMatrix();
    translate(this.pos.x, this.pos.y - 30);
    scale(0.25 );

    // Flip horizontally when moving left
    if (this.vel.x < 0) {
      scale(-1, 1);
    } else {
      scale(1, 1);
    }

    image(activeImgSeq[currentImgIdx], 0, 0);  // Draw the current animation frame



    /*
    fill(255, 0, 0);
     translate(this.pos.x, this.pos.y);
     ellipse(0, 0, this.dim.x, this.dim.y);
     */

    // Draw health bar
    drawHealthBar();

    popMatrix();
  }
}

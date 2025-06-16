// enemy class, a subclass of Character, that handles snake animation, movement, and collision with player

class Enemy extends Character {

  PImage[] snakeAnimation;
  int currentSnakeImgIdx = 0;
  float speed = 2;
  boolean movingRight = true;
  Block block;
  PVector relPos;

  Enemy(Block block, PVector relPos) {
    super(PVector.add(block.pos, relPos));
    this.block = block;
    this.relPos = relPos;
    this.dim = new PVector(32, 32);

    snakeAnimation = new PImage[5];
    for (int i = 0; i < 5; i++) {
      snakeAnimation[i] = loadImage("./data/snake_" + (i + 1) + ".png");
    }
    activeImgSeq = snakeAnimation;
  }

  void update() {

    this.pos = PVector.add(block.pos, relPos);

    // Move back and forth on the block
    if (movingRight) {
      relPos.x += speed;
      if (relPos.x > block.dim.x / 2 - this.dim.x / 2) {
        movingRight = false;
      }
    } else {
      relPos.x -= speed;
      if (relPos.x < -block.dim.x / 2 + this.dim.x / 2) {
        movingRight = true;
      }
    }


    if (frameCount % 5 == 0) {
      currentSnakeImgIdx = (currentSnakeImgIdx + 1) % snakeAnimation.length;
    }
  }

  void drawMe(Character c) {
    pushMatrix();
    translate(-2 * c.pos.x + this.block.pos.x, this.block.pos.y - 10);
    translate(this.relPos.x, this.relPos.y);
    scale(0.07);

    if (!movingRight) {
      scale(1, 1);
    } else {
      scale(-1, 1);  // flip image when moving right
    }


    image(snakeAnimation[currentSnakeImgIdx], 0, 0);

    popMatrix();
  }
}

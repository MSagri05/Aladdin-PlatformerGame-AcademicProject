// token class - a superclass for coin,key and treasure, representing collectible items

class Token {
  PVector relPos;
  Block block;
  float size;
  PImage img;

  Token(Block b, PVector rp, float s, PImage img) {
    this.block = b;
    this.relPos = rp;
    this.size = s;
    this.img = img;
  }

  void drawMe(Character c) {
    pushMatrix();
    translate(-2 * c.pos.x + this.block.pos.x, this.block.pos.y);
    translate(this.relPos.x, this.relPos.y);
    imageMode(CENTER);
    image(this.img, 0, 0, this.size, this.size);
    popMatrix();
  }

  boolean collisionDetection(Character c) {
    float tX = this.block.pos.x + this.relPos.x;
    float tY = this.block.pos.y + this.relPos.y;
    return dist(c.pos.x, c.pos.y, tX - 2 * c.pos.x, tY) < c.dim.x / 2 + this.size / 2;
  }
}

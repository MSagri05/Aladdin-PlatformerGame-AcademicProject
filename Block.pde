// block class that represents a platform for the character to stand on and handles collision

class Block {
  //fields
  PVector pos;
  PVector dim;
  color col;


  Block(PVector pos, PVector dim) {
    this.pos = pos;
    this.dim = dim;
    this.col = color(56, 27, 26);
  }
  
  // method to check character stays on the block
  boolean isOn(Character c) {
    if (abs(c.pos.x - (this.pos.x - 2 * c.pos.x)) < c.dim.x / 2 + this.dim.x / 2) {
      return true;
    }
    return false;
  }
  
  //collision detection for when the character is on the block
  boolean bump(Character c) {
    if (
      abs(c.pos.x - (this.pos.x - 2 * c.pos.x)) < c.dim.x / 2 + this.dim.x / 2 &&
      abs(c.pos.y - this.pos.y) < c.dim.y / 2 + this.dim.y / 2
    ) {
      return true;
    }
    return false;
  }
  
  void drawMe(Character c) {
    pushMatrix();
    stroke(this.col);
    fill(this.col);
    translate(-2 * c.pos.x + this.pos.x, this.pos.y);// move block position relative to character's
    rect(-this.dim.x / 2, -this.dim.y / 2, this.dim.x, this.dim.y);
    popMatrix();
  }
}

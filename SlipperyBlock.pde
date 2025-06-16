// SlipperyBlock class, a subclass of Block, that applies a slippery effect to the character

class SlipperyBlock extends Block {
  
  // Constructor
  SlipperyBlock(PVector pos, PVector dim) {
    super(pos, dim);
    this.col = color(105, 9, 65); // Give it a distinct color to differentiate
  }
  
  // Update method to apply slippery effect
  void update(Character c) {
    if (c.block != null && c.block == this) {
      if (c.vel.x > 0) {
        c.move(new PVector(2, 0)); // Slide character  to the right
        pushMatrix();
        textSize(30);
        fill(105, 9, 65);
        text("OOPS.. it's slippery",300,100);

        popMatrix();
      } else if (c.vel.x < 0) {
        c.move(new PVector(-2, 0)); // Slide character  to the left
        pushMatrix();
        textSize(30);
        fill(105, 9, 65);
        text("OOPS.. it's slippery",500,100);

        popMatrix();
      }
    }
  }
  
  // Override draw method 
  void drawMe(Character c) {
    pushMatrix();
    stroke(this.col);
    fill(this.col);
    translate(-2 * c.pos.x + this.pos.x, this.pos.y);
    rect(-this.dim.x / 2, -this.dim.y / 2, this.dim.x, this.dim.y);
    popMatrix();
  }
}

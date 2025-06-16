// moving block class, a subclass of Block, that moves vertically within defined limits

class MovingBlock extends Block {
  float upperLimit, lowerLimit;
  float vel;

  MovingBlock(PVector pos, PVector dim) {
    super(pos, dim);

    this.upperLimit = this.pos.y - 40;
    this.lowerLimit = this.pos.y + 40;
    this.col = color(79, 49, 3);


    if (int(random(2)) == 0) {
      this.vel = 3;
    } else {
      this.vel = -3;
    }
  }

  void update(Character c) {
    // Reverse direction when reaching upper or lower limits
    if ((this.pos.y < this.upperLimit && this.vel < 0) || 
        (this.pos.y > this.lowerLimit && this.vel > 0)) {
      this.vel *= -1;
    }

    // Move the block
    this.pos.add(new PVector(0, this.vel));

    // Move the character along with the block if it's standing on it
    if (c.block != null && c.block == this) {
      c.pos.set(c.pos.x, c.pos.y + this.vel);
    }
  }
}

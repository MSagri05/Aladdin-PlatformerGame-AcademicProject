// treasure subclass of Key - subclass of token, representing a collectible treasure item

class Treasure extends Key { 
  Treasure(Block b, PVector rp, float s, PImage img) {
    super(b, rp, s, img);
  }

  void drawMe(Character c) {
    pushMatrix();
    translate(-2 * c.pos.x + this.block.pos.x, this.block.pos.y);
    translate(this.relPos.x, this.relPos.y);
    scale(0.2);
    imageMode(CENTER);
    image(this.img, 0, -80, 511, 590);
    popMatrix();
  }
}

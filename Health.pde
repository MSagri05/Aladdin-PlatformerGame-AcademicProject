// health class - a subclass of token that draws a health token on the screen. i designed the health tokens myself using figma.

class Health extends Token {
  Health(Block b, PVector rp, float s, PImage img) {
    super(b, rp, s, img);
  }
  void drawMe(Character c) {
    pushMatrix();
    translate(-2 * c.pos.x + this.block.pos.x, this.block.pos.y);
    translate(this.relPos.x, this.relPos.y);
    scale(0.1);
    imageMode(CENTER);
    image(this.img, 0, 0, 622, 622); 
    popMatrix();
  }
}

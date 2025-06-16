// key class, a subclass of Token, that handles drawing the key in the game
// image reference: https://opengameart.org/content/key-icons

class Key extends Token {
  Key(Block b, PVector rp, float s, PImage img) {
    super(b, rp, s, img);
  }
  void drawMe(Character c) {
    pushMatrix();
    translate(-2 * c.pos.x + this.block.pos.x, this.block.pos.y);
    translate(this.relPos.x, this.relPos.y);
    imageMode(CENTER);
    image(this.img, 0, 0, 200, 60); 
    popMatrix();
  }
}

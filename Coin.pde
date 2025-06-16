// coin class, a subclass of Token, that handles spinning animation and drawing coin image
//image reference: https://opengameart.org/content/spinning-coin-anim


class Coin extends Token {
  PImage[] spinning;
  int currentImgIndex = 0;

  Coin(Block b, PVector rp, float s, PImage[] images) {
    super(b, rp, s, images[0]); // Start with first frame
    this.spinning = images;
  }

  void updateAnimation() {
    if (frameCount % 6 == 0) {
      currentImgIndex = (currentImgIndex + 1) % spinning.length;
      img = spinning[currentImgIndex];  // Update image
    }
  }


  void drawMe(Character c) {
    updateAnimation();
    super.drawMe(c);
  }
}

// background class that handles the image and makes it move and tile across the screen
// image refernce: https://www.artstation.com/artwork/8bOKKG

class Background {
  PImage img;
  int repeatX;
  float speed;

  Background(PImage img, int repeatX, float speed) {
    this.img = img;
    this.repeatX = repeatX;
    this.speed = speed;
  }


  // drawing bg with movement and tiling
  void drawMe(PVector pos) {

    tint(255, 255, 255, 180); // a little transparent
    pos.mult(this.speed);
    int tilesX = -floor(pos.x / img.width);

    for (int i = tilesX - 1; i < tilesX + repeatX; i++) {
      
      image(img, pos.x + img.width * i, 300); // Fix Y to 0 (or another desired Y position)
    }

    noTint();
  }
}

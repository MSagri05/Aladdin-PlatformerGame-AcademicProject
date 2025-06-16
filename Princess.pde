// princess class - a subclass of character that shows princess jasmine with a looping animation
//image refernce: https://tenor.com/en-CA/view/disney-princess-jasmine-aladdin-sad-gif-16982856564758729798

class Princess extends Character {

  PImage[] jasmineAnimation; 
  int currentJasmineImgIdx = 0;
  boolean isForward = true;

  // Directly setting the position 
  Princess() {
    super(new PVector(900, 530));  // setting position directly here
    this.dim = new PVector(32, 48); 
    jasmineAnimation = new PImage[19]; 

    // Load the Jasmine animation images
    for (int i = 0; i < 19; i++) {
      jasmineAnimation[i] = loadImage("./data/jasmine" + (i + 1) + ".png");
    }
    activeImgSeq = jasmineAnimation; 
  }

  void update() {
    super.update();

    // Animation logic
    if (frameCount % 6 == 0) {
      if (isForward) {
        currentJasmineImgIdx++;  // move forward through the animation
        if (currentJasmineImgIdx >= jasmineAnimation.length) {
          currentJasmineImgIdx = jasmineAnimation.length - 2;  
          isForward = false;
        }
      } else {
        currentJasmineImgIdx--;  // move backward through the animation
        if (currentJasmineImgIdx < 0) {
          currentJasmineImgIdx = 1; 
          isForward = true;
        }
      }
    }
  }

  void drawMe() {
    pushMatrix();
    translate(this.pos.x, this.pos.y);  // Jasmine's fixed position
    scale(0.5); 

    image(jasmineAnimation[currentJasmineImgIdx], 0, 0); 

    popMatrix();
  }
}

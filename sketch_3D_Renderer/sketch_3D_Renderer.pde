byte movementKeys = 0;
static final byte space = 0b0000001;
static final byte c =     0b0000010;
static final byte a =     0b0000100;
static final byte d =     0b0001000;
static final byte w =     0b0010000;
static final byte s =     0b0100000;

Layer defaultLayer = new Layer();
Layer[] mainCameraLayers = {defaultLayer};

Cube[] Cubes = {
  new Cube(defaultLayer, 0,  0,  0),
  new Cube(defaultLayer, 2,  0,  0),
  new Cube(defaultLayer, 4,  0,  0),
  new Cube(defaultLayer, 0,  -2,  0),
};

Camera Cam = new Camera(0, 1.8f, 195, 200, mainCameraLayers);

void setup() {
  size(640, 480);
  frame.setResizable(true);
  frameRate(1000);

  background(0);
  fill(255);
  noStroke();
}

void draw() {
  background(0);
  
  MoveCamera(Cam, 1);
  Cam.Run();

  DrawDebugInfo();
}

void MoveCamera(Camera camera, float speed) {
  if ((movementKeys & space) == space) {
    camera.yPos += speed/50;
  }
  if ((movementKeys & c) == c) {
    camera.yPos -= speed/50;
  }
  if ((movementKeys & a) == a) {
    camera.xPos += speed/50;
  }
  if ((movementKeys & d) == d) {
    camera.xPos -= speed/50;
  }
  if ((movementKeys & w) == w) {
    camera.zPos += speed/50;
  }
  if ((movementKeys & s) == s) {
    camera.zPos -= speed/50;
  }
}

void DrawDebugInfo(){
  textSize(12);
  fill(100);
  rect(0, 0, 90, 40);
  fill(255);
  text((int) frameRate + "fps", 5, 15);
  text((int) Cam.xPos + ", " + (int) Cam.yPos + ", " + ((int) Cam.zPos - (int) Cam.focalLength), 5, 30);
}

void keyPressed() {
  if (key == ' ') {
    movementKeys |= space;
  }
  if (key == 'c') {
    movementKeys |= c;
  }
  if (key == 'a') {
    movementKeys |= a;
  }
  if (key == 'd') {
    movementKeys |= d;
  }
  if (key == 'w') {
    movementKeys |= w;
  }
  if (key == 's') {
    movementKeys |= s;
  }
}

void keyReleased() {
  if (key == ' ') {
    movementKeys &= ~space;
  }
  if (key == 'c') {
    movementKeys &= ~c;
  }
  if (key == 'a') {
    movementKeys &= ~a;
  }
  if (key == 'd') {
    movementKeys &= ~d;
  }
  if (key == 'w') {
    movementKeys &= ~w;
  }
  if (key == 's') {
    movementKeys &= ~s;
  }
}

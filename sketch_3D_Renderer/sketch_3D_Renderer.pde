byte movementKeys = 0;
static final byte space = 0b0000001;
static final byte c =     0b0000010;
static final byte a =     0b0000100;
static final byte d =     0b0001000;
static final byte w =     0b0010000;
static final byte s =     0b0100000;

Layer higherLayer = new Layer();
Layer defaultLayer = new Layer();
Layer lowerLayer = new Layer();
Layer[] mainCameraLayers = {lowerLayer, defaultLayer, higherLayer};

Cube[] lowerCubes = {
  new Cube(lowerLayer,  0,  0,   0),
};
Cube[] Cubes = {
  new Cube(defaultLayer, 0,  0,  0),
};
Cube[] higherCubes = {
  new Cube(higherLayer,  0,  0,  0),
};

Camera Cam = new Camera(0, 1.8f, -25, 672, mainCameraLayers);

void setup() {
  size(640, 480);
  surface.setResizable(true);
  frameRate(1000);

  background(0);
  fill(255);
  strokeWeight(3);
  noStroke();
  
  //colour meshes by layer
  for(int i = 0; i < lowerLayer.meshes.size(); ++i){
    for(int j = 0; j < lowerLayer.meshes.get(i).edges.size(); ++j){
      lowerLayer.meshes.get(i).edges.get(j).edgeColour = #00ffff;
    }
  }
  for(int i = 0; i < defaultLayer.meshes.size(); ++i){
    for(int j = 0; j < defaultLayer.meshes.get(i).edges.size(); ++j){
      defaultLayer.meshes.get(i).edges.get(j).edgeColour = #ff00ff;
    }
  }
  for(int i = 0; i < higherLayer.meshes.size(); ++i){
    for(int j = 0; j < higherLayer.meshes.get(i).edges.size(); ++j){
      higherLayer.meshes.get(i).edges.get(j).edgeColour = #ffff00;
    }
  }
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
  rect(0, 0, 120, 60);
  fill(255);
  text((int) frameRate + "fps", 5, 15);
  text("Position: " + (int) Cam.xPos + ", " + (int) Cam.yPos + ", " + ((int) Cam.zPos - (int) Cam.focalLength), 5, 30);
  text("Focal Length: " + (int) Cam.focalLength, 5, 45);
}

void mousePressed() {
  if(mouseButton == LEFT){
    for(int i = 0; i < lowerCubes.length; ++i){
      lowerCubes[i].mesh.z += 1;
    }
    for(int i = 0; i < Cubes.length; ++i){
      Cubes[i].mesh.z -= 1;
    }
    for(int i = 0; i < higherCubes.length; ++i){
      higherCubes[i].mesh.y -= 1;
    }
  }
  if(mouseButton == RIGHT){
    for(int i = 0; i < lowerCubes.length; ++i){
      lowerCubes[i].mesh.z -= 1;
    }
    for(int i = 0; i < Cubes.length; ++i){
      Cubes[i].mesh.z += 1;
    }
    for(int i = 0; i < higherCubes.length; ++i){
      higherCubes[i].mesh.y += 1;
    }
  }
}

void keyPressed() {
  if(key == CODED){
    if(keyCode == UP){
      Cam.focalLength -= 10;
      Cam.zPos -= 10;
    }
    if(keyCode == DOWN){
      Cam.focalLength += 10;
      Cam.zPos += 10;
    }
  }
  
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

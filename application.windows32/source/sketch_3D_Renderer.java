import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_3D_Renderer extends PApplet {

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
  new Cube(lowerLayer, 0, 0, 0), 
};
Cube[] Cubes = {
  new Cube(defaultLayer, 0, 0, 0), 
};
Cube[] higherCubes = {
  new Cube(higherLayer, 0, 0, 0), 
};

Camera Cam = new Camera(0, 1.8f, -25, 672, mainCameraLayers);

public void setup() {
  
  surface.setResizable(true);
  frameRate(1000);

  background(0);
  fill(255);
  strokeWeight(1);
  noStroke();

  //colour meshes by layer
  for (int i = 0; i < lowerLayer.meshes.size(); ++i) {
    for (int j = 0; j < lowerLayer.meshes.get(i).edges.size(); ++j) {
      lowerLayer.meshes.get(i).edges.get(j).edgeColour = 0xff00ffff;
    }
  }
  for (int i = 0; i < defaultLayer.meshes.size(); ++i) {
    for (int j = 0; j < defaultLayer.meshes.get(i).edges.size(); ++j) {
      defaultLayer.meshes.get(i).edges.get(j).edgeColour = 0xffff00ff;
    }
  }
  for (int i = 0; i < higherLayer.meshes.size(); ++i) {
    for (int j = 0; j < higherLayer.meshes.get(i).edges.size(); ++j) {
      higherLayer.meshes.get(i).edges.get(j).edgeColour = 0xffffff00;
    }
  }
}

public void draw() {
  background(0);

  MoveCamera(Cam, 1);
  Cam.Run();

  DrawDebugInfo();
}

public void MoveCamera(Camera camera, float speed) {
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

public void DrawDebugInfo() {
  textSize(12);
  fill(100);
  rect(0, 0, 120, 60);
  fill(255);
  text((int) frameRate + "fps", 5, 15);
  text("Position: " + (int) Cam.xPos + ", " + (int) Cam.yPos + ", " + ((int) Cam.zPos - (int) Cam.focalLength), 5, 30);
  text("Focal Length: " + (int) Cam.focalLength, 5, 45);
}

public void mousePressed() {
  if (mouseButton == LEFT) {
    for (int i = 0; i < lowerCubes.length; ++i) {
      lowerCubes[i].mesh.z += 1;
    }
    for (int i = 0; i < Cubes.length; ++i) {
      Cubes[i].mesh.z -= 1;
    }
    for (int i = 0; i < higherCubes.length; ++i) {
      higherCubes[i].mesh.y -= 1;
    }
  }
  if (mouseButton == RIGHT) {
    for (int i = 0; i < lowerCubes.length; ++i) {
      lowerCubes[i].mesh.z -= 1;
    }
    for (int i = 0; i < Cubes.length; ++i) {
      Cubes[i].mesh.z += 1;
    }
    for (int i = 0; i < higherCubes.length; ++i) {
      higherCubes[i].mesh.y += 1;
    }
  }
}

public void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      Cam.focalLength -= 10;
      Cam.zPos -= 10;
    }
    if (keyCode == DOWN) {
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

public void keyReleased() {
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
class Camera {
  float xPos;
  float yPos;
  float zPos;
  float focalLength;
  ArrayList<Layer> layers = new ArrayList<Layer>();

  Camera(float xPosition, float yPosition, float zPosition, float FocalLength, Layer[] Layers) {
    xPos = xPosition;
    yPos = yPosition;
    zPos = zPosition + FocalLength;
    focalLength = FocalLength;
    for (Layer L : Layers) {
      layers.add(L);
    }
  }

  public void Run() {
    DrawObject(false, true);
    
    /*for(Mesh M : layers.get(0).meshes){
      for(int i = 0; i < layers.get(0).meshes.get(0).verts.size(); ++i){
        M.verts.get(i).x += random(-0.001, 0.001);
        M.verts.get(i).y += random(-0.001, 0.001);
        M.verts.get(i).z += random(-0.001, 0.001);
      }
    }*///uncomment for funny
  }

  public void DrawObject(boolean drawVerts, boolean markPoints) {
    if(markPoints){
      textSize(8);
    }
    
    //Iterate from back layer to front layer
    for (int l = 0; l < layers.size(); ++l) {
      Layer currentLayer = layers.get(l);

      for (int m = 0; m < currentLayer.meshes.size(); ++m) {
        Mesh currentMesh = currentLayer.meshes.get(m);
        currentMesh.projectedVerts = new ArrayList<Vertex>();

        //Project and draw verts
        for (int i = 0; i < currentMesh.verts.size(); ++i) {
          //Check near and far clipping
          if (currentMesh.verts.get(i).z + currentMesh.z > zPos - focalLength && currentMesh.verts.get(i).z + currentMesh.z < zPos - focalLength + 200) {
            //Raycast through screen
            float ProjectedX = ((currentMesh.verts.get(i).x + xPos + currentMesh.x) * focalLength) / (focalLength + currentMesh.verts.get(i).z + currentMesh.z - zPos);
            float ProjectedY = ((currentMesh.verts.get(i).y + yPos + currentMesh.y) * focalLength) / (focalLength + currentMesh.verts.get(i).z + currentMesh.z - zPos);
            currentMesh.projectedVerts.add(new Vertex(ProjectedX, ProjectedY, zPos + focalLength));

            if (drawVerts) {
              noStroke();
              fill(255);
              ellipse(
                currentMesh.projectedVerts.get(i).x + width/2, 
                currentMesh.projectedVerts.get(i).y + height/2, 
                10 / (currentMesh.verts.get(i).z + currentMesh.z - (zPos - focalLength)), 
                10 / (currentMesh.verts.get(i).z + currentMesh.z - (zPos - focalLength))
                );
            }
            if (markPoints) {
              fill(255, 0, 0);
              text(
                nf(currentMesh.x + currentMesh.verts.get(i).x, 0, 0) + ", " + 
                nf(currentMesh.y + currentMesh.verts.get(i).y, 0, 0) + ", " + 
                nf(currentMesh.z + currentMesh.verts.get(i).z, 0, 0),
                currentMesh.projectedVerts.get(i).x + width/2, 
                currentMesh.projectedVerts.get(i).y + height/2
                );
            }
          } else {
            currentMesh.projectedVerts.add(null);
          }
        }

        //Draw edges from projected verts
        for (int e = 0; e < currentMesh.edges.size(); ++e) {
          Edge currentEdge = currentMesh.edges.get(e);

          //Check if verts have been projected i.e. between clipping planes
          if (currentMesh.projectedVerts.get(currentEdge.vert1) != null && currentMesh.projectedVerts.get(currentEdge.vert2) != null) {
            stroke(currentEdge.edgeColour);
            line(
              currentMesh.projectedVerts.get(currentEdge.vert1).x + width/2, 
              currentMesh.projectedVerts.get(currentEdge.vert1).y + height/2, 
              currentMesh.projectedVerts.get(currentEdge.vert2).x + width/2, 
              currentMesh.projectedVerts.get(currentEdge.vert2).y + height/2
              );
          }
        }
      }
    }
  }
}
class Cube {
  Vertex[] pointArray = {
  new Vertex(-1, -1, -1), 
  new Vertex(-1, -1,  1), 
  new Vertex(-1,  1, -1), 
  new Vertex(-1,  1,  1), 
  new Vertex( 1, -1, -1), 
  new Vertex( 1, -1,  1), 
  new Vertex( 1,  1, -1), 
  new Vertex( 1,  1,  1)
  };
  
  Edge[] edgeArray = {
    new Edge(0, 1),
    new Edge(0, 2),
    new Edge(0, 4),
    new Edge(1, 5),
    new Edge(1, 3),
    new Edge(2, 6),
    new Edge(2, 3),
    new Edge(3, 7),
    new Edge(4, 5),
    new Edge(4, 6),
    new Edge(5, 7),
    new Edge(6, 7),
  };
 
  Mesh mesh;
  
  Cube(Layer layer, float x, float y, float z){
    mesh = new Mesh(layer, pointArray, edgeArray, x, y, z);
  }
}
class Edge {
  int vert1;
  int vert2;
  int edgeColour;

  Edge(int vertex1, int vertex2) {
    vert1 = vertex1;
    vert2 = vertex2;
    edgeColour = 0xffffffff;
  }
  
  Edge(int vertex1, int vertex2, int Colour) {
    vert1 = vertex1;
    vert2 = vertex2;
    edgeColour = Colour;
  }
}
class Layer {
  ArrayList<Mesh> meshes = new ArrayList<Mesh>();

  Layer(Mesh[] Meshes) {
    for (Mesh M : Meshes) {
      meshes.add(M);
    }
  }

  Layer() {
  }
}
class Mesh {
  Layer layer;

  ArrayList<Vertex> verts = new ArrayList<Vertex>();
  ArrayList<Vertex> projectedVerts = new ArrayList<Vertex>();
  ArrayList<Edge> edges = new ArrayList<Edge>();
  
  float x;
  float y;
  float z;

  Mesh(Layer RenderLayer, Vertex[] Vertices, Edge[] Edges) {
    for (Vertex V : Vertices) {
      verts.add(new Vertex(V.x, V.y, V.z));
    }
    for (Edge E : Edges) {
      edges.add(new Edge(E.vert1, E.vert2));
    }
    
    x = 0;
    y = 0;
    z = 0;

    layer = RenderLayer;
    layer.meshes.add(this);
  }
  
  Mesh(Layer RenderLayer, Vertex[] Vertices, Edge[] Edges, float xPosition, float yPosition, float zPosition) {
    for (Vertex V : Vertices) {
      verts.add(new Vertex(V.x, V.y, V.z));
    }
    for (Edge E : Edges) {
      edges.add(new Edge(E.vert1, E.vert2));
    }
    
    x = xPosition;
    y = yPosition;
    z = zPosition;

    layer = RenderLayer;
    layer.meshes.add(this);
  }
}
class Vertex {
  float x;
  float y;
  float z;

  Vertex(float xPosition, float yPosition, float zPosition) {
    x = xPosition;
    y = yPosition;
    z = zPosition;
  }
}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_3D_Renderer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

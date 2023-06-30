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

  void Run() {
    DrawObject(false, true);
    
    /*for(Mesh M : layers.get(0).meshes){
      for(int i = 0; i < layers.get(0).meshes.get(0).verts.size(); ++i){
        M.verts.get(i).x += random(-0.001, 0.001);
        M.verts.get(i).y += random(-0.001, 0.001);
        M.verts.get(i).z += random(-0.001, 0.001);
      }
    }*///uncomment for funny
  }

  void DrawObject(boolean drawVerts, boolean markPoints) {
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

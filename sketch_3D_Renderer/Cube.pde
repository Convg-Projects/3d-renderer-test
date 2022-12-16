class Cube {
  Vertex[] pointArray = {
  new Vertex(-1, -1, -1), 
  new Vertex(-1, -1,  0), 
  new Vertex(-1,  1, -1), 
  new Vertex(-1,  1,  0), 
  new Vertex( 1, -1, -1), 
  new Vertex( 1, -1,  0), 
  new Vertex( 1,  1, -1), 
  new Vertex( 1,  1,  0)
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

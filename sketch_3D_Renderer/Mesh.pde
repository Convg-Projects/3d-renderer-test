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

class Edge {
  int vert1;
  int vert2;
  color edgeColour;

  Edge(int vertex1, int vertex2) {
    vert1 = vertex1;
    vert2 = vertex2;
    edgeColour = #ffffff;
  }
  
  Edge(int vertex1, int vertex2, color Colour) {
    vert1 = vertex1;
    vert2 = vertex2;
    edgeColour = Colour;
  }
}

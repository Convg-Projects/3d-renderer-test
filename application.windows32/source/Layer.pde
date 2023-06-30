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

class GraphController {

  DistrictData data;
  //Graph graph;
  selectionGUI gui;

  public GraphController(String filename){
    data = new DistrictData(filename);
    gui  = new selectionGUI();
  }

  public void render() {
    int[] selectedVars      = gui.varsSelected();
    String[][] selectedData = data.getColumns(selectedVars[0],selectedVars[1]);

  }

}

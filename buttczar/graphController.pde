class GraphController {

  DistrictCollection districts;
  //Graph graph;
  selectionGUI gui;

  public GraphController(String filename){
    districts = new DistrictCollection(filename);
    gui  = new selectionGUI();
  }

  public void render() {
    int[] selectedVars      = gui.varsSelected();
    String[][] selectedData = data.getColumns(selectedVars[0],selectedVars[1]);

    //graph.displayData(selectedData);

  }

}

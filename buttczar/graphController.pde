import controlP5.*;

class GraphController {

  DistrictCollection districts;
  Graph graph;
  ControlP5 cp5;
  DropdownSelectGroup dropdowns;

  // constants
  final float SELECTION_GUI_HEIGHT = 50;

  public GraphController(String filename, ControlP5 _cp5){
    cp5 = _cp5;
    PFont pfont = createFont("Arial", 12);
    textFont(pfont);
    ControlFont cp5font = new ControlFont(pfont);
    cp5.setControlFont(cp5font);

    districts = new DistrictCollection(filename);
    dropdowns = new DropdownSelectGroup(cp5, districts.variableNames,
                                             districts.stateNames);
    graph = new Graph(50, 75, 650, 650);
  }

  public void draw() {
    int x_column_idx = dropdowns.selectedXIndex();
    int y_column_idx = dropdowns.selectedYIndex();
    int z_column_idx = dropdowns.selectedZIndex();
    String selected_state = dropdowns.selectedStateName();
    String[][] selectedData = districts.getColumns(x_column_idx,
                                     y_column_idx, z_column_idx);
    graph.setVariables(selectedData);
    graph.draw();
    dropdowns.draw(0, 10, width, SELECTION_GUI_HEIGHT);
  }

  // ControlP5 event handler, delegates events to interested objects
  public void controlEvent(ControlEvent e) {
    dropdowns.controlEvent(e);
  }

}

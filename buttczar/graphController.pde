import controlP5.*;

class VizController {

  DistrictCollection districts;
  Graph graph;
  ControlP5 cp5;
  DropdownSelectGroup dropdowns;
  IndiaMap map; 

  // constants
  final float SELECTION_GUI_HEIGHT = 50;
  

  public VizController(String filename, ControlP5 _cp5){
    cp5 = _cp5;
    PFont pfont = createFont("Arial", 12);
    textFont(pfont);
    ControlFont cp5font = new ControlFont(pfont);
    cp5.setControlFont(cp5font);

    districts = new DistrictCollection(filename);
    dropdowns = new DropdownSelectGroup(cp5, districts.variableNames,
                                             districts.stateNames);
    graph = new Graph(50, 75, 650, 650);
    map = new IndiaMap(650, 400, 100, 100);
  }

  public void draw() {
    int x_column_idx = dropdowns.selectedXIndex();
    int y_column_idx = dropdowns.selectedYIndex();
    int z_column_idx = dropdowns.selectedZIndex();
    String selected_state = dropdowns.selectedStateName();
    String[][] selectedData = districts.getColumnsForState(x_column_idx,
                             y_column_idx, z_column_idx, selected_state);
    graph.setVariables(selectedData);
    graph.draw();
    // getSelectedDistrictNames() must be called after graph.draw()
    ArrayList selected_districts = graph.getSelectedDistrictNames();
    //println(selected_districts);
    dropdowns.draw(0, 10, width, SELECTION_GUI_HEIGHT);
  }

  void mousePressed() { graph.mousePressed(); }
  void mouseClicked() { graph.mouseClicked(); }

  // ControlP5 event handler, delegates events to interested objects
  public void controlEvent(ControlEvent e) {
    dropdowns.controlEvent(e);
  }

}

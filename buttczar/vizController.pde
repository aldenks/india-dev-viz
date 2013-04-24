import controlP5.*;

class VizController {

  DistrictCollection districts;
  Graph graph;
  ControlP5 cp5;
  DropdownSelectGroup dropdowns;
  IndiaMap map;
  int prev_x_col_idx, prev_y_col_idx, prev_z_col_idx;
  String prev_state;

  // constants
  final float SELECTION_GUI_HEIGHT = 50;

  public VizController(String filename, String state_filename, ControlP5 _cp5, PApplet a){
    cp5 = _cp5;
    PFont pfont = createFont("Arial", 12);
    textFont(pfont);
    ControlFont cp5font = new ControlFont(pfont);
    cp5.setControlFont(cp5font);

    districts = new DistrictCollection(filename, state_filename);
    dropdowns = new DropdownSelectGroup(cp5, districts.variableNames,
                                             districts.stateNames);
    graph = new Graph(50, 75, 650, 650);
    map = new IndiaMap(650, 400, 100, 100, a);
  }

  public void draw() {
    int x_column_idx      = dropdowns.selectedXIndex();
    int y_column_idx      = dropdowns.selectedYIndex();
    int z_column_idx      = dropdowns.selectedZIndex();
    String selected_state = dropdowns.selectedStateName();

    if(x_column_idx != prev_x_col_idx || y_column_idx != prev_y_col_idx ||
        z_column_idx != prev_z_col_idx || prev_state != selected_state){

      String[][] selectedData = districts.getColumnsForState(x_column_idx,
                             y_column_idx, z_column_idx, selected_state);
      graph.setVariables(selectedData);
    }
    graph.draw();
    // getSelectedDistrictNames() must be called after graph.draw()
    //println(selected_districts);
    dropdowns.draw(0, 10, width, SELECTION_GUI_HEIGHT);
<<<<<<< HEAD
    ArrayList selected_districts = graph.getSelectedDistrictNames();
    //map.updateSelectedDistricts(selected_districts);
=======
>>>>>>> cd034a05d1ec081aec9343234b373daed38ab62c
    map.draw();

    prev_x_col_idx = x_column_idx;
    prev_y_col_idx = y_column_idx;
    prev_z_col_idx = z_column_idx;
    prev_state     = selected_state;

  }

  void mousePressed() { graph.mousePressed(); }
  void mouseClicked() { graph.mouseClicked(); }

  // ControlP5 event handler, delegates events to interested objects
  public void controlEvent(ControlEvent e) {
    dropdowns.controlEvent(e);
  }

}

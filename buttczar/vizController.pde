import controlP5.*;

class VizController {

  DistrictCollection districts;
  Graph graph;
  ControlP5 cp5;
  DropdownSelectGroup dropdowns;
  IndiaMap map;
  int prev_x_col_idx, prev_y_col_idx, prev_z_col_idx;
  String prev_state;
  color[] stateColors;

  // constants
  final float SELECTION_GUI_HEIGHT = 50;

  public VizController(String filename, String state_filename, ControlP5 _cp5, PApplet a){
    initColors();
    cp5 = _cp5;
    PFont pfont = createFont("Arial", 12);
    textFont(pfont);
    ControlFont cp5font = new ControlFont(pfont);
    cp5.setControlFont(cp5font);

    districts = new DistrictCollection(filename, state_filename);
    dropdowns = new DropdownSelectGroup(cp5, districts.variableNames,
                                             districts.stateNames);
    graph = new Graph(50, 75, 650, 650);
    map = new IndiaMap(stateColors, a);
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
    dropdowns.draw(0, 10, width, SELECTION_GUI_HEIGHT);
    ArrayList selected_districts = graph.getSelectedDistrictNames();
    if (selected_districts.size() != 0) {
      selected_districts = districts.getIDsFromNames(selected_districts);
      map.updateSelectedDistricts(selected_districts);
    }
    else {
      selected_districts = new ArrayList();
    } 
    map.updateSelectedDistricts(selected_districts);
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

  void initColors() {
    int[] R = {176, 180, 123, 95, 16, 0, 60, 0, 0, 107, 128, 189,
               217, 255, 139, 153, 255, 255, 184, 255, 255, 250, 255, 
               238, 255, 255, 178, 255, 205, 255, 208, 176, 128, 255, 153, 92 }; 
    int[] G = {226, 205, 104, 158, 78, 206, 190, 250, 128, 142, 128, 183,
               217, 236, 129, 204, 255, 215, 134, 165, 120, 128, 99, 
               121, 69, 0, 34, 192, 104, 105, 32, 48, 0, 0, 50, 51};
    int[] B = {255, 205, 238, 160, 139, 209, 113, 154, 0, 35, 0, 107,
               143, 139, 76, 50, 0, 0, 11, 0, 0, 114, 71, 
               66, 0, 0, 34, 203, 137, 180, 144, 96, 128, 255, 204, 23};
    stateColors = new color[36];
    for (int i=0; i< R.length; i++){
      stateColors[i] = color(R[i], G[i], B[i], 100);
    }
  }
    

}

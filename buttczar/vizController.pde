import controlP5.*;

class VizController {
  final int GRAPH_X = 50;
  final int GRAPH_Y = 75;
  final int GRAPH_W = 650;
  final int GRAPH_H = 650;

  DistrictCollection districts;
  Graph graph;
  ControlP5 cp5;
  DropdownSelectGroup dropdowns;
  IndiaMap map;
  int prev_x_col_idx, prev_y_col_idx, prev_z_col_idx;
  ArrayList old_selected_districts;
  ArrayList new_selected_districts;
  String prev_state;
  HashMap<String, Integer> stateColors;

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
    initColors();
    graph = new Graph(GRAPH_X,GRAPH_Y,GRAPH_W,GRAPH_H);
    map = new IndiaMap(stateColors, a, districts.districts);
    old_selected_districts = new ArrayList();
    new_selected_districts = new ArrayList();
    map.draw();
  }

  public void draw() {
    int x_column_idx      = dropdowns.selectedXIndex();
    int y_column_idx      = dropdowns.selectedYIndex();
    int z_column_idx      = dropdowns.selectedZIndex();
    String selected_state = dropdowns.selectedStateName();

    if(x_column_idx != prev_x_col_idx || y_column_idx != prev_y_col_idx ||
       z_column_idx != prev_z_col_idx || prev_state != selected_state){
      String[][] selectedData = districts.getColumnsForState(x_column_idx,
          y_column_idx, z_column_idx, selected_state, true);
      //TODO add actual coal filter to last boolean
      graph.setVariables(selectedData);
    }
    graph.draw();
    // getSelectedDistrictNames() must be called after graph.draw()

    dropdowns.draw(0, 10, width, SELECTION_GUI_HEIGHT);

    new_selected_districts = graph.getSelectedDistrictNames();
    if (old_selected_districts.equals(new_selected_districts)) {
      map.updateSelectedDistricts(districts.getIDsFromNames(new_selected_districts));
      map.draw();
    }
    else {
      map.drawImage();
    }

    old_selected_districts.clear();
    for (int i = 0; i < new_selected_districts.size(); i++) {
      old_selected_districts.add(new_selected_districts.get(i));
    }

    prev_x_col_idx = x_column_idx;
    prev_y_col_idx = y_column_idx;
    prev_z_col_idx = z_column_idx;
    prev_state     = selected_state;
  }

  void mousePressed() { graph.mousePressed(); }
  void mouseClicked() {
    if(mouseX > GRAPH_X && mouseX < GRAPH_X + GRAPH_W &&
        mouseY > GRAPH_Y && mouseY < GRAPH_Y + GRAPH_H){
      graph.mouseClicked();
    }
  }

  // ControlP5 event handler, delegates events to interested objects
  public void controlEvent(ControlEvent e) {
    dropdowns.controlEvent(e);
  }

  void initColors() {
    int[] R = {176, 180, 123, 95, 16, 0, 60, 0, 0, 107, 128, 189,
               217, 255, 139, 153, 255, 255, 184, 255, 255, 250, 255,
               238, 255, 255, 178, 255, 205, 255, 208, 176, 128, 255, 153};
    int[] G = {226, 205, 104, 158, 78, 206, 190, 250, 128, 142, 128, 183,
               217, 236, 129, 204, 255, 215, 134, 165, 120, 128, 99,
               121, 69, 0, 34, 192, 104, 105, 32, 48, 0, 0, 50};
    int[] B = {255, 205, 238, 160, 139, 209, 113, 154, 0, 35, 0, 107,
               143, 139, 76, 50, 0, 0, 11, 0, 0, 114, 71,
               66, 0, 0, 34, 203, 137, 180, 144, 96, 128, 255, 204};

    stateColors = new HashMap(36);
    for (int i=0; i< R.length; i++){
      stateColors.put(districts.stateNames[i], color(R[i], G[i], B[i], 150));
    }
  }

}

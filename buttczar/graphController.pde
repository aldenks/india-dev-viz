import controlP5.*;

class GraphController {

  DistrictCollection districts;
  //Graph graph;
  ControlP5 cp5;
  selectionGUI gui;

  // constants
  final float SELECTION_GUI_HEIGHT = 50;


  public GraphController(String filename, ControlP5 _cp5){
    cp5 = _cp5;
    PFont pfont = createFont("Arial", 12);
    ControlFont cp5font = new ControlFont(pfont);
    cp5.setControlFont(cp5font);

    districts = new DistrictCollection(filename);
    // TODO pass in real names
    String[] column_names = { "Hello", "This is a longer name asklj sakl",
                              "what's up", "yo", "derp", "herp", "blerp" };
    gui = new selectionGUI(cp5, column_names);
  }

  public void render() {
    int[] selectedVars      = gui.varsSelected();
    String[][] selectedData = districts.getColumns(selectedVars[0],selectedVars[1]);
    //graph.displayData(selectedData);
    gui.render(0, 0, width, SELECTION_GUI_HEIGHT);
  }

  // ControlP5 event handler, delegates events to interested objects
  public void controlEvent(ControlEvent e) {
    gui.controlEvent(e);
  }

}

import controlP5.*;

final float SELECTS_HEIGHT = 50;

class selectionGUI {

  // graphical objects
  ControlP5             cp5;
  GraphController       gController;
  DropdownSelectGroup   column_selects;

  public selectionGUI() {
    cp5 = new ControlP5();
    PFont pfont = createFont("Arial", 12); //use true/false for smooth/no-smooth
    ControlFont cp5font = new ControlFont(pfont);
    cp5.setControlFont(cp5font);

    String[] column_names = { "Hello", "This is a longer name asklj sakl",
                              "what's up", "yo", "derp", "herp", "blerp" };
    column_selects = new DropdownSelectGroup(cp5, column_names);

  }


  // return which data variables are being selected by the gui
  public int[] varsSelected(){
    // for now this is just garbage
    int[] data = new int[2];
    data[0]    = 3;//tot pop // x var
    data[1]    = 6;//tot lit // y var
    return data;
  }

  // ControlP5 event handler, delegates events to interested objects
  private void controlEvent(ControlEvent e) {
    if (e.isGroup()) {
      column_selects.controlEvent(e);
    }
    else if (e.isController()) {
    }
  }

}

import controlP5.*;

class selectionGUI {

  // graphical objects
  ControlP5 cp5;
  DropdownSelectGroup column_selects;

  public selectionGUI(ControlP5 _cp5, String[] column_names) {
    cp5 = _cp5;
    column_selects = new DropdownSelectGroup(cp5, column_names);
  }

  void render(float x, float y, float w, float h) {
    column_selects.draw(x,y,w,h);
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
  public void controlEvent(ControlEvent e) {
    column_selects.controlEvent(e);
  }

}

import controlP5.*;

// data
DistrictData districts;

// graphical objects
ControlP5 cp5;
GraphController gController;
DropdownSelectGroup column_selects;

// constants
final float SELECTS_HEIGHT = 50;
final String input_filename = "../data/districtsSelectVariables.csv";

void setup() {
<<<<<<< HEAD
  gController = new GraphController(input_filename);
=======
    size(1000, 500);
    districts = new DistrictData("../data/districts.csv");
    print(districts.getDistrict("Kargil").getVariable("TOT_POP"));

    cp5 = new ControlP5(this);
    PFont pfont = createFont("Arial", 12); // use true/false for smooth/no-smooth
    ControlFont cp5font = new ControlFont(pfont);
    cp5.setControlFont(cp5font);

    String[] column_names = { "Hello", "This is a longer name asklj sakl",
                              "what's up", "yo", "derp", "herp", "blerp" };
    column_selects = new DropdownSelectGroup(cp5, column_names);
    gController = new GraphController(input_filename);
>>>>>>> a7b679c3442bf1f956e6340d3fecd00fc9f6c4c3
}

void draw() {
    background(255);
    column_selects.draw(0, 0, width, SELECTS_HEIGHT);
    // example usage
    int x_column_idx = column_selects.selectedXIndex();
    int y_column_idx = column_selects.selectedYIndex();
    int z_column_idx = column_selects.selectedZIndex();
    gController.render();
}

// ControlP5 event handler, delegates events to interested objects
void controlEvent(ControlEvent e) {
  if (e.isGroup()) {
    column_selects.controlEvent(e);
  }
  else if (e.isController()) {
  }
}

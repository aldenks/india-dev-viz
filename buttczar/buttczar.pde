import controlP5.*;

final String INPUT_FILENAME = "../data/districtsSelectVariables.csv";
GraphController gController;
ControlP5 cp5;

void setup() {
  size(800, 800);
  cp5 = new ControlP5(this);
  gController = new GraphController(INPUT_FILENAME, cp5);
}

void draw() {
  background(255);
  gController.draw();
}

// ControlP5 event handler, delegates events to interested objects
public void controlEvent(ControlEvent e) {
  if (e.isGroup()) {
    gController.controlEvent(e);
  }
  else if (e.isController()) {
  }
}

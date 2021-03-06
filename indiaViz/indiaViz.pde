import controlP5.*;

final String INPUT_FILENAME = "./data/districtsNewLabels.csv";
final String STATE_FILENAME = "./data/states.csv";
VizController vController;
ControlP5 cp5;

void setup() {
  smooth();
  size(1300, 800);
  cp5 = new ControlP5(this);
  vController = new VizController(INPUT_FILENAME, STATE_FILENAME, cp5, this);
}

void draw() {
  background(255);
  vController.draw();
}

void mousePressed() { vController.mousePressed(); }
void mouseClicked() { vController.mouseClicked(); }

// ControlP5 event handler, delegates events to interested objects
public void controlEvent(ControlEvent e) {
  if (e.isGroup()) {
    vController.controlEvent(e);
  }
  else if (e.isController()) {
  }
}

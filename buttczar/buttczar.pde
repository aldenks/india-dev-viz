final String INPUT_FILENAME = "../data/districtsSelectVariables.csv";
GraphController gController;

void setup() {
  size(1000, 500);
  gController = new GraphController(INPUT_FILENAME);
}

void draw() {
  background(255);
  gController.render();
}



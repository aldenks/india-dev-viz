GraphController gController;

final String input_filename = "../data/districtsSelectVariables.csv";

void setup() {
  gController = new GraphController(input_filename);
}

void draw() {
  gController.render();
}


DistrictData districts;

void setup() {
    size(500, 500);
    districts = new DistrictData("../data/districtsSelectVariables.csv");
    String test[][] = districts.getColumns(3,6);
    for (int i = 0; i < test[0].length; i++) {
        println(test[0][i] + " " + test[1][i]
              + " " + test[2][i]);
    }
         
}

void draw() {

}


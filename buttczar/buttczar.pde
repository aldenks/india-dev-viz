DistrictData districts;

void setup() {
    size(500, 500);
    districts = new DistrictData("../data/districts.csv");
    District d = districts.getDistrict("Baramula");
    for (int i = 0; i < d.data.length; i++) {
        println(d.data[i]);
    }
}

void draw() {

}
    

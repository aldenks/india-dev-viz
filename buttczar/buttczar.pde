DistrictData districts;

void setup() {
    size(500, 500);
    districts = new DistrictData("../data/districts.csv");
    print(districts.getDistrict("Kargil").getVariable("TOT_POP"));
}

void draw() {

}
    

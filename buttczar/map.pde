import com.reades.mapthing.*;
import net.divbyzero.gpx.*;
import net.divbyzero.gpx.parser.*;
import java.util.Iterator;

class IndiaMap {
  HashMap<String, Integer> stateColors;
  HashMap<Integer, Polygons> districtsToHighlight;
  Polygons[] states;
  color[] colors; 
  ArrayList selectedDistricts;
  int x,y,w,h;
  BoundingBox boundary;
  Polygons allStates;
  Polygons districts;
  HashMap<String, Polygons> nameToDistrict;
  Polygons[] idToDistrict;
  PApplet app; 
  PImage currentMap; 
  final int NUMBER_OF_STATES = 35;

  public IndiaMap(HashMap<String, Integer> _colors, PApplet a, HashMap<String, District> distNames) {
    stateColors = _colors;
    app = a; 
    boundary = new BoundingBox(48, 105, -2, 15); 
    boundary = new BoundingBox(44, 101, 2, 19); 
    allStates   = new Polygons(boundary, dataPath("shapes/states.shp"));
    allStates.setLocalSimplificationThreshold(0.1);
    districts = new Polygons(boundary, dataPath("shapes/districts.shp"));
    districts.setLocalSimplificationThreshold(0.1);
    districtsToHighlight = districts.getPolygonsWithId("DISTRICT_I");

    Polygons temp;
    states = new Polygons[NUMBER_OF_STATES];
    colors = new color[NUMBER_OF_STATES];
    int i = 0; 
    Iterator iter = stateColors.entrySet().iterator();
    color c; 
    String name;
    while (iter.hasNext()) {
      Map.Entry state = (Map.Entry)iter.next();
      name = (String)state.getKey();
      c = (Integer)state.getValue();
      temp = new Polygons(boundary, 
                 allStates.getMultipleFeaturesById("NAME", name));
      states[i] = temp;
      colors[i] = c; 
      i++;
    }

    idToDistrict = new Polygons[3605];
    nameToDistrict = new HashMap(distNames.size());
    iter = distNames.entrySet().iterator();
    while (iter.hasNext()) {
      Map.Entry district = (Map.Entry)iter.next();
      District d = (District)district.getValue();
      i = d.ID;
      name = (String)district.getKey();
      temp = new Polygons(boundary, districts.getMultipleFeaturesById("NAME", name));
      idToDistrict[i] = temp;
    }

    selectedDistricts = new ArrayList();
  }

  public void updateSelectedDistricts(ArrayList d) {
    selectedDistricts = d;
  }

  public void draw() {
    Polygons temp;
    stroke(50);
    for (int i = 0; i < states.length; i++) {
      fill(colors[i]);
      temp = states[i];
      temp.project(app);
    }

    strokeWeight(.25);
    fill(color(0, 43, 54));
    stroke(200);
    for (int i = 0; i < selectedDistricts.size(); i++) {
      temp = idToDistrict[(Integer)selectedDistricts.get(i)];
      temp.project(app);
    }
    noFill();
    stroke(0);
    strokeWeight(1);

    currentMap = get(765, 110, 495, 585);
  }

  public void drawImage() {
    image(currentMap, 765, 110);
  }

}

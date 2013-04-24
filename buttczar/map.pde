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
  PApplet app; 
  PImage currentMap; 
  final int NUMBER_OF_STATES = 35;

  public IndiaMap(HashMap<String, Integer> _colors, PApplet a) {
    stateColors = _colors;
    app = a; 
    boundary = new BoundingBox(48, 105, -2, 15); 
    boundary = new BoundingBox(44, 101, 2, 19); 
    allStates   = new Polygons(boundary, dataPath("shapes/states.shp"));
    allStates.setLocalSimplificationThreshold(.01);
    districts = new Polygons(boundary, dataPath("shapes/districts.shp"));
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
                 allStates.getMultipleFeaturesById( "NAME", name));
      states[i] = temp;
      colors[i] = c; 
      i++;
    }
  }

  public void updateSelectedDistricts(ArrayList d) {
    selectedDistricts = d;
  }

  public void draw() {
    Polygons temp;
    //allStates.project(app);

    for (int i = 0; i < states.length; i++) {
      fill(colors[i]);
      temp = states[i];
      temp.project(app);
    }

    //districts.project(app);
    if (selectedDistricts.size() != 0) {
      fill(0, 43, 54, 250); 
      for (int i = 0; i < selectedDistricts.size(); i++) {
        temp = districtsToHighlight.get((Integer)selectedDistricts.get(i));
        temp.project(app);
      }
      noFill();
    }
    
  }

}

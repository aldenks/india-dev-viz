import com.reades.mapthing.*;
import net.divbyzero.gpx.*;
import net.divbyzero.gpx.parser.*;

class IndiaMap {
  color[] stateColors;
  HashMap<Integer, Polygons> districtsToHighlight;
  ArrayList selectedDistricts;
  int x,y,w,h;
  BoundingBox boundary;
  Polygons states;
  Polygons districts;
  PApplet app; 

  public IndiaMap(color[] _stateColors, PApplet a) {
    stateColors = _stateColors;
    boundary = new BoundingBox(48, 105, -2, 15); 
    boundary = new BoundingBox(44, 101, 2, 19); 
    states   = new Polygons(boundary, dataPath("shapes/states.shp"));
    states.setLocalSimplificationThreshold(.01);
    districts = new Polygons(boundary, dataPath("shapes/districts.shp"));
    app = a; 
  }

  public void updateSelectedDistricts(ArrayList d) {
    selectedDistricts = d;
  }

  public void draw() {
    states.project(app);
    //districts.project(app);
    districtsToHighlight = districts.getPolygonsWithId("DISTRICT_I");
    if (selectedDistricts.size() != 0) {
      Polygons temp;
      fill(0, 100, 0);
      for (int i = 0; i < selectedDistricts.size(); i++) {
        temp = districtsToHighlight.get((Integer)selectedDistricts.get(i));
        temp.project(app);
      }
      noFill();
    }
    
  }

}

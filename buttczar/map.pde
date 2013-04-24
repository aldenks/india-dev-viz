import com.reades.mapthing.*;
import net.divbyzero.gpx.*;
import net.divbyzero.gpx.parser.*;

class IndiaMap {
  PGraphics canvas;
  //HashMap<Integer, Object> stateColors;
  HashMap<Integer, Polygons> districtsToHighlight;
  ArrayList selectedDistricts;
  int x,y,w,h;
  BoundingBox boundary;
  Polygons states;
  Polygons districts;
  PApplet app; 

  public IndiaMap(/*HashMap<Integer, Object> _stateColors,*/ int _x, int _y,
                                                  int _w, int _h, PApplet a) {
    //stateColors = _stateColors;
    x = _x; y = _y; h = _h; w = _w;
    canvas = createGraphics(w, h);
    boundary = new BoundingBox(36, 97, 6, 68); 
    boundary = new BoundingBox(48, 105, -2, 15); 
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

import com.reades.mapthing.*;
import net.divbyzero.gpx.*;
import net.divbyzero.gpx.parser.*;

class IndiaMap {
  PGraphics canvas;
  //HashMap<Integer, Object> stateColors;
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
    states   = new Polygons(boundary, dataPath("shapes/states.shp"));
    districts = new Polygons(boundary, dataPath("shapes/districts.shp"));
    app = a; 
  }

  public void draw() {
    states.project(app);
    districts.project(app);
  }

}

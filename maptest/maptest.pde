import com.reades.mapthing.*;
import net.divbyzero.gpx.*;
import net.divbyzero.gpx.parser.*;

BoundingBox boundary;
Polygons india;
Polygons world;
Polygons d;
Polygons s;
Polygons indiasimp;
Points stateCentroids; 
HashMap<Integer, Polygons> test;
Polygons jharkhand; 
void setup() {
  size(500,500);
  boundary = new BoundingBox(36, 97, 6, 68); 
  smooth();
  world = new Polygons(boundary, dataPath("shapes/world.shp"));
  india   = new Polygons(boundary, dataPath("shapes/states.shp"));
  d = new Polygons(boundary, dataPath("shapes/districts.shp"));
  s = new Polygons(boundary, dataPath("shapes/subdistricts.shp"));
  indiasimp = new Polygons(boundary, dataPath("shapes/states.shp"));
  indiasimp.setLocalSimplificationThreshold(1000);
  Polygons tmp = new Polygons(boundary, indiasimp.getMultipleFeaturesByValue("TOT_POP", 20000000));
  stateCentroids = new Points(boundary, tmp.getCentroids());
  stateCentroids.setLabelField("NAME");
  india.setValueField("TOT_POP");
  india.setColourScale(color(83,27,94),color(71,58,42),15);
  
  
  test = d.getPolygonsWithId("DISTRICT_I");
  jharkhand = test.get(20);
  
  println("---------------");
  println("---------------");
  println("---------------");
  println("---------------");
  //org.geotools.feature.collection.DelegateSimpleFeatureIterator iterator = india.getFeatures();
  print(india.getFeatures());
}

void draw() {
  textAlign(CENTER);
  fill(255);
  //world.project(this);
  india.projectValues(this,5000f,17000000f);
  fill(0, 0, 100);
  //stateCentroids.label(this);
  fill(0);
  jharkhand.project(this);
  //s.project(this);
  
}

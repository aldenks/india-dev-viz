import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.util.Iterator; 
import java.util.Map; 
import controlP5.*; 
import java.text.DecimalFormat; 
import java.util.Arrays; 
import com.reades.mapthing.*; 
import net.divbyzero.gpx.*; 
import net.divbyzero.gpx.parser.*; 
import java.util.Iterator; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class buttczar extends PApplet {



final String INPUT_FILENAME = "data/districtsRatioVariables.csv";
final String STATE_FILENAME = "data/states.csv";
VizController vController;
ControlP5 cp5;

public void setup() {
  smooth();
  size(1300, 800);
  cp5 = new ControlP5(this);
  vController = new VizController(INPUT_FILENAME, STATE_FILENAME, cp5, this);
}

public void draw() {
  background(255);
  vController.draw();
}

public void mousePressed() { vController.mousePressed(); }
public void mouseClicked() { vController.mouseClicked(); }

// ControlP5 event handler, delegates events to interested objects
public void controlEvent(ControlEvent e) {
  if (e.isGroup()) {
    vController.controlEvent(e);
  }
  else if (e.isController()) {
  }
}
class District {
  public String name;
  public String state;
  int ID;
  String data[];
  HashMap<String, Integer> variables;

  public District (HashMap _variables, String _data[], 
                   String _name, String _state) 
  {
    data = _data;
    variables = _variables;
    name = _name;
    state = _state;
    ID = PApplet.parseInt(data[data.length-1]);
  }

  public float getVariable(String variable) {
    if (!variables.containsKey(variable)) {
      throw new IllegalArgumentException("Invalid Variable: " + variable);
    }
    else {
      int i = variables.get(variable);
      return PApplet.parseFloat(data[variables.get(variable)]);
    }
  }
}



class DistrictCollection {

  HashMap<String, Integer> varNameToIndex;
  HashMap<String, District> districts;
  HashMap<String, Integer> stateNameToID;
  String indexToVarName[];
  String values[][];
  public final String variableNames[] = {"Opencast Coal Output",
    "Below Ground Coal Output", "Total Area", "Total Population",
    "Male Population", "Female Population", "Total Literates",
    "Male Literates", "Female Literates", "Total Workers", "Male Workers",
    "Female Workers", "Total Cultivators", "Total Agricultural Laborers",
    "Total Non-workers", "Rural Total Population", "Rural Total Literates",
    "Urban Total Population", "Urban Total Literates"};
  public final String stateNames[] = { "Jammu & Kashmir", "Himachal Pradesh",
    "Punjab", "Uttranchal", "Haryana", "Chandigarh", "Uttar Pradesh",
    "Rajasthan", "Arunachal Pradesh", "Delhi", "Sikkim", "Assam", "Bihar",
    "West Bengal", "Nagaland", "Madhya Pradesh", "Meghalaya", "Manipur",
    "Jharkhand", "Gujarat", "Tripura", "Mizoram", "Chhattisgarh", "Orissa",
    "Maharashtra", "Daman & Diu", "Dadra & Nagar Haveli", "Andhra Pradesh",
    "Karnataka", "Pondicherry", "Goa", "Andaman & Nicobar", "Tamil Nadu",
    "Kerala", "Lakshadweep" };

  public DistrictCollection(String data_filename, String states_filename) {
    districts = new HashMap(650);
    stateNameToID = new HashMap(36);
    String name;
    String lines[] = loadStrings(data_filename);
    values  = new String[lines.length-1][];
    for (int i = 0; i < lines.length; i++) {
      if (i == 0) {
        indexToVarName = split(lines[i], ',');
        indexToVarName = subset(indexToVarName, 2);
        varNameToIndex = new HashMap<String,Integer>
          (indexToVarName.length);
        for (int v = 0; v < indexToVarName.length; v++) {
          varNameToIndex.put(indexToVarName[v], v);
        }
      }
      else {
        values[i-1] = split(lines[i], ',');
      }
    }


    for (int i = 0; i < values.length; i++) {
      name = values[i][0];
      if (!districts.containsKey(name)) {
        District d = new District(varNameToIndex, subset(values[i], 2),
                                  values[i][0], values[i][1]);
        districts.put(name, d);
      }
    }
    lines = loadStrings(states_filename);
    for (int i = 1; i < lines.length; i++) {
      int ID       = PApplet.parseInt(split(lines[i],',')[0]);
      String state = split(lines[i],',')[1];
      stateNameToID.put(state,ID);
    }
  }

  public District getDistrict(String name) {
    return districts.get(name);
  }

  public float getValueForDistrict(String districtName, String variable) {
    return (districts.get(districtName)).getVariable(variable);
  }

  // returns 3 x numDists 2D array, 1 row for names, 1 for var1, 1 for var2, state
  public String[][] getColumns(int var1, int var2) {
    String columns[][] = new String[4][districts.size()+1];
    columns[0][0] = "Name";
    columns[1][0] = indexToVarName[var1];
    columns[2][0] = indexToVarName[var2];
    columns[3][0] = "State";
    Iterator iter = districts.entrySet().iterator();
    int i = 1;
    while (iter.hasNext()) {
      Map.Entry x = (Map.Entry)iter.next();
      columns[0][i] = (String)x.getKey();
      District d = (District)x.getValue();
      columns[1][i] = d.data[var1];
      columns[2][i] = d.data[var2];
      columns[3][i] = d.state;
      i++;
    }
    return columns;
  }

  // overloaded version of previous function to handle 3 dimensions
  public String[][] getColumns(int var1, int var2, int var3) {
    String columns[][] = new String[5][districts.size()+1];
    columns[0][0] = "Name";
    columns[1][0] = indexToVarName[var1];
    columns[2][0] = indexToVarName[var2];
    columns[3][0] = indexToVarName[var3];
    columns[4][0] = "State";
    Iterator iter = districts.entrySet().iterator();
    int i = 1;
    while (iter.hasNext()) {
      Map.Entry x = (Map.Entry)iter.next();
      columns[0][i] = (String)x.getKey();
      District d = (District)x.getValue();
      columns[1][i] = d.data[var1];
      columns[2][i] = d.data[var2];
      columns[3][i] = d.data[var3];
      columns[4][i] = d.state;
      i++;
    }
    return columns;
  }

  public String[][] getColumnsForState(int var1, int var2, String state) {
    String columns[][] = new String[4][districts.size() + 1];
    columns[0][0] = "Name";
    columns[1][0] = indexToVarName[var1];
    columns[2][0] = indexToVarName[var2];
    columns[3][0] = "State";
    Iterator iter = districts.entrySet().iterator();
    int i = 1;
    while (iter.hasNext()) {
      Map.Entry x = (Map.Entry)iter.next();
      District d = (District)x.getValue();
      if (state.equals(d.state)) {
        columns[0][i] = (String)x.getKey();
        columns[1][i] = d.data[var1];
        columns[2][i] = d.data[var2];
        columns[3][i] = d.state;
        i++;
      }
    }
    columns[0] = subset(columns[0], 0, i);
    columns[1] = subset(columns[1], 0, i);
    columns[2] = subset(columns[2], 0, i);
    columns[3] = subset(columns[3], 0, i);
    return columns;
  }

  public String[][] getColumnsForState(int var1, int var2,
                                       int var3, String state,
                                       boolean filter_coal)
  {
    int num_districts = districts.size();
    if(filter_coal){
      Iterator iter = districts.entrySet().iterator();
      while(iter.hasNext()){
        Map.Entry x = (Map.Entry)iter.next();
        District d = (District)x.getValue();
        if(PApplet.parseFloat(d.data[0]) == 0 && PApplet.parseFloat(d.data[1]) == 0){
          num_districts--;
        }
      }
    }
    String columns[][] = new String[5][num_districts + 1];
    columns[0][0] = "Name";
    columns[1][0] = indexToVarName[var1];
    columns[2][0] = indexToVarName[var2];
    columns[3][0] = indexToVarName[var3];
    columns[4][0] = "State";
    Iterator iter = districts.entrySet().iterator();
    int i = 1;
    boolean all_states = state.equals("All States");
    while (iter.hasNext()) {
      Map.Entry x = (Map.Entry)iter.next();
      District d = (District)x.getValue();
      if (all_states || state.equals(d.state)) {
        if(!filter_coal || (PApplet.parseFloat(d.data[0]) != 0 || PApplet.parseFloat(d.data[1]) != 0)){
          columns[0][i] = (String)x.getKey();
          columns[1][i] = d.data[var1];
          columns[2][i] = d.data[var2];
          columns[3][i] = d.data[var3];
          columns[4][i] = d.state;
          i++;
        }
      }
    }
    columns[0] = subset(columns[0], 0, i);
    columns[1] = subset(columns[1], 0, i);
    columns[2] = subset(columns[2], 0, i);
    columns[3] = subset(columns[3], 0, i);
    columns[4] = subset(columns[4], 0, i);
    return columns;
  }

  public ArrayList getIDsFromNames(ArrayList names) {
    ArrayList IDs = new ArrayList();
    String name = "";
    for (int i = 0; i < names.size(); i++) {
        name = (String)names.get(i);
        IDs.add(districts.get(name).ID);
    }
    return IDs;
  }

  public HashMap<String, Integer> getStateToID(){
    return stateNameToID;
  }

  public int getStateIDFromName(String name) {
    return (int)(stateNameToID.get(name));
  }

}
/*
 * Controls and draws centered dropdown select boxes
 *
 * Methods
 *    // draws self within given dimensions
 *    void draw(float x, float y, float w, float h)
 *    // returns the selected column index for each dimension
 *    int selectedXIndex()
 *    int selectedYIndex()
 *    int selectedZIndex()
 *    int selectedStateIndex()
 */


class DropdownSelectGroup {
    int selected_x_idx, selected_y_idx, selected_z_idx, selected_state_idx;
    DropdownList ddx, ddy, ddz, dds; // DropDowns for X, Y, Z, and State
    String[] state_names;
    PImage circles_label_img;

    final float TOTAL_WIDTH;
    static final int SINGLE_SELECT_WIDTH = 170;
    static final int LABEL_WIDTH = 32;
    static final int ITEM_HEIGHT = 20;
    static final int PADDING = 20;
    static final int LABEL_NUDGE = 3;
    private boolean first_run = true;
    Button helpButton;

    public DropdownSelectGroup(ControlP5 cp5, String[] column_names,
                               String[] _state_names) {
        String[] _all = { "All States" };
        state_names = concat(_all, _state_names);
        ddx = cp5.addDropdownList("X");
        ddy = cp5.addDropdownList("Y");
        ddz = cp5.addDropdownList("Z");
        dds = cp5.addDropdownList("State");
        DropdownList[] ddls = new DropdownList[] { ddx, ddy, ddz };

        for (DropdownList d : ddls) {
            for (int i = 0; i < column_names.length; i++) {
                d.addItem(column_names[i], i);
            }
            customizeDropdown(d);
        }
        for (int i = 0; i < state_names.length; i++) {
            dds.addItem(state_names[i], i);
        }
        customizeDropdown(dds);
        TOTAL_WIDTH = 4*SINGLE_SELECT_WIDTH + 4*LABEL_WIDTH + 3*PADDING;
        circles_label_img = loadImage("../img/concentric_circles.png");

        helpButton = new Button(cp5, "Help");
        helpButton.setSwitch(true);
    }

    public void draw(float x, float y, float w, float h) {
        if (first_run) {
            ddx.setIndex(0); ddy.setIndex(1); ddz.setIndex(2); dds.setIndex(0);
            first_run = false;
        }
        pushStyle();
        float y_center = y + (h/2);
        float dd_y_pos = y_center + (PApplet.parseFloat(ITEM_HEIGHT)/2);
        float x_begin = (PApplet.parseFloat(width)/2) - (TOTAL_WIDTH/2);
        float dd_begin = x_begin + LABEL_WIDTH;
        x_begin = x_begin < 0 ? 0 : x_begin;
        int item_width = SINGLE_SELECT_WIDTH + PADDING + LABEL_WIDTH;
        dds.setPosition(dd_begin + 0*item_width, dd_y_pos);
        ddx.setPosition(dd_begin + 1*item_width, dd_y_pos);
        ddy.setPosition(dd_begin + 2*item_width, dd_y_pos);
        ddz.setPosition(dd_begin + 3*item_width, dd_y_pos);
        textAlign(RIGHT, CENTER);
        textSize(18);
        text("X: ", dd_begin + 1*item_width,     y_center - LABEL_NUDGE);
        text("Y: ", dd_begin + 2*item_width,     y_center - LABEL_NUDGE);
        text(  ":", dd_begin + 3*item_width - 2, y_center - LABEL_NUDGE);
        image(circles_label_img, x_begin + 3*item_width,
              y_center - PApplet.parseFloat(circles_label_img.height)/2);
        popStyle();

        helpButton.setHeight(ITEM_HEIGHT);
        helpButton.setPosition(dd_begin + 4*item_width, dd_y_pos - ITEM_HEIGHT);
        if(helpButton.isPressed()){
          helpButton.setOn();
        }

        if(helpButton.isOn()){
          drawHelpButton(dd_begin+4*item_width, y_center + 40);
        }
    }

    public int selectedXIndex() { return selected_x_idx; }
    public int selectedYIndex() { return selected_y_idx; }
    public int selectedZIndex() { return selected_z_idx; }
    public String selectedStateName() { return state_names[selected_state_idx]; }

    public void controlEvent(ControlEvent e) {
        ControlGroup g = e.getGroup();
        if (g == ddx) {
            selected_x_idx = PApplet.parseInt(e.getGroup().getValue());
        } else if (g == ddy) {
            selected_y_idx = PApplet.parseInt(e.getGroup().getValue());
        } else if (g == ddz) {
            selected_z_idx = PApplet.parseInt(e.getGroup().getValue());
        } else if (g == dds) {
            selected_state_idx = PApplet.parseInt(e.getGroup().getValue());
        }
    }

    public void customizeDropdown(DropdownList d) {
        d.setSize(SINGLE_SELECT_WIDTH, 27*ITEM_HEIGHT)
            .setBarHeight(ITEM_HEIGHT)
            .setItemHeight(ITEM_HEIGHT)
            .toUpperCase(false);
        d.captionLabel().style().marginTop = 2;
    }

    // x y for where to draw helpbutton
    public void drawHelpButton(float x, float y){
      String[] help = new String[5];
      help[0] = "Click and drag to select districts (data points).";
      help[1] = "Selected districts will appear on map.";
      help[2] = "Click again to deselect districts.";
      help[3] = "Select variables to view in dropdowns.";
      help[4] = " ";
      float rect_width = textWidth(help[0]);
      float line_height = 15;
      float x_padding = 10;
      float y_padding = 5;
      fill(0xff002b36);
      rect(x - rect_width/2,y,rect_width+2*x_padding,
          line_height*5 + 2*y_padding);
      textAlign(LEFT,BOTTOM);
      fill(0xffFFFFFF);
      text(help[0], x+x_padding - rect_width/2, y + line_height + y_padding);
      text(help[1], x+x_padding - rect_width/2, y + line_height*2 + y_padding);
      text(help[2], x+x_padding - rect_width/2, y + line_height*3 + y_padding);
      text(help[3], x+x_padding - rect_width/2, y + line_height*4 + y_padding);
      text(help[4], x+x_padding - rect_width/2, y + line_height*5 + y_padding);
    }
}



class Graph {
  float[] xs, ys, zs;
  float[] xlocs, ylocs, zrad;
  String lx, ly, lz;
  String[] names;
  String[] districtNames;
  float xmax, ymax, zmax;
  float axis_w;
  float x,y,h,w;
  float plotx, ploty, ploth, plotw;
  float max_radius, min_radius;
  DecimalFormat formatter;

  ArrayList selected_districts;
  float drag_start_x, drag_start_y;

  HashMap<String, Integer> stateColors;

  //take in 2d string array

  public Graph(float _x, float _y, float _w, float _h,
      HashMap<String, Integer> _stateColors ) {
    stateColors = _stateColors;
    axis_w = 70;
    max_radius = 25;
    min_radius = 5;
    x = _x; y = _y; h = _h; w = _w;
    plotx = x+axis_w; ploty = y;
    ploth = h-axis_w; plotw = w-axis_w;
    selected_districts = new ArrayList();
    formatter = new DecimalFormat("#,##0.0");
  }

  public void draw() {
    // axis lines
    line(plotx,ploty,plotx,ploty+ploth);
    line(plotx,ploty+ploth,plotx+plotw, ploty+ploth);

    // axis labels
    fill(color(0,0,0));
    textAlign(CENTER, BASELINE);
    text(lx, x+(plotw/2.0f)+axis_w, y+ploth+axis_w-6);
    textAlign(CENTER, CENTER);

    pushMatrix();
    translate(x,y+(ploth/2.0f));
    rotate(-HALF_PI);
    text(ly, x-50, y - axis_w-40);
    popMatrix();

    // y value labels
    int num_y_labels = 5;
    float v = ((float)ymax)/num_y_labels;
    float y_label_dist = ((float)ploth)/num_y_labels;
    float y_loc = y + ploth;
    textAlign(CENTER, CENTER);
    for (int i = 0; i <= num_y_labels; i++) {
       text(formatter.format(i*v), x+(axis_w/5.0f), y_loc);
       y_loc -= y_label_dist;
    }
    // x value labels
    float x_label_dist = ((float)plotw)/num_y_labels;
    float u = ((float)xmax)/num_y_labels;
    float x_loc = plotx;
    for (int i = 0; i <= num_y_labels; i++) {
       text(formatter.format(i*u), x_loc, ploty+ploth+(axis_w/2.0f));
       x_loc += x_label_dist;
    }

    // CIRCLES
    noFill();
    xlocs = xLocations();
    ylocs = yLocations();
    zrad = zradii();
    ellipseMode(RADIUS);
    float dist = 0;
    float smallestDist = Float.MAX_VALUE;
    int intersectionID = -1;
    if (mousePressed) {
      selected_districts.clear();
      stroke(0, 43, 54, 100);
      strokeWeight(1);
      fill(0, 43, 54, 20);
      rect(drag_start_x,drag_start_y,mouseX - drag_start_x,
          mouseY - drag_start_y);
    }
    strokeWeight(2);
    stroke(0, 0, 0, 150);
    noFill();
    xlocs = xLocations();
    for (int i = 0; i < xlocs.length; i++) {
      String state_name = split(names[i],", ")[1];
      int state_color = (Integer)stateColors.get(state_name);
      //println(state_name);
      strokeWeight(2);
      fill(state_color);
      int alpha_color = color(state_color,255);
      stroke(alpha_color);

      ellipse(xlocs[i], ylocs[i], zrad[i], zrad[i]);
      dist = intersectionDist(i);
      if (dist < smallestDist) {
        smallestDist = dist;
        intersectionID = i;
      }
      if (mousePressed && inRect(xlocs[i], ylocs[i],
                          drag_start_x, drag_start_y, mouseX, mouseY)) {
        selected_districts.add(districtNames[i]);
      }
    }

    if (intersectionID != -1) {
      drawToolTip(intersectionID);
    }

    // show scale of circles
    stroke(100,0,0);
    fill(0,0,0);
    text("Scale:", x+plotw+100, y - max_radius+5);
    if (zmax == 0) {
      text(formatter.format(zmax*.2f) + " = ", x+plotw+100, y-max_radius+25);
      noFill();
      ellipse(x+plotw+130, y-max_radius+25, min_radius, min_radius);
    }
    else {
      text(formatter.format(zmax*.8f) + " = ", x+plotw+100, y-max_radius+25);
      text(formatter.format(zmax*.2f) + " = ", x+plotw+100, y-max_radius+70);
      noFill();
      ellipse(x+plotw+165, y-max_radius+25, sqrt(sq(max_radius)*.8f),
                            sqrt(sq(max_radius)*.8f));
      ellipse(x+plotw+165, y-max_radius+70, sqrt(sq(max_radius)*.2f),
                            sqrt(sq(max_radius)*.2f));
    }
    strokeWeight(1);
    stroke(0);
  }

  public float intersectionDist(int i) {
    float dist = sqrt(abs((mouseX - xlocs[i]) * (mouseX - xlocs[i])) +
                     abs((mouseY - ylocs[i]) * (mouseY - ylocs[i])));
    if (dist < zrad[i]) {
      return dist;
    }
    else {
      return Float.MAX_VALUE;
    }
  }

  public void drawToolTip(int index) {
    float xPadding = 5;
    float strLen   = textWidth(names[index]);
    String xName   = lx + " : " + formatter.format(xs[index]);
    String yName   = ly + " : " + formatter.format(ys[index]);
    String zName   = lz + " : " + formatter.format(zs[index]);
    float[] allLengths = new float[4];
    allLengths[0]      = strLen;
    allLengths[1]      = textWidth(xName);
    allLengths[2]      = textWidth(yName);
    allLengths[3]      = textWidth(zName);
    Arrays.sort(allLengths);
    strLen = allLengths[3];
    fill(0xff002b36);
    if (mouseY < y+30) {
      float addX = 10;
      rect(mouseX + addX, mouseY, strLen + 2*xPadding, (15)*4);
      textAlign(LEFT,BOTTOM);
      fill(0xffFFFFFF);
      text(names[index],mouseX + xPadding + addX,mouseY + 15);
      text(xName, mouseX + xPadding + addX,mouseY + 15*2);
      text(yName, mouseX + xPadding + addX,mouseY + 15*3);
      text(zName, mouseX + xPadding + addX,mouseY+ 15*4);
    }
    else {
      rect(mouseX, mouseY, strLen + 2*xPadding, (-15)*4);
      textAlign(LEFT,BOTTOM);
      fill(0xffFFFFFF);
      text(names[index],mouseX + xPadding,mouseY - 15*3);
      text(xName, mouseX + xPadding,mouseY - 15*2);
      text(yName, mouseX + xPadding,mouseY - 15);
      text(zName, mouseX + xPadding,mouseY);
    }
    textAlign(CENTER,CENTER); //KEEP THIS HERE
    noFill();
  }


  public void setVariables (String[][] data) {
    xs    = new float [data[1].length-1];
    ys    = new float [data[1].length-1];
    zs    = new float [data[1].length-1];
    xlocs = new float [data[1].length-1];
    ylocs = new float [data[1].length-1];
    zrad  = new float [data[1].length-1];
    names = new String [data[1].length-1];
    districtNames = new String [data[1].length-1];
    for (int i=0; i<data[1].length-1; i++) {
      xs[i]    = PApplet.parseFloat(data[1][1+i]);
      ys[i]    = PApplet.parseFloat(data[2][1+i]);
      zs[i]    = PApplet.parseFloat(data[3][1+i]);
      names[i] = data[0][1+i] + ", " + data[4][1+i];
      districtNames[i] = data[0][1+i];
    }
    lx = data[1][0]; ly = data[2][0]; lz = data[3][0];
    xmax = 0; ymax = 0; zmax = 0;
    for (int i = 0; i < xs.length; i++) {
      if (xs[i] > xmax) xmax = xs[i];
      if (ys[i] > ymax) ymax = ys[i];
      if (zs[i] > zmax) zmax = zs[i];
    }
  }

  public void setWidthHeight(float _w, float _h) {
    h = _h; w = _w;
    ploth = h-axis_w; plotw = w-axis_w;
  }

  public float[] xLocations() {
    float[] locs = new float[xs.length];
    float yaxis = plotx;
    for (int i = 0; i < locs.length; i++) {
      locs[i] = yaxis + (plotw*(xs[i]/xmax));
      if (xmax == 0) locs[i] = yaxis;
    }
    return locs;
  }

  public float[] yLocations() {
    float[] locs = new float[ys.length];
    float xaxis = y + ploth;
    for (int i = 0; i < locs.length; i++) {
      locs[i] = xaxis - (ploth*(ys[i]/ymax));
      if (ymax == 0) locs[i] = xaxis;
    }
    return locs;
  }

  public float[] zradii() {
    float[] radii = new float[zs.length];
    for (int i = 0; i < radii.length; i++) {
      radii[i] = sqrt(sq(max_radius)*(zs[i]/zmax));
      if (radii[i] < min_radius || zmax == 0) {
        radii[i] = min_radius;
      }
    }
    return radii;
  }

  public void mousePressed() {
    drag_start_x = mouseX;
    drag_start_y = mouseY;
  }
  public void mouseClicked() {
    selected_districts.clear();
  }

  // returns true if the point (pt_*) is in the rectangle
  // rectangle points 1 and 2 can be anywhere relative to each other
  public boolean inRect(float pt_x, float pt_y,
                 float x1, float y1, float x2, float y2) {
    boolean x_in_bounds, y_in_bounds;
    x_in_bounds = y_in_bounds = false;
    if (x1 < x2) {
      x_in_bounds = x1 < pt_x && pt_x < x2;
    } else {
      x_in_bounds = x2 < pt_x && pt_x < x1;
    }
    if (y1 < y2) {
      y_in_bounds = y1 < pt_y && pt_y < y2;
    } else {
      y_in_bounds = y2 < pt_y && pt_y < y1;
    }
    return x_in_bounds && y_in_bounds;
  }

  public ArrayList getSelectedDistrictNames() {
    return selected_districts;
  }
}





class IndiaMap {
  HashMap<String, Integer> stateColors;
  HashMap<Integer, Polygons> districtsToHighlight;
  Polygons[] states;
  int[] colors; 
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
    allStates.setLocalSimplificationThreshold(.01f);
    districts = new Polygons(boundary, dataPath("shapes/districts.shp"));
    districts.setLocalSimplificationThreshold(0.1f);
    districtsToHighlight = districts.getPolygonsWithId("DISTRICT_I");

    Polygons temp;
    states = new Polygons[NUMBER_OF_STATES];
    colors = new int[NUMBER_OF_STATES];
    int i = 0; 
    Iterator iter = stateColors.entrySet().iterator();
    int c; 
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
    //allStates.project(app);

    for (int i = 0; i < states.length; i++) {
      fill(colors[i]);
      temp = states[i];
      temp.project(app);
    }

    //districts.project(app);
    /*if (selectedDistricts.size() != 0) {
      fill(0, 43, 54, 250); 
      for (int i = 0; i < selectedDistricts.size(); i++) {
        temp = districtsToHighlight.get((Integer)selectedDistricts.get(i));
        temp.project(app);
      }
      noFill();
    }*/

    fill(color(0, 43, 54));
    for (int i = 0; i < selectedDistricts.size(); i++) {
      temp = idToDistrict[(Integer)selectedDistricts.get(i)];
      temp.project(app);
    }
    noFill();


    currentMap = get(765, 110, 495, 585);
  }

  public void drawImage() {
    image(currentMap, 765, 110);
  }

}


class VizController {
  final int GRAPH_X = 50;
  final int GRAPH_Y = 75;
  final int GRAPH_W = 650;
  final int GRAPH_H = 650;

  DistrictCollection districts;
  Graph graph;
  ControlP5 cp5;
  DropdownSelectGroup dropdowns;
  IndiaMap map;
  int prev_x_col_idx, prev_y_col_idx, prev_z_col_idx;
  ArrayList old_selected_districts;
  ArrayList new_selected_districts;
  String prev_state;
  HashMap<String, Integer> stateColors;

  // constants
  final float SELECTION_GUI_HEIGHT = 50;

  public VizController(String filename, String state_filename, ControlP5 _cp5, PApplet a){
    cp5 = _cp5;
    PFont pfont = createFont("Arial", 12);
    textFont(pfont);
    ControlFont cp5font = new ControlFont(pfont);
    cp5.setControlFont(cp5font);

    districts = new DistrictCollection(filename, state_filename);
    dropdowns = new DropdownSelectGroup(cp5, districts.variableNames,
                                             districts.stateNames);
    initColors();
    graph = new Graph(GRAPH_X,GRAPH_Y,GRAPH_W,GRAPH_H, stateColors);
    map = new IndiaMap(stateColors, a, districts.districts);
    old_selected_districts = new ArrayList();
    new_selected_districts = new ArrayList();
    map.draw();
  }

  public void draw() {
    int x_column_idx      = dropdowns.selectedXIndex();
    int y_column_idx      = dropdowns.selectedYIndex();
    int z_column_idx      = dropdowns.selectedZIndex();
    String selected_state = dropdowns.selectedStateName();

    if(x_column_idx != prev_x_col_idx || y_column_idx != prev_y_col_idx ||
       z_column_idx != prev_z_col_idx || prev_state != selected_state){
      String[][] selectedData = districts.getColumnsForState(x_column_idx,
          y_column_idx, z_column_idx, selected_state, true);
      //TODO add actual coal filter to last boolean
      graph.setVariables(selectedData);
    }
    graph.draw();
    // getSelectedDistrictNames() must be called after graph.draw()

    dropdowns.draw(0, 10, width, SELECTION_GUI_HEIGHT);

    new_selected_districts = graph.getSelectedDistrictNames();
    if (old_selected_districts.equals(new_selected_districts)) {
      map.updateSelectedDistricts(districts.getIDsFromNames(new_selected_districts));
      map.draw();
    }
    else {
      map.drawImage();
    }

    old_selected_districts.clear();
    for (int i = 0; i < new_selected_districts.size(); i++) {
      old_selected_districts.add(new_selected_districts.get(i));
    }

    prev_x_col_idx = x_column_idx;
    prev_y_col_idx = y_column_idx;
    prev_z_col_idx = z_column_idx;
    prev_state     = selected_state;
  }

  public void mousePressed() { graph.mousePressed(); }
  public void mouseClicked() {
    if(mouseX > GRAPH_X && mouseX < GRAPH_X + GRAPH_W &&
        mouseY > GRAPH_Y && mouseY < GRAPH_Y + GRAPH_H){
      graph.mouseClicked();
    }
  }

  // ControlP5 event handler, delegates events to interested objects
  public void controlEvent(ControlEvent e) {
    dropdowns.controlEvent(e);
  }

  public void initColors() {
    int[] R = {176, 180, 123, 95, 16, 0, 60, 0, 0, 107, 128, 189,
               217, 255, 139, 153, 255, 255, 184, 255, 255, 250, 255,
               238, 255, 255, 178, 255, 205, 255, 208, 176, 128, 255, 153};
    int[] G = {226, 205, 104, 158, 78, 206, 190, 250, 128, 142, 128, 183,
               217, 236, 129, 204, 255, 215, 134, 165, 120, 128, 99,
               121, 69, 0, 34, 192, 104, 105, 32, 48, 0, 0, 50};
    int[] B = {255, 205, 238, 160, 139, 209, 113, 154, 0, 35, 0, 107,
               143, 139, 76, 50, 0, 0, 11, 0, 0, 114, 71,
               66, 0, 0, 34, 203, 137, 180, 144, 96, 128, 255, 204};

    stateColors = new HashMap(36);
    for (int i=0; i< R.length; i++){
      stateColors.put(districts.stateNames[i], color(R[i], G[i], B[i], 150));
    }
  }


}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "buttczar" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

import java.text.DecimalFormat;

class Graph {
  float[] xs, ys, zs;
  float[] xlocs, ylocs, zrad;
  String lx, ly;
  String[] names;
  float xmax, ymax, zmax;
  float axis_w;
  float x,y,h,w;
  float plotx, ploty, ploth, plotw;
  float max_radius, min_radius;

  ArrayList selected_districts;
  float drag_start_x, drag_start_y;

  //take in 2d string array

  public Graph(float _x, float _y, float _w, float _h) {
    axis_w = 70;
    max_radius = 25;
    min_radius = 5;
    x = _x; y = _y; h = _h; w = _w;
    plotx = x+axis_w; ploty = y;
    ploth = h-axis_w; plotw = w-axis_w;
    selected_districts = new ArrayList();
  }

  void draw() {
    // axis lines
    line(plotx,ploty,plotx,ploty+ploth);
    line(plotx,ploty+ploth,plotx+plotw, ploty+ploth);

    // axis labels
    fill(color(0,0,0));
    textAlign(CENTER, BASELINE);
    text(lx, x+(plotw/2.0)+axis_w, y+ploth+axis_w-6);
    textAlign(CENTER, CENTER);
    text(ly, x+10, y+(ploth/2.0));

    DecimalFormat formatter = new DecimalFormat("#,##0.0");
    // y value labels
    int num_y_labels = 5;
    float v = ((float)ymax)/num_y_labels;
    float y_label_dist = ((float)ploth)/num_y_labels;
    float y_loc = y + ploth;
    textAlign(CENTER, CENTER);
    for (int i = 0; i <= num_y_labels; i++) {
       text(formatter.format(i*v), x+(axis_w/5.0), y_loc);
       y_loc -= y_label_dist;
    }
    // x value labels
    float x_label_dist = ((float)plotw)/num_y_labels;
    float u = ((float)xmax)/num_y_labels;
    float x_loc = plotx;
    for (int i = 0; i <= num_y_labels; i++) {
       text(formatter.format(i*u), x_loc, ploty+ploth+(axis_w/2.0));
       x_loc += x_label_dist;
    }

    // CIRCLES
    noFill();
    strokeWeight(2);
    stroke(0, 0, 0, 150);
    xlocs = xLocations();
    ylocs = yLocations();
    zrad = zradii();
    ellipseMode(RADIUS);
    float dist = 0;
    float smallestDist = Float.MAX_VALUE;
    int intersectionID = -1;
    if (mousePressed) {
      selected_districts.clear();
      // TODO draw dragged over area rect
    }
    for (int i = 0; i < xlocs.length; i++) {
      ellipse(xlocs[i], ylocs[i], zrad[i], zrad[i]);
      dist = intersectionDist(i);
      if (dist < smallestDist) {
        smallestDist = dist;
        intersectionID = i;
      }
      if (mousePressed && inRect(xlocs[i], ylocs[i],
                          drag_start_x, drag_start_y, mouseX, mouseY)) {
        selected_districts.add(names[i]);
      }
    }

    if (intersectionID != -1) {
      drawToolTip(intersectionID);
    }

    // show scale of circles
    stroke(100,0,0);
    fill(0,0,0);
    text("Scale:", width-2*axis_w, y - max_radius+5);
    text(formatter.format(zmax*.8) + " = ", width-2*axis_w, y-max_radius+25);
    text(formatter.format(zmax*.2) + " = ", width-2*axis_w, y-max_radius+70);
//    ellipse(width-2*axis_w, y+25, sqrt(sq(max_radius)*(zmax / zmax)),
  //                      sqrt(sq(max_radius)*(zmax / zmax)));
    noFill();
    ellipse(width-2*axis_w+65, y-max_radius+25, sqrt(sq(max_radius)*.8),
                            sqrt(sq(max_radius)*.8));
    ellipse(width-2*axis_w+65, y-max_radius+70, sqrt(sq(max_radius)*.2),
                            sqrt(sq(max_radius)*.2));
    strokeWeight(1);
    stroke(0);
  }

  float intersectionDist(int i) {
    float dist = sqrt(abs((mouseX - xlocs[i]) * (mouseX - xlocs[i])) +
                     abs((mouseY - ylocs[i]) * (mouseY - ylocs[i])));
    if (dist < zrad[i]) {
      return dist;
    }
    else {
      return Float.MAX_VALUE;
    }
  }

  void drawToolTip(int index) {
    float xPadding = 5;
    float strLen = textWidth(names[index]);
    fill(#002b36);
    rect(mouseX, mouseY, strLen + 2*xPadding, -15);
    textAlign(LEFT,BOTTOM);
    fill(#93a1a1);
    text(names[index],mouseX + xPadding,mouseY);
    textAlign(CENTER,CENTER); //KEEP THIS HERE
    noFill();
  }


  void setVariables (String[][] data) {
    xs = new float [data[1].length-1];
    ys = new float [data[1].length-1];
    zs = new float [data[1].length-1];
    xlocs = new float [data[1].length-1];
    ylocs = new float [data[1].length-1];
    zrad = new float [data[1].length-1];
    names = new String [data[1].length-1];
    for (int i=0; i<data[1].length-1; i++) {
      xs[i] = float(data[1][1+i]);
      ys[i] = float(data[2][1+i]);
      zs[i] = float(data[3][1+i]);
      names[i] = data[0][1+i] + ", " + data[4][1+i];
    }
    lx = data[1][0]; ly = data[2][0];
    xmax = 0; ymax = 0; zmax = 0;
    for (int i = 0; i < xs.length; i++) {
      if (xs[i] > xmax) xmax = xs[i];
      if (ys[i] > ymax) ymax = ys[i];
      if (zs[i] > zmax) zmax = zs[i];
    }
  }

  void setWidthHeight(float _w, float _h) {
    h = _h; w = _w;
    ploth = h-axis_w; plotw = w-axis_w;
  }

  float[] xLocations() {
    float[] locs = new float[xs.length];
    float yaxis = plotx;
    for (int i = 0; i < locs.length; i++) {
      locs[i] = yaxis + (plotw*(xs[i]/xmax));
    }
    return locs;
  }

  float[] yLocations() {
    float[] locs = new float[ys.length];
    float xaxis = y + ploth;
    for (int i = 0; i < locs.length; i++) {
      locs[i] = xaxis - (ploth*(ys[i]/ymax));
    }
    return locs;
  }

  float[] zradii() {
    float[] radii = new float[zs.length];
    for (int i = 0; i < radii.length; i++) {
      radii[i] = sqrt(sq(max_radius)*(zs[i]/zmax));
      if (radii[i] < min_radius) {
        radii[i] = min_radius;
      }
    }
    return radii;
  }

  void mousePressed() {
    drag_start_x = mouseX;
    drag_start_y = mouseY;
  }
  void mouseClicked() {
    selected_districts.clear();
  }

  // returns true if the point (pt_*) is in the rectangle
  // rectangle points 1 and 2 can be anywhere relative to each other
  boolean inRect(float pt_x, float pt_y,
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

  ArrayList getSelectedDistrictNames() {
    return selected_districts;
  }
}

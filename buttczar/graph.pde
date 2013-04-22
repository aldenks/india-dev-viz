class Graph { 
  float[] xs, ys, zs;
  float[] xlocs, ylocs, zrad;
  String lx, ly;
  float xmax, ymax, zmax;
  float axis_w;
  float x,y,h,w;
  float plotx, ploty, ploth, plotw;
  float max_radius, min_radius;
  
  //take in 2d string array 
  
  public Graph(float _x, float _y, float _h, float _w) {
    axis_w = 70;
    max_radius = 25;
    min_radius = 5;
    x = _x; y = _y; h = _h; w = _w;
    plotx = x+axis_w; ploty = y;
    ploth = h-axis_w; plotw = w-axis_w;
  }
  
  void draw() {
    // axis lines
    line(plotx,ploty,plotx,ploty+ploth);
    line(plotx,ploty+ploth,plotx+plotw, ploty+ploth);
    
    // axis labels
    fill(color(0,0,0));
    textAlign(CENTER, BASELINE);
    text(lx, x+(plotw/2.0)+axis_w, y+ploth+axis_w-6);
    textAlign(LEFT, CENTER);
    text(ly, x+4, y+(ploth/2.0));
    
    // y value labels
    int num_y_labels = 5;
    float v = ((float)ymax)/num_y_labels;
    float y_label_dist = ((float)ploth)/num_y_labels;
    float y_loc = y + ploth;
    textAlign(CENTER, CENTER);
    for (int i = 0; i <= num_y_labels; i++) {
       text(i*v, x+(axis_w/2.0), y_loc);
       y_loc -= y_label_dist;
    }
    
    // x value labels
    float x_label_dist = ((float)plotw)/num_y_labels;
    float u = ((float)xmax)/num_y_labels;
    float x_loc = plotx; 
    for (int i = 0; i <= num_y_labels; i++) {
       text(i*u, x_loc, ploty+ploth+(axis_w/2.0));
       x_loc += x_label_dist;
    }
    
    // CIRCLES
    xlocs = xLocations();
    ylocs = yLocations();
    zrad = zradii();
    ellipseMode(RADIUS);
    for (int i = 0; i < xlocs.length; i++) {
      ellipse(xlocs[i], ylocs[i], zrad[i], zrad[i]);
    }
  }
  
  void setVariables (String[][] data) {
    xs = new float [data[1].length-1];
    ys = new float [data[1].length-1];
    zs = new float [data[1].length-1];
    xlocs = new float [data[1].length-1];
    ylocs = new float [data[1].length-1];
    zrad = new float [data[1].length-1];
    for (int i=0; i<data[1].length-1; i++) { 
      xs[i] = float(data[1][1+i]);
      ys[i] = float(data[2][1+i]);
      zs[i] = float(data[3][1+i]);
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
    float [] radii = new float[zs.length];    
    for (int i = 0; i < radii.length; i++) {
      radii[i] = sqrt(sq(max_radius)*(zs[i]/zmax));
      if (radii[i] < min_radius) {
        radii[i] = min_radius;
      }
    }
    return radii;
  }
}

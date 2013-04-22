class Graph { 
  float[] xs;
  float[] ys;
  String lx, ly;
  float xmax, ymax;
  float axis_w;
  float x,y,h,w;
  float plotx, ploty, ploth, plotw;
  
  //take in 2d string array 
  
  public Graph(String[][] data, float _x, float _y, float _h, float _w) {
    axis_w = 70;
    xs = new float [data[1].length-1];
    ys = new float [data[1].length-1];
    for (int i=0; i<data[1].length-1; i++) { 
      xs[i] = float(data[1][1+i]);
      ys[i] = float(data[2][1+i]);
    }
    lx = data[1][0]; ly = data[2][0];
    x = _x; y = _y; h = _h; w = _w;
    plotx = x+axis_w; ploty = y;
    ploth = h-axis_w; plotw = w-axis_w;
    xmax = 0; ymax = 0;
    for (int i = 0; i < xs.length; i++) {
      if (xs[i] > xmax) xmax = xs[i];
      if (ys[i] > ymax) ymax = ys[i];
    }
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
    float[] locs = new float[xs.length];
    float xaxis = y + ploth;
    for (int i = 0; i < locs.length; i++) {
      locs[i] = xaxis - (ploth*(ys[i]/ymax));
    }
    return locs;
  }
}

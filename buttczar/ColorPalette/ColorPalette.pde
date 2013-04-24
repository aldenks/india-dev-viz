color[] cs;
color c1;
int[] R;
int[] G;
int[] B;

void setup() {
  size(800,400);
  background(255);
  cs = new color [36];
  R = new int[36]; G = new int[36]; B = new int[36];
  int[] R = {176, 180, 123, 95, 16, 0, 60, 0, 0, 107, 128, 189,
             217, 255, 139, 153, 255, 255, 184, 255, 255, 250, 255, 
             238, 255, 255, 178, 255, 205, 255, 208, 176, 128, 255, 153, 92 }; 
  int[] G = {226, 205, 104, 158, 78, 206, 190, 250, 128, 142, 128, 183,
             217, 236, 129, 204, 255, 215, 134, 165, 120, 128, 99, 
             121, 69, 0, 34, 192, 104, 105, 32, 48, 0, 0, 50, 51};
  int[] B = {255, 205, 238, 160, 139, 209, 113, 154, 0, 35, 0, 107,
             143, 139, 76, 50, 0, 0, 11, 0, 0, 114, 71, 
             66, 0, 0, 34, 203, 137, 180, 144, 96, 128, 255, 204, 23};
  for (int i=0; i< R.length; i++){
    cs[i] = color(R[i], G[i], B[i]);
  }
  
 // String [] cols = {"#FF0000"};
  println(cs);
/*     {  c1, color(#FF4500), color(#FFA500), color(#FFFF00),
        color(#ADFF2F), color(#008000), color(#87CEFF), color(#EE82EE), 
        color(#F4A460), color(#8B4513), color(#7FFFD4), color(#FFC125),
        color(#ADD8E6), color(#FF00FF), color(#800000), color(#FFDAB9),
        color(#FFC0CB), color(#D2B48C), color(#20B2AA), color(#FFFACD), 
        color(#6B8E23), color(#872657), color(#FF8C69), color(#6A5ACD)};
  println(cols);*/

}

void draw() {
  for (int i = 0; i<36; i++){
    fill(cs[i]);
    rect(i*width/40, height*.25, 20, 200);
  }
}

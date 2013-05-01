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
import controlP5.*;

class DropdownSelectGroup {
    int selected_x_idx, selected_y_idx, selected_z_idx, selected_state_idx;
    DropdownList ddx, ddy, ddz, dds; // DropDowns for X, Y, Z, and State
    CheckBox coal_chkbx;
    String[] state_names;
    PImage circles_label_img;

    final float TOTAL_WIDTH;
    static final int SINGLE_SELECT_WIDTH = 175;
    static final int LABEL_WIDTH = 32;
    static final int ITEM_HEIGHT = 20;
    static final int PADDING = 20;
    static final int LABEL_NUDGE = 3;
    private boolean first_run = true;
    Button helpButton;

    public DropdownSelectGroup(ControlP5 cp5, String[] column_names,
                               String[] _state_names) {
        String[] _all = { "All States", "Mineral-Rich States" };
        _state_names = sort(_state_names);
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
        coal_chkbx = cp5.addCheckBox("coal_toggle")
            .setSize(ITEM_HEIGHT, ITEM_HEIGHT)
            .setColorLabel(color(0))
            .addItem("", 0);

        TOTAL_WIDTH = 4*SINGLE_SELECT_WIDTH + 4*LABEL_WIDTH + 3*PADDING;
        circles_label_img = loadImage("img/concentric_circles.png");

        helpButton = new Button(cp5, " Help")
                           .setWidth(47)
                           .setSwitch(true);
    }

    void draw(float x, float y, float w, float h) {
        if (first_run) {
            ddx.setIndex(17); ddy.setIndex(6); ddz.setIndex(3); dds.setIndex(0);
            first_run = false;
        }
        pushStyle();
        float y_center = y + (h/2);
        float dd_y_pos = y_center + (float(ITEM_HEIGHT)/2);
        float x_begin = (float(width)/2) - (TOTAL_WIDTH/2);
        x_begin = x_begin < 0 ? 0 : x_begin;
        x_begin = 100;
        coal_chkbx.setPosition(x_begin, dd_y_pos - ITEM_HEIGHT);
        float dd_begin = x_begin + LABEL_WIDTH + PADDING;
        int item_width = SINGLE_SELECT_WIDTH + PADDING + LABEL_WIDTH;
        dds.setPosition(dd_begin + 0*item_width, dd_y_pos);
        ddx.setPosition(dd_begin + 1*item_width, dd_y_pos);
        ddy.setPosition(dd_begin + 2*item_width, dd_y_pos);
        ddz.setPosition(dd_begin + 3*item_width, dd_y_pos);
        textAlign(RIGHT, CENTER);
        text("Only Coal",  x_begin - 4, y_center - 9);
        text("Producers:", x_begin - 4, y_center + 5);
        textSize(18);
        text("X: ", dd_begin + 1*item_width,     y_center - LABEL_NUDGE);
        text("Y: ", dd_begin + 2*item_width,     y_center - LABEL_NUDGE);
        text(  ":", dd_begin + 3*item_width - 2, y_center - LABEL_NUDGE);
        image(circles_label_img, PADDING + x_begin + 3*item_width,
              y_center - float(circles_label_img.height)/2);
        popStyle();
        helpButton.setHeight(ITEM_HEIGHT);
        helpButton.setPosition(dd_begin + 4*item_width,
            dd_y_pos - ITEM_HEIGHT - 1);
        if(helpButton.isPressed()){
          helpButton.setOn();
        }

        if(helpButton.isOn()){
          drawHelpWindow(dd_begin+4*item_width, y_center + 20);
        }  
    }

    int selectedXIndex() { return selected_x_idx; }
    int selectedYIndex() { return selected_y_idx; }
    int selectedZIndex() { return selected_z_idx; }
    String selectedStateName() { return state_names[selected_state_idx]; }
    boolean onlyCoal() { return coal_chkbx.getState(0); }

    void controlEvent(ControlEvent e) {
        ControlGroup g = e.getGroup();
        if (g == ddx) {
            selected_x_idx = int(e.getGroup().getValue());
        } else if (g == ddy) {
            selected_y_idx = int(e.getGroup().getValue());
        } else if (g == ddz) {
            selected_z_idx = int(e.getGroup().getValue());
        } else if (g == dds) {
            selected_state_idx = int(e.getGroup().getValue());
        }
    }

    void customizeDropdown(DropdownList d) {
        d.setSize(SINGLE_SELECT_WIDTH, 27*ITEM_HEIGHT)
            .setBarHeight(ITEM_HEIGHT)
            .setItemHeight(ITEM_HEIGHT)
            .toUpperCase(false);
        d.captionLabel().style().marginTop = 2;
    }

    // x y for where to draw helpbutton
    void drawHelpWindow(float x, float y){
      String[] help = new String[6];
      help[0] = "Click and drag to select districts (data points).";
      help[1] = "Selected districts will appear on map.";
      help[2] = "Click again to deselect districts.";
      help[3] = "Select variables to view in dropdowns.";
      help[4] = "CAUTION: selecting a large # of districts will";
      help[5] = "take a significant amount of time to render!";
      float rect_width = textWidth(help[0]);
      float line_height = 15;
      float x_padding = 10;
      float y_padding = 5;
      fill(#002b36);
      rect(x - rect_width/2,y,rect_width+2*x_padding,
          line_height*6 + 2*y_padding);
      textAlign(LEFT,BOTTOM);
      fill(#FFFFFF);
      text(help[0], x+x_padding - rect_width/2, y + line_height + y_padding);
      text(help[1], x+x_padding - rect_width/2, y + line_height*2 + y_padding);
      text(help[2], x+x_padding - rect_width/2, y + line_height*3 + y_padding);
      text(help[3], x+x_padding - rect_width/2, y + line_height*4 + y_padding);
      text(help[4], x+x_padding - rect_width/2, y + line_height*5 + y_padding);
      text(help[5], x+x_padding - rect_width/2, y + line_height*6 + y_padding);
    }
}

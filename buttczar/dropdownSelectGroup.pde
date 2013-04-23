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
    String[] state_names;
    PImage circles_label_img;

    final float TOTAL_WIDTH;
    static final int SINGLE_SELECT_WIDTH = 170;
    static final int LABEL_WIDTH = 32;
    static final int ITEM_HEIGHT = 20;
    static final int PADDING = 20;
    static final int LABEL_NUDGE = 3;
    private boolean first_run = true;

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
    }

    void draw(float x, float y, float w, float h) {
        if (first_run) {
            ddx.setIndex(0); ddy.setIndex(1); ddz.setIndex(2); dds.setIndex(0);
            first_run = false;
        }
        pushStyle();
        float y_center = y + (h/2);
        float dd_y_pos = y_center + (float(ITEM_HEIGHT)/2);
        float x_begin = (float(width)/2) - (TOTAL_WIDTH/2);
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
              y_center - float(circles_label_img.height)/2);
        popStyle();
    }

    int selectedXIndex() { return selected_x_idx; }
    int selectedYIndex() { return selected_y_idx; }
    int selectedZIndex() { return selected_z_idx; }
    String selectedStateName() { return state_names[selected_state_idx]; }

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
}

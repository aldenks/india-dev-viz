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
 */
import controlP5.*;

class DropdownSelectGroup {
    String[] column_names;
    int selected_x_idx, selected_y_idx, selected_z_idx;

    DropdownList ddx, ddy, ddz; // DropDowns for X, Y, and Z
    DropdownList[] ddls;
    final float TOTAL_WIDTH;
    static final int SINGLE_SELECT_WIDTH = 200;
    static final int LABEL_WIDTH = 25;
    static final int ITEM_HEIGHT = 20;
    static final int PADDING = 10;
    private boolean first_run = true;

    public DropdownSelectGroup(ControlP5 cp5, String[] _column_names) {
        column_names = _column_names;

        ddx = cp5.addDropdownList("X");
        ddy = cp5.addDropdownList("Y");
        ddz = cp5.addDropdownList("Z");
        ddls = new DropdownList[] { ddx, ddy, ddz };

        for (DropdownList d : ddls) {
            for (int i = 0; i < column_names.length; i++) {
                d.addItem(column_names[i], i);
            }
            d.setSize(SINGLE_SELECT_WIDTH, 15*ITEM_HEIGHT)
               .setBarHeight(ITEM_HEIGHT)
               .setItemHeight(ITEM_HEIGHT)
               .toUpperCase(false);
            d.captionLabel().style().marginTop = 2;
        }
        TOTAL_WIDTH = 3*SINGLE_SELECT_WIDTH + 3*LABEL_WIDTH + 2*PADDING;
    }

    void draw(float x, float y, float w, float h) {
        if (first_run) {
            ddx.setIndex(0); ddy.setIndex(1); ddz.setIndex(2);
            first_run = false;
        }
        pushStyle();
        float dd_y_pos = y + (h/2) + (float(ITEM_HEIGHT)/2);
        float x_begin = (float(width)/2) - (TOTAL_WIDTH/2);
        int item_width = SINGLE_SELECT_WIDTH + PADDING + LABEL_WIDTH;
        ddx.setPosition(x_begin + 0*item_width, dd_y_pos);
        ddy.setPosition(x_begin + 1*item_width, dd_y_pos);
        ddz.setPosition(x_begin + 2*item_width, dd_y_pos);
        popStyle();
    }

    int selectedXIndex() { return selected_x_idx; }
    int selectedYIndex() { return selected_y_idx; }
    int selectedZIndex() { return selected_z_idx; }

    void controlEvent(ControlEvent e) {
        ControlGroup g = e.getGroup();
        if (g == ddx) {
            selected_x_idx = int(e.getGroup().getValue());
        } else if (g == ddy) {
            selected_y_idx = int(e.getGroup().getValue());
        } else if (g == ddz) {
            selected_z_idx = int(e.getGroup().getValue());
        }
    }
}

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

    final float TOTAL_WIDTH;
    static final int SINGLE_SELECT_WIDTH = 200;
    static final int LABEL_WIDTH = 25;
    static final int ITEM_HEIGHT = 20;
    static final int PADDING = 10;
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
                  }

    void draw(float x, float y, float w, float h) {
        if (first_run) {
            ddx.setIndex(0); ddy.setIndex(1); ddz.setIndex(2); dds.setIndex(0);
            first_run = false;
        }
        pushStyle();
        float dd_y_pos = y + (h/2) + (float(ITEM_HEIGHT)/2);
        float x_begin = (float(width)/2) - (TOTAL_WIDTH/2);
        int item_width = SINGLE_SELECT_WIDTH + PADDING + LABEL_WIDTH;
        ddx.setPosition(x_begin + 0*item_width, dd_y_pos);
        ddy.setPosition(x_begin + 1*item_width, dd_y_pos);
        ddz.setPosition(x_begin + 2*item_width, dd_y_pos);
        dds.setPosition(x_begin + 3*item_width, dd_y_pos);
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

import java.util.Iterator;
import java.util.Map;

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
      int ID       = int(split(lines[i],',')[0]);
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
        if(float(d.data[0]) == 0 && float(d.data[1]) == 0){
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
        if(!filter_coal || (float(d.data[0]) != 0 || float(d.data[1]) != 0)){
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

  ArrayList getIDsFromNames(ArrayList names) {
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

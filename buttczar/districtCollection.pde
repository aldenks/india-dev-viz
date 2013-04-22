import java.util.Iterator;
import java.util.Map;

class DistrictData {
    HashMap<String, Integer> varNameToIndex;
    HashMap<String, District> districts;  
    String indexToVarName[]; 
    String values[][];

    // filename is a csv of data
    public DistrictData(String filename) {
        districts = new HashMap(650);
        String name;

        String lines[] = loadStrings(filename);
        values  = new String[lines.length-1][];
        for (int i = 0; i < lines.length; i++) {
            if (i == 0) {
                indexToVarName = split(lines[i], ',');
                varNameToIndex = new HashMap<String,Integer> (indexToVarName.length);
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
                District d = new District(varNameToIndex, values[i]);
                districts.put(name, d);
            }
        }
    }

    public District getDistrict(String name) {
        return districts.get(name);
    }

    public float getDistrictValue(String name, String feature) {
        return (districts.get(name)).getVariable(feature);
    }

    public String[][] getColumns(int var1, int var2) {
        String columns[][] = new String[3][districts.size()+1]; 
        columns[0][0] = "Name";
        columns[1][0] = indexToVarName[var1];
        columns[2][0] = indexToVarName[var2];
        Iterator iter = districts.entrySet().iterator();
        int i = 1; 
        while (iter.hasNext()) {
            Map.Entry x = (Map.Entry)iter.next();
            columns[0][i] = (String)x.getKey();
            District d = (District)x.getValue(); 
            columns[1][i] = d.data[var1];
            columns[2][i] = d.data[var2];
            i++;
        }
        return columns;
    }

}
        


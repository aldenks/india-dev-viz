class DistrictData {
    HashMap<String, Integer> variables;
    HashMap<String, District> districts;  

    // filename is a csv of data
    public DistrictData(String filename) {
        districts = new HashMap(650);
        String name;

        String lines[] = loadStrings(filename);
        String values[][]  = new String[lines.length-1][];
        for (int i = 0; i < lines.length; i++) {
            if (i == 0) {
                String titles[] = split(lines[i], ',');
                variables = new HashMap<String,Integer> (titles.length);
                for (int v = 0; v < titles.length; v++) {
                    variables.put(titles[v], v);
                }
            }
            else {
                values[i-1] = split(lines[i], ','); 
            }
        }

        for (int i = 0; i < values.length; i++) {
            name = values[i][1];  
            if (!districts.containsKey(name)) {
                District d = new District(variables, values[i]);
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

}
        


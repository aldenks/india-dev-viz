class District {
  public String name;
  public String state;
  String data[];
  HashMap<String, Integer> variables;

  public District (HashMap _variables, String _data[], 
                   String _name, String _state) 
  {
    data = _data;
    variables = _variables;
    name = _name;
    state = _state;
  }

  public float getVariable(String variable) {
    if (!variables.containsKey(variable)) {
      throw new IllegalArgumentException("Invalid Variable: " + variable);
    }
    else {
      int i = variables.get(variable);
      return float(data[variables.get(variable)]);
    }
  }
}

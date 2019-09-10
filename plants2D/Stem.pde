class Stem {

  ArrayList<Line> lines= new ArrayList<Line>();
  ArrayList<Anchor> achs= new ArrayList<Anchor>();
  ArrayList<Leaf> leaves= new ArrayList<Leaf>();
  
  Float growthCounter = startingGrowth;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Stem (float x, float y) {
    Anchor start = new Anchor(x,y,0);
    achs.add(start);
    Anchor end = new Anchor(x,y,1);
    achs.add(end);
    //creates two points
    
    Line line = new Line( start, end, startWidth);
    lines.add(line); //creates a line
    start.addNeighbour(end);
    end.addNeighbour(start);
    //the points become each others neighbours
    
    Leaf aLeaves[] = end.createLeaves();
    for (int i = 0; i<aLeaves.length; i++) {
      leaves.add(aLeaves[i]);
    }
    //creates the first leaves
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //GROWTH
  void grow () {
      for (int i = lines.size() - 1; i >= 0; i--) {
        Line line = lines.get(i);
          if (line.end.aWidth < maxWidth){
            lines.get(i).grow();
          }
        
        if (line.lineLength > lengthBreak) {        //line break condiditon
          float randomBending = random(1);  
          //Bending chance    
          if (randomBending < bendingChance) {
            Line newLine = line.breakLine(achs.size());
            lines.add(newLine);
            achs.add(newLine.start);
            //BREAKS a line
            
            float randomBranching = random(1);     
            //Branching chance
            if (randomBranching < branchingChance) {
              branching(newLine.start.position.x, newLine.start.position.y,achs.size(),line);
            }
          }
        }
      }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void display() {
    for (int i =0; i < lines.size();i++) {//display the lines
      lines.get(i).display(i);
    }
    if (showAnchors) {
      for (int i =0; i < achs.size();i++) {//display the points
        achs.get(i).display(i);
      }
    }
    if (showLeaves) {
      for (int i =0; i < leaves.size();i++) {//display the leaves
        leaves.get(i).display();
      }
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Line branching (float x, float y, int index, Line originalLine) {//TODO: consider moving branching to the line class
    Anchor start = new Anchor(x,y,index);
    start.linked = true;
    achs.add(start);
    Anchor end = new Anchor(x,y,index+1);
    achs.add(end);
    
    Line line = new Line(start, end, originalLine, startWidth);
    lines.add(line); 
    //creates a new line
    
    start.addNeighbour(end);
    end.addNeighbour(start);
    //start and end become each others neighbours
    
    start.addNeighbour(originalLine.end);
    originalLine.end.addNeighbour(start);
    //start and oringal line end become each others neighbours
    
    Leaf aLeaves[] = end.createLeaves();
    for (int i = 0; i<aLeaves.length;i++) {
      leaves.add(aLeaves[i]);
    }
    //creates the first leaves
    
    return line;
  }
}

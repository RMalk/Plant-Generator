class Anchor {
  PVector position;
  PVector previousPosition; //TODO: forgot what this was for
  
  int index; //The index is used for easy comparisson
  
  Boolean lightProbe = false; //if the anchor is a light probing tip of a branch
  Boolean linked = false;
  
  float aWidth = 0; //the width of the anchor
  
  Anchor[] neighbours; //the neighbours of a anchor, used for establishing relations
  Leaf[] aLeaves;
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Anchor (float x, float y, int i) {
   index = i;  //The root is always index 0
   position = new PVector(x,y);
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void display (int num) {
    if (checkNeighbours){
      visualizeNeighbours( position, neighbours);
    }
    if (showAnchors) {
      fill (155);
      stroke(0,0);
      ellipse(position.x, position.y, aWidth, aWidth);
    }
    if (anchorIndex) {
      visualizeAnchorIndex( position, num);
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //NEIGHBOUR MANIPULATION
  void neighbourSwap(Line line, Anchor newNeighbour) {
    for (int i = 0; i < neighbours.length; i++) {
      if (line.start.index == neighbours[i].index) {
        neighbours[i] = newNeighbour;
      } else if (line.end.index == neighbours[i].index) {
        neighbours[i] = newNeighbour;
      }
    }
  }
  
  void addNeighbour(Anchor neighbour) {
    if (neighbours == null) {
      neighbours = new Anchor[1];
      neighbours[0] = neighbour;
    } else {
      Anchor[] newNeighbours = new Anchor[neighbours.length+1];
      for (int i = 0; i < neighbours.length;i++) {
        newNeighbours[i] = neighbours[i];
      }
      newNeighbours[neighbours.length] = neighbour;
      neighbours = newNeighbours;
    }
  }
  
  void addNeighbour (Anchor[] newNeighbours) {
    neighbours = newNeighbours;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //LEAF CREATION
  Leaf[] createLeaves () { //creates the relevant amount of leaves on an anchor
    lightProbe = true;
    aLeaves = new Leaf[leafCount];
    int j=0;
    if (leafCount%2 == 0) { //when the number of leaves is divisible by 2
       for(int i = aLeaves.length/-2;i <= aLeaves.length/2; i ++) {
         if (i != 0){
           float rot = leafAngle * float(i);
           aLeaves[j] = new Leaf(rot,this);
           j++;
         }
       }
     } else {
       int lC = floor(aLeaves.length/2);
       for(int i = -lC;i <= lC; i ++) {
           float rot = leafAngle * float(i);
           aLeaves[j] = new Leaf(rot,this);
           j++;
       }
     }
     return aLeaves;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  boolean grow(PVector dir,int startIndex, boolean link) { //recursive growth function, it pushes all the anchors above it as it grows
    PVector newDir = new PVector (dir.x + position.x, dir.y + position.y);
    boolean bent = false;
    
    if (newDir.x < width && newDir.x >= 0 && newDir.y <= height && newDir.y >= 0) { //check if the plant is inside of the frame
      if(blocked[floor(newDir.x/pixelPerVoxel)][floor(newDir.y/pixelPerVoxel)] < 1){ //check if blocked tile is fully black
        bent = true;
        if (abs(dir.x) == abs(dir.y)) { //if x=y the angle of approach is 45 degrees, which is an issue, but not likely
          dir = new PVector(-dir.x, -dir.y);
        } else if (abs(dir.x)>abs(dir.y)) { //x is greater than y which means horizontal movement is dominant 
          dir = new PVector( 0, signum(dir.y)*(abs(dir.x) + abs(dir.y)));
        } else { //y is greater than x which means vertical movement is dominant 
          dir = new PVector(signum(dir.x)*(abs(dir.x) + abs(dir.y)), 0);
        }
      }
    }
    if (link) {
      position = neighbours[1].position;
    } else { 
      position.add(dir);
    }
    
    for (int i = 0;i < neighbours.length ; i++) { //recursive growth upward through the anchor hierarchy
      if (neighbours[i].index != startIndex) {
        if (neighbours[i].linked) {
          neighbours[i].grow(dir,index, true);
        } else {
          neighbours[i].grow(dir,index, false);
        }
      }
    }
    
    if (lightProbe) { //the growth of leaves
      for (int i = 0; i<aLeaves.length;i++) {
       if (!aLeaves[i].fullyGrown) {
        aLeaves[i].grow(growthSpeed*aWidth);
       }
      }
    }
    return bent;
  }
}

class Line {
  Anchor start;
  Anchor end;

  float lineLength;
  int growthReserve;

  PVector gDirection = new PVector(up.x, up.y);

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//LINE CONSTRUCTORS
//starting line
  Line (Anchor a1, Anchor a2, float lWidth) { 
    start = a1;
    end = a2;
    start.aWidth = lWidth;
    end.aWidth = lWidth/2;
  }
  //bending line
  Line (Anchor a1, Anchor a2, Line oLine) { 
    float randomDir = radians(random(-bendingAngle, bendingAngle));
    //adding random varriation to growth direction
    gDirection = new PVector (oLine.gDirection.x,oLine.gDirection.y);
    gDirection.rotate(randomDir);
    start = a1;
    end = a2;
  }
  //branching line
  Line (Anchor a1, Anchor a2, Line oLine, float lWidth) {  
    float randomDir = radians(randomFlip() * (branchingAngle + random(-branchingAngleVar,branchingAngleVar)));
    gDirection = new PVector (oLine.gDirection.x,oLine.gDirection.y);
    gDirection.rotate(randomDir);
    
    start = a1;
    end = a2;
    start.aWidth = lWidth;
    end.aWidth = lWidth/2;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void display(int num) {
    stroke(branchColor);
    strokeWeight(end.aWidth*2);
    line (start.position.x, start.position.y, end.position.x, end.position.y);

    if (lineText) { //show index
      visualizeLineText(start.position,end.position, num);
    }
    if (directionText) { //show direction
      visualizeDirectionText(start.position,end.position,gDirection);
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // breaks the line in to two pieces
  // the original line becomes the bottom part and a new one that is created becomes the top part
  Line breakLine (int aIndex) { 
    PVector midV = new PVector(
      (start.position.x + end.position.x)/2, 
      (start.position.y + end.position.y)/2);
    //Calculate line midpoint

    Anchor mid = new Anchor(midV.x, midV.y, aIndex);
    mid.addNeighbour(start);
    mid.addNeighbour(end);
    //Cretion of a mid point

    start.neighbourSwap(this, mid);
    end.neighbourSwap(this, mid);
    //modify neighbours
    mid.aWidth = (start.aWidth + end.aWidth)/2;
    Line line = new Line (mid, end, this);
    end = mid;

    return line;
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void grow() {
    float tempGrow = growthSpeed;
    if (speed) { 
      tempGrow *= 10;
    }
    start.aWidth += tempGrow/widthDivisor; //TODO
    end.aWidth += tempGrow/widthDivisor; //TODO
    PVector growDir = new PVector (gDirection.x*tempGrow,gDirection.y*tempGrow);
    
    if (end.grow(growDir, start.index,false)) {
      //print(gDirection+"|");
      gDirection = new PVector(start.position.x - end.position.x, start.position.y - end.position.y).normalize();
      float randomDir = radians(random(-bendingAngle, bendingAngle));
      gDirection.rotate(randomDir);
      //println(gDirection);
    }
    
    lineLength = PVector.dist(start.position, end.position);
  }
}

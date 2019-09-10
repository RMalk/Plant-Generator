
int turn = 0;
int turnDelay = 50;//delay for optimising the calculations

ArrayList <Stem> stems = new ArrayList<Stem>();

PVector up = new PVector(0.0,-1.0);//default up direction
PVector leafDimensons;

color branchColor = color (96,57,19);

void setup() {
  size (640, 768);
  noSmooth();
  utilitySetup();
  if ( customImage) {
    customImg();
  } else {
    createImg();
  }
  stems.add(new Stem(width/2,height - 1));
}

void draw() {
  if (!showBlockage) {
   background (155);
  } else {
   visualizeBlockage();
  }
  
 for (int i = 0; i < stems.size(); i++) {
   if (!pause) {
     if (turn >= turnDelay) {
       turn = 0;
       //updateBlockage();
     }
     turn++;
     stems.get(i).grow();//TODO
   }
   stems.get(i).display();
 }
}

PShape drawLeaf () {//TODO: import mesh, custom shapes and textures
  //float colorVar = random(-25,25);
  PShape leaf;
  leaf = createShape();
  leaf.beginShape();
  //leaf.fill(55+colorVar, 205+colorVar, 55+colorVar);
  leaf.fill(55, 200, 55);
  leaf.noStroke();
  leaf.vertex(0, 0);
  leaf.vertex(-1.67961, 0.573473);
  leaf.vertex(-5.02024, -1.08723);
  leaf.vertex(-5.31299, -3.84205);
  leaf.vertex(-3.50249, -6.32858);
  leaf.vertex(-1.27519, -8.24201);
  leaf.vertex(0, -9.96132);
  leaf.vertex(1.27519, -8.24201);
  leaf.vertex(3.50249, -6.32858);
  leaf.vertex(5.31299, -3.84205);
  leaf.vertex(5.02024, -1.08723);
  leaf.vertex(1.67961, 0.573473);
  leaf.endShape(CLOSE);
  leafDimensons = new PVector(leaf.width, leaf.height);
  return leaf;
}

class Leaf {
  PShape Lshape;
  Anchor anc;
  
boolean leafStrenght = true;
  
  float size = 0;
  float rotation;
  color colorVar;//TODO
  
  boolean fullyGrown = false;
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
 Leaf(float rot, Anchor a){
   anc = a;
   rotation = radians(rot);
 }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 void display() {
   Lshape = drawLeaf();
   
   PVector neighbourPos = anc.neighbours[0].position;
   PVector branchDir = new PVector (anc.position.x - neighbourPos.x, anc.position.y - neighbourPos.y);
   
   float rot =  rotation + branchDir.heading() + (PI/2);
   Lshape.rotate(rot);
   
   if (leafStrenght) {
     fill (0,255,0);
    text (size,anc.position.x, anc.position.y);  
   } else {
     shape(Lshape, anc.position.x, anc.position.y,leafDimensons.x*leafMaxSize*size,leafDimensons.y*leafMaxSize*size);
   }
 }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 void grow(float growth) {
   size += growth/100;//TODO
   if (size > 1) {
     fullyGrown = true;
   }
 }
 
 float gatherLight() {
   return(lightGather*size); //TODO
 }
}

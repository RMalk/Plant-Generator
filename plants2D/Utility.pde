

boolean showLeaves = true;
boolean showAnchors = false;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//UTILITY FUNCTIONS
void utilitySetup () {
  randomSeed(randomSeed);
}

int randomFlip () {
 int flip = round(random(1));
 if (flip == 0) {
  flip = -1; 
 }
 return flip; 
}

int signum(float f) {
  if (f > 0) return 1;
  if (f < 0) return -1;
  return 0;
} 

void sortG () {//TODO
  
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//CONTROLS
boolean pause = false;
boolean speed = false;

void keyPressed() {
 if( keyCode == TAB) {
   pause = !pause;
 }
 if ( keyCode == SHIFT) {
  speed = !speed;
 }
 if ( key == 'r' ) {
   stems.remove(0);
    stems.add(new Stem(width/2,height - 1));
 }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//BLOCKAGEint [][] blocked;
boolean showBlockage = true;
boolean customImage = true;
String imageName = "Test Scene/room_04.png";

PImage blockImg;
int[][] blocked;
boolean[][] blockChecked;
int pixelPerVoxel = 8;

void createImg () {//creating an empty image
  blockImg = createImage( width, height, RGB);
  blockImg.loadPixels();
  blocked = new int[width/pixelPerVoxel][height/pixelPerVoxel];
  blockChecked = new boolean[width/pixelPerVoxel][height/pixelPerVoxel];
  int i = 0;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < width; y++) {
      i = x + (y * width);
      blocked[int(x/pixelPerVoxel)][int(y/pixelPerVoxel)] = 255;
      blockImg.pixels[i] = color (255,255,255);
    }
  }
  blockImg.updatePixels();
}

void customImg () {
  blockImg = loadImage(imageName);
  blocked = new int[blockImg.width][blockImg.height];
  blockChecked = new boolean[blockImg.width][blockImg.height];
  
  for (int x = 0; x < blockImg.width; x++) {
    for (int y = 0; y < blockImg.height; y++) {
      blocked[x][y] = int(red(blockImg.get(x,y)));
      blockChecked[x][y] = false;
    }
  }
}

float plantTranslucency = 0.1;//TODO: move to genes
float plantThickness = 2;

void updateBlockage() { //THIS IS HEAVY
  if ( customImage) {
    customImg();
  } else {
    createImg();
  }
  for (int s = 0; s < stems.size();s++) {
    Stem tempsStems = stems.get(s);
    
    for (int l = 0; l < tempsStems.lines.size(); l++) {
      PVector start = tempsStems.lines.get(l).start.position;
      PVector direction = new PVector (
        start.x - tempsStems.lines.get(l).end.position.x,
        start.y - tempsStems.lines.get(l).end.position.y);
      float lenght = direction.mag()/pixelPerVoxel;
      
      for (int i = 0; i < round(lenght); i++) {
        int x,y;
        if (i != 0) {
          x = int(start.x + (direction.x * (i/lenght)));
          y = int(start.y + (direction.y * (i/lenght)));
        } else {
          x = int(start.x);
          y = int(start.y);
        }
        
        for (int j = y; j < blockImg.height; j++) {
          if (!blockChecked[x][j]) {
            blocked[x][j] = int(red(blockImg.get(x * (pixelPerVoxel/ 2), j * (pixelPerVoxel/ 2)))) - 55;
            blockChecked[x][j] = true;
            println(int(blocked[x][j] * (plantTranslucency)));
          }
        }
      }
    }
  }
  updateImage();
}

void updateImage() {
  int i;
  for (int x = 0; x < blockImg.width; x++) {
    for (int y = 0; y < blockImg.height; y++) {
      i = x + (y * blockImg.width);
      blockImg.pixels[i] = color(blocked[x][y]);
    }
  }
  for (int x = 0; x < blockImg.width; x++) {
    for (int y = 0; y < blockImg.height; y++) {
      blockChecked[x][y] = false;
    }
  }
}

void visualizeBlockage() {
  PImage img = blockImg;
  img.resize (width, 0);
  image(img,0,0); //TODO
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//DEBUG VISUALIZE
boolean lineText = false;
boolean directionText = false;
boolean anchorIndex = false;
Boolean checkNeighbours = false;

void visualizeLineText(PVector start, PVector end,int index) {
  fill (255, 0, 255);
  textSize(25);
  textAlign(CENTER, CENTER);
  PVector mid = new PVector(
    (start.x + end.x)/2, 
    (start.y + end.y)/2);
  text (index, mid.x, mid.y);
}

void visualizeDirectionText(PVector start, PVector end,PVector gDirection) {
  fill (255, 0, 255);
  textSize(12);
  textAlign(CENTER, CENTER);
  PVector mid = new PVector(
    (start.x + end.x)/2, 
    (start.y + end.y)/2);
  String text = str(gDirection.x)+"|"+ str(gDirection.y)+"|"+ str(gDirection.z);
  text (text, mid.x, mid.y);
}

void visualizeAnchorIndex(PVector position, int num) {
  if (num != 0) {
    fill (255);
    textSize(8);
    textAlign(CENTER,CENTER);
    text (num,position.x,position.y);
  }
}

void visualizeNeighbours (PVector position, Anchor[] neighbours) {
  for (int i = 0; i < neighbours.length; i++) {
    Anchor end = neighbours[i];
    PVector midV = new PVector((position.x + end.position.x)/2, (position.y + end.position.y)/2);
    
    stroke (255,0,0);
    strokeWeight(1);
    line (position.x, position.y, midV.x, midV.y);
  }
}

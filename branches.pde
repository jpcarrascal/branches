int ntrees;
float ox, oy;

ArrayList<Branch> branches; 

void setup()
{
  //size(1920, 1080);
  size(600, 600);
  //fullScreen();
  if (mouseX==0 && mouseY==0)
  {
    ox = width/2;
    oy = height/2;
  } else
  {
    ox = mouseX;
    oy = mouseY;
  }
  smooth();
  strokeCap(ROUND);
  strokeJoin(ROUND);
  ntrees = 1;//int(random(5, 50));
  background(0);
  frameRate(24);
  branches = new ArrayList<Branch>();
  for (int i = 0; i < ntrees; i++) {
    //Branch(x, y, angle, len, wid, drift, diverge, divRateMin, divRateMax)
    ///branches.add( new Branch( new PVector(ox, oy), PI/(i*0.1), random(0.5, 2), random(0.1, 8), 0.2, 0.5, 200, 300 ) );
    branches.add( new Branch( new PVector(ox, oy), PI/(i*0.1+0.1), random(2, 2), random(0.1, 8), 0.2, 0.5, 2000, 3000 ) );
    // Trees:
    //branches.add( new Branch( i*(width/(ntrees)), height, PI*1.5, random(1,3), random(0.1,10), 0.2, 0.5, 20, 100 ) );
    // Video, corner 1:
    // branches.add( new Branch( -20, -20, 0.8-(PI*i*2), random(0.5,1), random(1,10), 0.1, 0.3, 100, 200 ) );
    //branches.add( new Branch( ox, oy, 0.8-(PI*i*2), random(0.5,1), random(0.5,8), 0.1, 0.3, 100, 400 ) );
  }
}

void draw()
{
  for (Branch branch : branches) {
    branch.grow(new PVector(mouseX, mouseY));
  }
  //  saveFrame("anim/tree-####.png");
}

void mouseClicked() {
  setup();
}
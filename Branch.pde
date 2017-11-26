public class Branch {
  Branch child1;
  Branch child2;
  float angle;
  float D, prevD;
  PVector curPos;
  float len, wid;
  color clr;
  boolean growing = true;
  float drift;
  float diverge;
  float divRateMin;
  float divRateMax;
/*
PVector start(x,y): Start position
angle: Initial growing angle/direction
len: Segment length. The larger the length, the faster the tree will grow.
wid: Thickness of the initial branch (trunk).
drift: How much the branches drift from their initial direction. If drift=0 branches will be straight lines.
diverge: (angle) How much new child branches diverge from each other (this one is affected by drift).
divRate min, divRateMax: (frames) Boundaries for how fast branches start to divide into children.
Use the same value for both equal to keep branching time constant.
*/
  private Branch(PVector start, float angle, float len, float wid,
                float drift, float diverge, float divRateMin, float divRateMax) {
    this.angle = angle;
    this.prevD = 0;
    this.curPos = start;
    this.len = len;
    this.wid = wid;
    this.growing = true;
    this.drift = drift;
    this.diverge = diverge;
    this.divRateMin = divRateMin;
    this.divRateMax = divRateMax;
    //clri = color(random(255), random(255), random(255), 200);
    this.clr = color(255, 255, 255, 100);
  }

  void grow(PVector dest)
  {
    stroke(clr);
    strokeWeight(wid);
    fill(clr);
    //pushStyle();
    //stroke(255,0,0, 10);
    //strokeWeight(0.01);
    //line(curPos.x,curPos.y,dest.x,dest.y);
    //popStyle();

    if(growing)
    {
      float diffAngle = atan2((dest.y - curPos.y), (dest.x - curPos.x));
      D = dest.x - curPos.x;
      pushStyle();
      strokeWeight(0.1);
      stroke(255-D/10,0,0,255-D/10);
      //linePV(dest, curPos);
      popStyle();
      PVector nextPos = new PVector(curPos.x+len*cos(angle), curPos.y+len*sin(angle));
      println(curPos.x + "\t" + curPos.y + "\t\t" + nextPos.x + "\t" + nextPos.y);
      //PVector nextPos = diff.mult(len);
      
//      translate(curPos.x, curPos.y);
//      line(0, 0, nextPos.x, nextPos.y);

      
      linePV(curPos, nextPos);
      angle = 0.95*angle+0.05*diffAngle + random(-drift, drift);
      //angle = diffAngle + 5*random(-drift, drift);
      println(degrees(diffAngle) + "\t" + D);
      curPos = nextPos;
      prevD = D;
    }
    else
    {
      child1.grow(dest);
      child2.grow(dest);
    }
    
    if(frameCount % (floor(random(divRateMin, divRateMax))) == 0)
    {
      if(growing)
        this.divide();
    }
  }
  
  void divide()
  {
    if(growing)
    {
      growing = false;
      float oneChildSize = random(0.2, 0.8);
      child1 = new Branch(curPos, angle+((PI/2)*diverge)+random(-drift, drift), len, wid*oneChildSize, drift, diverge, divRateMin, divRateMax);
      child2 = new Branch(curPos, angle-((PI/2)*diverge)+random(-drift, drift), len, wid*(1-oneChildSize), drift, diverge, divRateMin, divRateMax);
    }
    else
    {
      child1.divide();
      child2.divide();
    }
  }
  
  private void linePV(PVector a, PVector b)
  {
    line(a.x, a.y, b.x, b.y);
  }

}
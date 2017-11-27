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

TODO:
- Color configuration
- Pause growth
- 3D
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
    // TODO: color configuration
    this.clr = color(255, 255, 255, 100);
  }

  // If attractor == null, then the structure growth direction changes randomly.
  public void grow() {
    grow(null);
  }
  
  public void grow(PVector attractor)
  {
    stroke(clr);
    strokeWeight(wid);
    fill(clr);

    if(growing)
    {
      if(attractor != null)
      {
        float diffAngle = atan2((attractor.y - curPos.y), (attractor.x - curPos.x));
        if(diffAngle<0)
          diffAngle = 2*PI + diffAngle;
        angle = 0.95*angle+0.05*diffAngle + random(-drift, drift);
        println("Angle:" + degrees(diffAngle) + "\t" + D);
      }
      else
      {
        angle = angle + random(-drift, drift);
      }
      PVector nextPos = new PVector(curPos.x+len*cos(angle), curPos.y+len*sin(angle));
      linePV(curPos, nextPos);
      println(curPos.x + "\t" + curPos.y + "\t\t" + nextPos.x + "\t" + nextPos.y);
      curPos = nextPos;
    }
    else
    {
      child1.grow(attractor);
      child2.grow(attractor);
    }
    
    if(frameCount % (floor(random(divRateMin, divRateMax))) == 0)
    {
      if(growing)
        this.divide();
    }
  }
  
  private void divide()
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
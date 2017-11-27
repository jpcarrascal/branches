public class Branch {
  Branch child1;
  Branch child2;
  PVector curPos, speed;
  float wid;
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
  private Branch(PVector start, /*float angle, float len,*/ PVector speed, float wid,
                float drift, float diverge, float divRateMin, float divRateMax) {
    this.speed = speed;
    this.curPos = start;
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
//        if(diffAngle<0) diffAngle = 2*PI + diffAngle;
        //angle = 0.95*angle+0.05*diffAngle + random(-drift, drift);
        //angle = 0.95*angle+0.05*diffAngle;

        float D = dist(attractor.x, attractor.y, curPos.x,  curPos.y);
        if(false)
        {
        pushStyle();
        stroke(255,0,0,255);
        strokeWeight(0.5);
        fill(0,0,0,0);
        line(attractor.x, attractor.y, curPos.x,  curPos.y);
        ellipse(attractor.x, attractor.y, D*2, D*2);
        popStyle();
        }
        println("Angle:" + degrees(diffAngle) + "\tD: "  + D);
        speed = PVector.sub(attractor, curPos).normalize().mult(speed.mag());
      }
      else
      {
        //angle = angle + random(-drift, drift);
        speed = PVector.fromAngle(speed.heading() + random(-drift, drift)).mult(speed.mag());
        //speed = PVector.add(speed, randV).normalize().mult(speed.mag());
      }
      //PVector speed = new PVector(len*cos(angle), len*sin(angle));
      
      PVector nextPos = PVector.add(curPos, speed);
      linePV(curPos, nextPos);
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
      println("split!");
    }
  }
  
  private void divide()
  {
    if(growing)
    {
      growing = false;
      float oneChildSize = random(0.2, 0.8);
      PVector speed1 = PVector.fromAngle(speed.heading()+((PI/2)*diverge)+random(-drift, drift)).mult(speed.mag());
      PVector speed2 = PVector.fromAngle(speed.heading()-((PI/2)*diverge)+random(-drift, drift)).mult(speed.mag());
      child1 = new Branch(curPos, /*angle+((PI/2)*diverge)+random(-drift, drift), len,*/ speed1, wid*oneChildSize, drift, diverge, divRateMin, divRateMax);
      child2 = new Branch(curPos, /*angle-((PI/2)*diverge)+random(-drift, drift), len,*/ speed2, wid*(1-oneChildSize), drift, diverge, divRateMin, divRateMax);
    }
    else
    {
      child1.divide();
      child2.divide();
    }
  }
  
  // Helper function for drawing lines between vectors
  private void linePV(PVector a, PVector b)
  {
    line(a.x, a.y, b.x, b.y);
  }

}
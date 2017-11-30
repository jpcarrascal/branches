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
    grow(null, -1);
  }
  // Attractor and gravity
  public void grow(PVector attractor, float g)
  {
    stroke(clr);
    strokeWeight(wid);
    fill(clr);

    if (growing)
    {
      if (attractor != null)
      {
        float D = PVector.dist(curPos, attractor);
        attractor.sub(curPos).normalize().mult(g/(D*D));
        speed = PVector.fromAngle(speed.heading() + random(-drift, drift)).add(attractor).normalize().mult(speed.mag());
      }
      else
      {
        speed = PVector.fromAngle(speed.heading() + random(-drift, drift)).mult(speed.mag());
      }

      PVector nextPos = PVector.add(curPos, speed);
      linePV(curPos, nextPos);
      curPos = nextPos;
    } else
    {
      child1.grow(attractor, g);
      child2.grow(attractor, g);
    }

    if (frameCount % (floor(random(divRateMin, divRateMax))) == 0)
    {
      if (growing)
        this.divide();
    }
  }

  private void divide()
  {
    if (growing)
    {
      growing = false;
      float oneChildSize = random(0.2, 0.8);
      PVector speed1 = PVector.fromAngle(speed.heading()+((PI/2)*diverge)+random(-drift, drift)).mult(speed.mag());
      PVector speed2 = PVector.fromAngle(speed.heading()-((PI/2)*diverge)+random(-drift, drift)).mult(speed.mag());
      child1 = new Branch(curPos, speed1, wid*oneChildSize, drift, diverge, divRateMin, divRateMax);
      child2 = new Branch(curPos, speed2, wid*(1-oneChildSize), drift, diverge, divRateMin, divRateMax);
    } else
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
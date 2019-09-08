Serpent s; 
GestureDetector g;
Rat r; 

void setup () {

  fullScreen();
  background(0);
  s= new Serpent();
  g= new GestureDetector();
  r= new Rat();
}

void draw() { 

  if (s.moving) {
    s.move();
  }
  //background(0);
  fill(255);
  s.display();
  r.display();
  if (s.getSegments()!=null) {
    for (Segment seg : s.getSegments()) {
      fill(color(255, 175, 150));
      seg.display();
      seg.move();
      noFill();
    }
  }
}

void mousePressed() {
  g.initial();
}

void mouseReleased() {
  g.fin();
  if (s.moving == false) {
    s.moving = true;
  }
}


class Serpent {
  PVector location; 
  PVector velocity; 

  int speed = 10;

  boolean moving = false; 

  int lastSwipe = 0;

  ArrayList<Pivot> pivots; 
  ArrayList<Segment> segments;



  Serpent() {
    location = new PVector(width/2, height/2);
    velocity = new PVector(0, 0);
    segments = new ArrayList();
    pivots = new ArrayList();
  }

  void display() { 
    rect(this.location.x, 
      this.location.y, 
      50, 
      50);
  }

  void eat( ) {
    //todo add segment parameters 
    Segment segment = new Segment(reportHeadLocation());
    segments.add(segment);
    // text("segment added", width-500, 100);

    r.move();
  }

  void move() {
    //todo handle arraylist of segments
    switch(lastSwipe) { 
    case 0: 
    case 1: 
      velocity = new PVector(0, -speed); 
      this.location.add(velocity); 
     // s.pivots.add( new Pivot(s.reportHeadLocation(), s.reportHeadVelocity()));
      text("pivot added", 100, 200);
      break; 
    case 2: 
      velocity = new PVector(0, speed);
      this.location.add(velocity);
     // s.pivots.add( new Pivot(s.reportHeadLocation(), s.reportHeadVelocity()));
      text("pivot added", 100, 200);
      break; 
    case 3: 
      velocity = new PVector(-speed, 0); 
      this.location.add(velocity);
     // s.pivots.add( new Pivot(s.reportHeadLocation(), s.reportHeadVelocity()));
      text("pivot added", 100, 200);
      break; 
    case 4: 
      velocity = new PVector(speed, 0); 
      this.location.add(velocity);
     // s.pivots.add( new Pivot(s.reportHeadLocation(), s.reportHeadVelocity()));
      text("pivot added", 100, 200);
      break;
    }

    if ( closeEnough())
    {
      eat();
    }
  }

  PVector reportHeadLocation() { 
    return location;
  }

  PVector reportHeadVelocity() {
    return velocity;
  }

  boolean closeEnough() {
    PVector head, rat; 

    head = reportHeadLocation();
    rat = r.reportLocation();

    if ((abs(head.x - rat.x)<50) && (abs(head.y - rat.y) < 50)) {
      return true;
    } else
    {
      return false;
    }
  }

  int lastSwipe () {
    return lastSwipe;
  }

  ArrayList<Pivot> getPivots() {
    return pivots;
  }

  ArrayList<Segment> getSegments() {
    return segments;
  }
}

class Rat {
  PVector location; 

  Rat() {
    move();
    // display();
  }

  void display() {

    rect(location.x, location.y, 50, 50);
  }

  void move() {
    float x = random(0, width);
    float y = random(0, height); 
    location = new PVector(x, y);
  }

  PVector reportLocation() {
    return location;
  }
}

class GestureDetector {
  int x, y, i, j; 
  int TEXT_LOCATION= 100;
  GestureDetector () {
  }

  void initial() {
    x=mouseX;
    y=mouseY;
  }

  void fin() {
    i=mouseX;
    j=mouseY;

    calculateDrag();
  }

  void calculateDrag() { 

    textSize(70);
    //background(0);

    if ((abs(x-i)>abs(y-j))) {
      if (x>i) { 
        fill(255); 
        text("left swipe", 
          TEXT_LOCATION, 
          TEXT_LOCATION);
        s.lastSwipe=3;
      } else {
        fill(255);
        text("right swipe", 
          TEXT_LOCATION, 
          TEXT_LOCATION);
        s.lastSwipe=4;
      }
    } else {

      if (y>j) { 
        fill(255);
        text("up swipe", 
          TEXT_LOCATION, 
          TEXT_LOCATION);
        s.lastSwipe=1;
      } else {
        fill(255);
        text("down swipe", 
          TEXT_LOCATION, 
          TEXT_LOCATION);
        s.lastSwipe=2;
      }
    }
  }
}

class Segment {
  PVector location;
  PVector velocity;
  PVector lastLocation;
  ArrayList<Pivot> pivots;

  public Segment(PVector l) {
    float x = l.x;
    float y=l.y;
    location= new PVector(x, y);
    pivots = new ArrayList();
  }

  void display() {
    switch(s.lastSwipe()) {
    case 0: 

    case 1:
      rect(location.x, location.y+50, 50, 50);
      break;
    case 2: 
      rect(location.x, location.y-50, 50, 50);
      break;
    case 3: 
      rect(location.x+50, location.y, 50, 50);
      break;
    case 4:
      rect(location.x-50, location.y, 50, 50);
      break;
    }

    // rect(location.x-50, location.y-50, 50, 50);
  }

  void move() {
    setLastLocation(location);
    if (getPivots()!=null){
     for (Pivot p : getPivots()) {
     
    Float x = p.pivotLocation.x-location.x;
    Float y = p.pivotLocation.y-location.y;

    velocity = new PVector(x, y);
    location.add(velocity);

    }
    }
  }

  void setLastLocation(PVector last) {
    lastLocation=last;
  }

  PVector getLastLocation() {
    return lastLocation;
  }
  
  void addPivot(PVector l){
    pivots.add(new Pivot(l));
    }
    
    ArrayList<Pivot> getPivots(){
      return pivots;
      }
}



class Pivot {

  PVector pivotLocation;
 // PVector pivotVelocity;

  public Pivot(PVector l) {
    this.pivotLocation = l;
   // this.pivotVelocity = v;
  }

  PVector getPivotLocation() {
    return pivotLocation;
  }

  //PVector getPivotVelocity() {
   // return pivotVelocity;
  //}
}

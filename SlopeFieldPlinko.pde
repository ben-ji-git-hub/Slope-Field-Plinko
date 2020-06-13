import g4p_controls.*; //<>//
import shiffman.box2d.*;
import org.qscript.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

private int rows, cols, scl, window, level;
private float lineLength, tickLength, charOffset;
private Float slope;
private boolean advanceLevel, timePause;
//public String DiffEQ;
Vec2[][] levelData;

SlopeLine[][] slopeLines;
Script solver;
Ball ball;
Hole hole;
Box2DProcessing box2d;

void setup() {
  size(800, 900, JAVA2D);
  background(0);
  frameRate(60);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();  
  box2d.listenForCollisions();
  createGUI();
  window = 800;
  scl = 50;
  rows = window/scl;
  cols = rows;
  lineLength = .5 * scl;
  tickLength = .2 * scl;
  charOffset = .5 * scl;
  level = 0;
  advanceLevel = false;
  timePause = true;
  //DiffEQ = "-1";

  solver = new Script("");
  slopeLines = new SlopeLine[cols-1][rows-1];
  levelData = new Vec2[6][2];

  levelData[0][0] = new Vec2(window-1/2*scl-30, 0);
  levelData[0][1] = new Vec2(window-1/2*scl-30, window-3/2*scl);

  levelData[1][0] = new Vec2(3*scl, 0);
  levelData[1][1] = new Vec2(9.6*scl, 11*scl);

  levelData[2][0] = new Vec2(10*scl, 0);
  levelData[2][1] = new Vec2(15*scl, 15*scl);

  levelData[3][0] = new Vec2(150, 0);
  levelData[3][1] = new Vec2(150, 0);

  levelData[4][0] = new Vec2(150, 0);
  levelData[4][1] = new Vec2(150, 0);

  ball = new Ball(levelData[level][0].x, 5);
  hole = new Hole(levelData[level][1], 17);
}

void draw() {
  background(0);

  if (!timePause)
    for (int i = 0; i < 1; i++)
      box2d.step();

  if (advanceLevel)
    advanceLevel();

  if (timePause) {
  }

  drawAxes();
  for (int y = 1; y < cols; y++) {
    for (int x = 1; x < rows; x++) {
      if (slopeLines[y-1][x-1] != null)
        slopeLines[y-1][x-1].display();
    }
  }
  ball.display();
  hole.display();
}

void drawAxes() {
  for (int x = 1; x < cols; x++) {
    stroke(25);
    line(0, x*scl, window, x*scl);
    line(x*scl, 0, x*scl, window);
  }
  
  stroke(150);
  line(0, window/2, window, window/2);
  line(window/2, 0, window/2, window);
  
  for (int x = 1; x < cols; x++) {
    noFill();
    stroke(250);
    line(x*scl, (window-tickLength)/2, x*scl, (window+tickLength)/2);
    line((window-tickLength)/2, x*scl, (window+tickLength)/2, x*scl);

    fill(250);
    textSize(10);
    textAlign(CENTER, CENTER);
    if(x != rows/2)
      text(x - rows/2, x*scl, window/2 + charOffset);
    if(x != cols/2)
      text(-x + cols/2, window/2 - charOffset, x*scl);    
  }
  text(0, window/2 - charOffset/2, window/2 + charOffset/2);
  textSize(20);
  text("Current Level:" + level, window/2, scl/2);
  
  textSize(15);
  text("a= " + Math.round(1000.0*a)/1000.0, 100-7*charOffset/4, 868);
  text("b= " + Math.round(1000.0*b)/1000.0, 700+7*charOffset/4, 868);
}

void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  if (o1==null || o2==null)
    return;

  if (o1.getClass() == Ball.class && o2.getClass() == Hole.class) {
    advanceLevel = true;
  }
}

void endContact(Contact cp) {
}

public Float getSlope(String DiffEQ, float x, float y, float a, float b) {
  String[] code = {
    "yprime = " + DiffEQ };

  solver.setCode(code); 
  solver.parse();

  solver.storeVariable("x", x);
  solver.storeVariable("y", y);
  solver.storeVariable("a", a);
  solver.storeVariable("b", b);  

  solver.evaluate();
  return solver.getVariable("yprime").toFloat();
}

void advanceLevel() {
  hole.killBody();
  ball.killBody();
  level++;
  ball = new Ball(levelData[level][0].x, 5);
  hole = new Hole(levelData[level][1], 17);
  advanceLevel = false;
  timePause = true;
}

void resetLevel() {
  hole.killBody();
  ball.killBody();
  ball = new Ball(levelData[level][0].x, 5);
  hole = new Hole(levelData[level][1], 17);
  timePause = true;
}

void generateSlopeField(String DiffEQ, float a, float b) {
  for (int y = 1; y < cols; y++) {
    for (int x = 1; x < rows; x++) {
      int xCartesian = x - rows/2;
      int yCartesian = -y + cols/2;
      slope = getSlope(DiffEQ, xCartesian, yCartesian, a, b);
      //println(slopeLines[y-1][x-1].getClass()); 
        //slopeLines[y-1][x-1].killBody();
      if (slope.toString().equals("NaN"))
        slopeLines[y-1][x-1] = null;
      else {
        slopeLines[y-1][x-1] = new SlopeLine(x*scl, y*scl, slope);
      }
    }
  }
}
void keyPressed() {
  if (key == ' ') //spacebar
    timePause = !timePause;
  //if (key == ENTER) {
  //  timePause = true;
  //  resetLevel();
  //}
}

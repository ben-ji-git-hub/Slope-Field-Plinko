import shiffman.box2d.*; //<>//
import org.qscript.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

private int rows, cols, scl, window, level;
private float lineLength, tickLength, charOffset;
private Float slope;
private boolean advanceLevel, timePause;

Vec2[][] levelData;

SlopeLine[][] slopeLines;
//Ball[] balls;
Script solver;
Ball ball;
Hole hole;
Box2DProcessing box2d;

void setup() {
  size(800, 800);
  background(0);
  frameRate(60);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();  
  box2d.listenForCollisions();

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

  solver = new Script("");
  slopeLines = new SlopeLine[cols-1][rows-1];
  //balls = new Ball[14];
  levelData = new Vec2[6][2];
  drawAxes();  
  for (int y = 1; y < cols; y++) {
    for (int x = 1; x < rows; x++) {
      int xCartesian = x - rows/2;
      int yCartesian = -y + cols/2;
      slope = getSlope("-1", xCartesian, yCartesian);
      if (slope.toString().equals("NaN"))
        slopeLines[y-1][x-1] = null;
      else {
        slopeLines[y-1][x-1] = new SlopeLine(x*scl, y*scl, slope);
        slopeLines[y-1][x-1].display();
      }
    }
  }
  //for(int i = 1; i<=13; i++) {
  //   balls[i] = new Ball(300+3*i, 5); 
  //}

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

  drawAxes();
  for (int y = 1; y < cols; y++) {
    for (int x = 1; x < rows; x++) {
      if (slopeLines[y-1][x-1] != null)
        slopeLines[y-1][x-1].display();
    }
  }
  ball.display();
  //for(int i = 1; i<=13; i++) {
  //   balls[i].display(); 
  //}
  hole.display();
}

void drawAxes() {
  stroke(70);
  textSize(10);
  line(0, window/2, window, window/2);
  line(window/2, 0, window/2, window);
  noFill();
  rect(0, 0, window, window);
  for (int x = 1; x < cols; x++) {
    line(x*scl, (window-tickLength)/2, x*scl, (window+tickLength)/2);
    line((window-tickLength)/2, x*scl, (window+tickLength)/2, x*scl);

    textAlign(CENTER, CENTER);
    text(x - rows/2, x*scl, window/2 + charOffset);
    text(-x + cols/2, window/2 - charOffset, x*scl);
  }
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
  if (o1==null || o2==null) {
    //println(o1.getClass());
    //println(Ball.class);
    //println(o2.getClass());
    return;
  }
  //if (o1.getClass() == Ball.class && o2.getClass() == SlopeLine.class) {
  //  println("collide");
  //  println(o1.getClass());
  //  println(o2.getClass());
  //}
  if (o1.getClass() == Ball.class && o2.getClass() == Hole.class) {
    advanceLevel = true;
  }
}

void endContact(Contact cp) {
}

public Float getSlope(String DiffEQ, float x, float y) {
  String[] code = {
    "yprime = " + DiffEQ };

  solver.setCode(code); 
  solver.parse();

  solver.storeVariable("x", x);
  solver.storeVariable("y", y);  
  solver.evaluate();
  return solver.getVariable("yprime").toFloat();
}

void advanceLevel() {
  hole.killBody();
  ball.killBody();
  ball = new Ball(levelData[level+1][0].x, 5);
  hole = new Hole(levelData[level+1][1], 17);
  level++;
  println("collide");
  advanceLevel = false;
  timePause = true;
}

void keyPressed() {
  if (key == ' '); //spacebar
  timePause = !timePause;
}

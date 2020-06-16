import java.awt.Font; //<>//
import java.awt.*;
import g4p_controls.*;
import shiffman.box2d.*;
import org.qscript.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

int rows, cols, scl, window, level, duckCounter;
float lineLength, tickLength, charOffset, a, b;
Float slope;
boolean advanceLevel, timePause, shiftPressed;
String DiffEQ; 
PFont f;
enum Screens {
  MENU, HELP, CLASSIC_MODE, DUCK_HUNT
}

Vec2[][][][] levelData;
SlopeLine[][] slopeLines;
Duck[] ducks;
Script solver;
Ball ball;
Hole hole;
Screens screen;
Box2DProcessing box2d;

void setup() {
  f = createFont("CAMBRIA MATH", 15);
  size(800, 900, JAVA2D);
  background(0);
  frameRate(60);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();  
  box2d.listenForCollisions();
  createGUI();
  customGUI();
  window = 800;
  scl = 50;
  rows = window/scl;
  cols = rows;
  lineLength = .5 * scl;
  tickLength = .2 * scl;
  charOffset = .5 * scl;
  level = 0;
  duckCounter = 0;
  advanceLevel = false;
  timePause = true;
  DiffEQ = "99999999";

  solver = new Script("");
  slopeLines = new SlopeLine[cols-1][rows-1];
  // ducks = new Duck[5];
  screen = Screens.MENU;

  /*  level data corresponds to: [mode][level][object][velocity]
   /    mode: 0=Classic, 1=Duck Hunt
   /    level: 1-5 for each mode
   /    object: 0=ball, 1=hole, 2-5=ducks
   /    Ball initial Velocity: x and y components of starting velocity
   */  levelData = new Vec2[2][6][6][2];

  levelData[0][0][0][0] = new Vec2(window-3*scl, 15);
  levelData[0][0][1][0] = new Vec2(800-(window-scl-80), window-3/2*scl);

  levelData[0][1][0][0] = new Vec2(3*scl, 15);
  levelData[0][1][1][0] = new Vec2(9.6*scl, 11*scl);

  levelData[0][2][0][0] = new Vec2(10*scl, 15);
  levelData[0][2][1][0] = new Vec2(15*scl, 15*scl);

  levelData[0][3][0][0] = new Vec2(window/2, 15);
  levelData[0][3][1][0] = new Vec2(3*window/4, window/5);

  levelData[0][4][0][0] = new Vec2(scl*7, 15);
  levelData[0][4][1][0] = new Vec2(scl*7, window-scl);
  
  
  
  levelData[0][5][0][0] = new Vec2(window/2, scl*3);
  levelData[0][5][1][0] = new Vec2(window/2, scl);
  
  
  
  levelData[1][0][0][0] = new Vec2(window, scl);
  levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  levelData[1][0][2][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  levelData[1][0][0][1] = new Vec2(-2, 0);


  levelData[1][1][0][0] = new Vec2(3*scl, 0);
  levelData[1][1][1][0] = new Vec2(9.6*scl, 11*scl);
  levelData[1][1][2][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  levelData[1][1][3][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  levelData[1][1][1][1] = new Vec2(5, 5);

  //levelData[1][2][0][0] = new Vec2(10*scl, 0);
  //levelData[1][2][1][0] = new Vec2(15*scl, 15*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);

  //levelData[1][3][0][0] = new Vec2(150, 0);
  //levelData[1][3][1][0] = new Vec2(150, 0);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);

  //levelData[1][4][0][0] = new Vec2(150, 0);
  //levelData[1][4][1][0] = new Vec2(150, 0);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
  //levelData[1][0][1][0] = new Vec2(window-1/2*scl-30, window-3/2*scl);
}

void draw() {
  background(0);
  switch(screen) {

  case MENU:
    break;

  case HELP:
    break;

  case CLASSIC_MODE:
    
    if (!timePause) {
      for (int i = 0; i < 1; i++)
        box2d.step();
    }

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
    hole.display();
    if(level == 5){
        textAlign(CENTER, CENTER);
        textSize(30);
        text("¡BONUS LEVEL!", window/2, 1*window/3);
        textSize(15);
        text("Just Kidding, this level is impossible, except maybe in the upcoming zero-gravity \"Outerspace\" Mode...", window/2, 2*window/3-10);
        text("Anyways, congratulations, you win!", window/2, 2*window/3+scl-10);
        text("Now try replaying the game using an entirely different differential equation for each level!", window/2, 2*window/3+2*scl-10);
        text("Thank you for playing Slope Field Plinko by Benjamin Jiras", window/2, 2*window/3+4*scl-10);
        text("Made in a Processing Java environment.", window/2, 2*window/3+5*scl-10);
        //text("Supporting libraries include BOX2D (physics engine), QScript (equation parser), and G4P (gui creation utility). Learn more at Processing.org", window/2, 2*window/3+5*scl-10);

    }
    break;

  case DUCK_HUNT:
    if (!timePause) {
      for (int i = 0; i < 2; i++)
        box2d.step();
    }

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
    //for (int i = 1; i <= level; i++)
    //  ducks[i].display();
    break;
  }
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
    if (x != rows/2)
      text(x - rows/2, x*scl, window/2 + charOffset);
    if (x != cols/2)
      text(-x + cols/2, window/2 - charOffset, x*scl);
  }
  text(0, window/2 - charOffset/2, window/2 + charOffset/2);
  textSize(15);
  text("Level " + (level+1), 3*scl/2, scl/2);

  textSize(15);
  textFont(f);
  text("a = " + Math.round(1000.0*a)/1000.0, 100-7*charOffset/4, 868);
  text("b = " + Math.round(1000.0*b)/1000.0, 700+7*charOffset/4, 868);
  textSize(25);
  text("y' = ", 100-charOffset, 825);
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
  if (o1.getClass() == SlopeLine.class || o2.getClass() == SlopeLine.class)
    return;
  else {
    advanceLevel = true;
    println(advanceLevel);
  }
  //if (o1.getClass() == Ball.class && o2.getClass() == Duck.class) {
  //  duckCounter++;
  //  ducks[level].killBody();
  //  if (duckCounter == level+1);
  //  advanceLevel();
  //}
}

void endContact(Contact cp) {
}

public Float getSlope(String DiffEQ, float x, float y, float a, float b) {
  String[] code = {
    "yprime = " + DiffEQ };

  solver.setCode(code); 
  try{
  solver.parse();
  }
  catch(Exception e) {
  return 999999.0;
}
  solver.storeVariable("x", x);
  solver.storeVariable("y", y);
  solver.storeVariable("a", a);
  solver.storeVariable("b", b);  

  solver.evaluate();
  return solver.getVariable("yprime").toFloat();
}

void advanceLevel() {
  println("ello");
  level++;
  resetLevel(false);
  advanceLevel = false;
}

void resetLevel(boolean newGame) {
  if (!newGame) {
    ball.killBody();
    if (screen == Screens.CLASSIC_MODE)
      hole.killBody();
  }

  if (screen == Screens.CLASSIC_MODE) {
    ball = new Ball(levelData[0][level][0][0], 5, false);
    hole = new Hole(levelData[0][level][1][0], 17);
  } 

  if (screen == Screens.DUCK_HUNT) {
    duckCounter = 0;
    ball = new Ball(levelData[1][level][0][0], 5, true);
    ball.disableGravity();
    ball.setVelocity(levelData[1][level][0][1]);
    for (int i = 0; i < level; i++) {
      ducks[i].killBody();
      ducks[i] = new Duck(levelData[1][level][i+2][0], 12);
    }
  }

  timePause = true;
}

void generateSlopeField(String DiffEQ, float a, float b) {
   for (int y = 1; y < cols; y++) {
    for (int x = 1; x < rows; x++) {
      int xCartesian = x - rows/2;
      int yCartesian = -y + cols/2;
      if (!DiffEQ.equals(""))
        slope = getSlope(DiffEQ, xCartesian, yCartesian, a, b);
      if (slopeLines[y-1][x-1] != null) {
        slopeLines[y-1][x-1].killBody();
      }
      if (slope.toString().equals("NaN"))
        slopeLines[y-1][x-1] = null;
      else {
        if (screen == Screens.DUCK_HUNT)
          slopeLines[y-1][x-1] = new SlopeLine(x*scl, y*scl, slope, true);
        else
          slopeLines[y-1][x-1] = new SlopeLine(x*scl, y*scl, slope, false);
      }
    }
  }
}
//}
void keyPressed() {
  if (key == ' ') //spacebar
    timePause = !timePause;
  if (keyCode == SHIFT)
    shiftPressed = true;
  if (a>100) a = 100;
  if (a<-100) a = -100;
  if (b>100) b = 100;
  if (b<-100) b = -100;
}

void keyReleased() {
  if (keyCode == SHIFT)
    shiftPressed = false;
  if (keyCode != SHIFT && shiftPressed)
    shiftPressed = true;
  if (!shiftPressed) {
    if (keyCode == DOWN) {
      a = (int) (a-1);
      slider1.setValue((float) Math.cbrt(a-.0001));
      generateSlopeField(DiffEQ, a, b);
    }
    if (keyCode == UP) {
      a = (int) a+1;
      slider1.setValue((float)Math.cbrt(a+.0001));
      generateSlopeField(DiffEQ, a, b);
    }
  }

  if (shiftPressed) {
    if (keyCode == DOWN) {
      b = (int) b-1;
      slider2.setValue((float) Math.cbrt(b-.0001));
      generateSlopeField(DiffEQ, a, b);
    }
    if (keyCode == UP)
    {
      b = (int) b+1;
      slider2.setValue((float) Math.cbrt(b+.0001));
      generateSlopeField(DiffEQ, a, b);
    }
  }
}

String equationCleanup(String EQ) {
  EQ = EQ.replaceAll("ln", "logE");
  //EQ = EQ.replaceAll("-", "-1*");
  return EQ;
  //DiffEQ.replace("e^", "exp(");
  //DiffEQ.replaceFirst("|", "abs(");
  //DiffEQ.replaceFirst("|", ")");
}  

void customGUI() {
  DIFF_EQ.setFont(new Font("Cambria", Font.PLAIN, 20));
  Duck_Hunt.setFont(new Font("Cambria", Font.BOLD, 30));
  Tutorial.setFont(new Font("Cambria", Font.BOLD, 30));
  Classic_Mode.setFont(new Font("Cambria", Font.BOLD, 30));
  textarea1.setFont(new Font("Arial", Font.PLAIN, 22));
  Slope_Field_Plinko_Title.setFont(new Font("Arial", Font.BOLD, 40));
  backButton.setVisible(false);
  slider1.setVisible(false);
  slider2.setVisible(false);
  pauseButton.setVisible(false);
  DIFF_EQ.setVisible(false);
  tutorialText.setVisible(false);
  tutorialText.setFont(new Font("Arial", Font.PLAIN, 16));
  tutorialText.setText("*Once you understand the rules, click on the back arrow and select \"Classic\" Mode (currently, \"Outerspace\" Mode is just experimental and has no objective, but feel free to play around with it!)*\r\n\r\n\r\nNon-Input gameplay elements:\n\nCurrent Level Counter - top left; beat all five levels to win the game.\nPlinko Ball - each level, appears at a different part of the top of the screen. Will fall subject to gravity, and rebound upon impact with slope lines.\nSlope Lines - adaptively generate in the slope field at every integer in the cartesian coordinate plane according to the differential equation.\nHole - get the ball to contact the orange circle to advance to the next level.\r\n\r\n\r\nInput-dependent gameplay elements:\nEquation field - enter the differential equation according to the following syntax rules:\n  Enter symbols into the field as if it were a TI-89 calculator, with a few caveats:\n  - no implicit multiplication (ex, must specify \"x*y\" instead of \"xy\" using an asterisk). This includes negative sign (-) (use -1*x instead of -x). )\n  - Use exp(x) instead of e^x\n  - Use abs(x) instead of |x|\n  - Use asin(x) instead of arcsin(x) (same goes for rest of inverse trig). \n  - Only sin, cos, and tan are supported, and not their reciprocals (ex, type 1/cos(x) instead of sec(x)). \n  - Use either pow(x,2) or x^2, both are acceptable\n  - Use log(2, x), where 2 is base (except use ln(x) instead of log(e, x))\n  - The computer will strictly follow order of operations! When in doubt, use parentheses.\r\n\r\n\r\nVariable sliders - To gain granular control over the exact shape of your slope field, type either \"a\" or \"b\" in the equation field where you would otherwise type a constant (for example, 5*x -> a*x, remembering to use an asterisk for multiplication). Then, drag the circle on the corresponding slider below the equation field to continuously modify the slope field. Note that the value of the variable is proportional to the circle's distance from the center of the slider, cubed. This gives finer control around a = 0 and b = 0, as the field can change dramatically when the variable switches signs. Alternatively, use the \"UP\" and \"DOWN\" arrow keys to move the slider up or down by 1.0, rounded to the nearest integer. Hold the \"SHIFT\" key while pressing \"UP\" or \"DOWN\" to modify variable \"b\", and release shift to modify \"a\".\n\r\n\r Winning the Game: Once you are happy with your equation, its time to unpause time! To start the level physics engine, either click on the play button to the right of the equation box, or click anywhere on the slope field and press spacebar. Watch the ball bounce around the field in awe! If the ball finds its way to the orange \"hole\", congrats! You passed the level! But if the ball manages to get stuck or eventually falls off of the screen, don't worry, just click on the equation text box to reset the level and \"teleport\" the ball back to its original location. Now for the trial-and-error fun! Use your observations about the ball's previous path to modify your equation, or tweak your sliders to get the perfect path on the next go around. Good luck bouncing!");
}

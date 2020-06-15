/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.
 
 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
 // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void DIFF_EQ_changed(GTextField source, GEvent event) { //_CODE_:DIFF_EQ:858581:
  timePause = true;
  println(source);
  resetLevel();
  DiffEQ = equationCleanup(source.getText());
  generateSlopeField(DiffEQ, a, b);
} //_CODE_:DIFF_EQ:858581:

public void slider1_change1(GSlider source, GEvent event) { //_CODE_:slider1:528910:
  a = (float) Math.pow(source.getValueF(), 3.0);
  if (a>99) a=100.00;
  if (a<-99) a=-100.00;
  timePause = true;
  resetLevel();
  generateSlopeField(DiffEQ, a, b);
} //_CODE_:slider1:528910:

public void slider2_change1(GSlider source, GEvent event) { //_CODE_:slider2:623745:
  b = (float) Math.pow(source.getValueF(), 3.0);
  if (b>99) b=100.00;
  if (b<-99) b=-100.00;
  timePause = true;
  resetLevel();
  generateSlopeField(DiffEQ, a, b);
} //_CODE_:slider2:623745:

public void button1_click(GButton source, GEvent event) { //_CODE_:Classic_Mode:315825:
  backButton.setVisible(true);
  source.setVisible(false);
  Duck_Hunt.setVisible(false);
  Help.setVisible(false);
  textarea1.setVisible(false);
  slider1.setVisible(true);
  slider2.setVisible(true);
  Slope_Field_Plinko_Title.setVisible(false);
  DIFF_EQ.setVisible(true);
  DIFF_EQ.setText("");
  screen = Screens.CLASSIC_MODE;
  
  timePause = true;
  resetLevel();
  DiffEQ = "";
  generateSlopeField(DiffEQ, a, b);
} //_CODE_:Classic_Mode:315825:

public void button2_click(GButton source, GEvent event) { //_CODE_:Duck_Hunt:892874:
  backButton.setVisible(true);
  source.setVisible(false);
  Classic_Mode.setVisible(false);
  Help.setVisible(false);
  textarea1.setVisible(false);
  slider1.setVisible(true);
  slider2.setVisible(true);
  DIFF_EQ.setVisible(true);
  Slope_Field_Plinko_Title.setVisible(false);
  DIFF_EQ.setText("");
  screen = Screens.DUCK_HUNT;
  
  timePause = true;
  resetLevel();
  DiffEQ = "";
  generateSlopeField(DiffEQ, a, b);
} //_CODE_:Duck_Hunt:892874:

public void textarea1_change1(GTextArea source, GEvent event) { //_CODE_:textarea1:923498:
} //_CODE_:textarea1:923498:

public void backButton1_click1(GImageButton source, GEvent event) { //_CODE_:backButton:932020:
  source.setVisible(false);
  Duck_Hunt.setVisible(true);
  Classic_Mode.setVisible(true);
  Help.setVisible(true);
  textarea1.setVisible(true);
  screen = Screens.MENU;
  slider1.setVisible(false);
  slider2.setVisible(false);
  DIFF_EQ.setVisible(false);
  textarea1.setText("Welcome to Slope Field Plinko, the first strategic, calculus-based version of everyone's favorite game-show minigame. Use your knowledge differential equations defined in x and y to generate a slope field which will guide the plinko ball to its target! Once you select your game mode, type the differential equation into the box and watch the slope field change before your eyes. Try some familar differential equations first (y'=x, y'=x+y, y'=sin(x)), but don't be afraid to get creative! After all, there are theoretically infinite \"particular\" solutions for every level...  Before playing, read the equation reference to understand how to format mathematical functions in the equation field and how to use the custom variable sliders.");
  
  timePause = true;
  resetLevel();
  DiffEQ = "";
  generateSlopeField(DiffEQ, a, b);
} //_CODE_:backButton:932020:

public void reference_click1(GButton source, GEvent event) { //_CODE_:Help:466569:
  backButton.setVisible(true);
  source.setVisible(false);
  Classic_Mode.setVisible(false);
  Duck_Hunt.setVisible(false);
  textarea1.setVisible(true);
  screen = Screens.HELP;
  slider1.setVisible(false);
  slider2.setVisible(false);
  DIFF_EQ.setVisible(false);
  textarea1.setText("Welcome to Slope Field Plinko, the first strategic, calculus-based version of everyone's favorite game-show minigame. Use your knowledge differential equations defined in x and y to generate a slope field which will guide the plinko ball to its target! Once you select your game mode, type the differential equation into the box and watch the slope field change before your eyes. Try some familar differential equations first (y'=x, y'=x+y, y'=sin(x)), but don't be afraid to get creative! After all, there are theoretically infinite \"particular\" solutions for every level... v Before playing, read the equation reference to understand how to format mathematical functions in the equation field and how to use the custom variable sliders.");
} //_CODE_:Help:466569:

// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  DIFF_EQ = new GTextField(this, 100, 812, 600, 30, G4P.SCROLLBARS_NONE);
  DIFF_EQ.setPromptText("Enter Differential Equation");
  DIFF_EQ.setLocalColorScheme(GCScheme.RED_SCHEME);
  DIFF_EQ.setOpaque(false);
  DIFF_EQ.addEventHandler(this, "DIFF_EQ_changed");
  slider1 = new GSlider(this, 100, 850, 290, 40, 10.0);
  slider1.setLimits(0.0, -4.6415887, 4.6415887);
  slider1.setNbrTicks(999);
  slider1.setNumberFormat(G4P.DECIMAL, 2);
  slider1.setOpaque(false);
  slider1.addEventHandler(this, "slider1_change1");
  slider2 = new GSlider(this, 410, 850, 290, 40, 10.0);
  slider2.setLimits(0.0, -4.6415887, 4.6415887);
  slider2.setNbrTicks(999);
  slider2.setNumberFormat(G4P.DECIMAL, 2);
  slider2.setOpaque(false);
  slider2.addEventHandler(this, "slider2_change1");
  Classic_Mode = new GButton(this, 50, 160, 300, 150);
  Classic_Mode.setText("Classic Mode");
  Classic_Mode.addEventHandler(this, "button1_click");
  Duck_Hunt = new GButton(this, 450, 160, 300, 150);
  Duck_Hunt.setText("Duck Hunt");
  Duck_Hunt.addEventHandler(this, "button2_click");
  Slope_Field_Plinko_Title = new GLabel(this, 150, 50, 500, 40);
  Slope_Field_Plinko_Title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  Slope_Field_Plinko_Title.setText("Slope Field Pl¡nko!");
  Slope_Field_Plinko_Title.setLocalColorScheme(GCScheme.GREEN_SCHEME);
  Slope_Field_Plinko_Title.setOpaque(false);
  textarea1 = new GTextArea(this, 150, 330, 500, 300, G4P.SCROLLBARS_NONE);
  textarea1.setText("Welcome to Slope Field Plinko, the first strategic, calculus-based version of everyone's favorite game-show minigame. Use your knowledge differential equations defined in x and y to generate a slope field which will guide the plinko ball to its target! Once you select your game mode, type the differential equation into the box and watch the slope field change before your eyes. Try some familar differential equations first (y'=x, y'=x+y, y'=sin(x)), but don't be afraid to get creative! After all, there are theoretically infinite \"particular\" solutions for every level...  Before playing, read the equation reference to understand how to format mathematical functions in the equation field and how to use the custom variable sliders.");
  textarea1.setOpaque(true);
  textarea1.addEventHandler(this, "textarea1_change1");
  backButton = new GImageButton(this, 12, 12, 30, 30, new String[] { "155-1554161_left-back-arrow-in-filled-square-button-comments.png", "155-1554161_left-back-arrow-in-filled-square-button-comments.png", "155-1554161_left-back-arrow-in-filled-square-button-comments.png" } );
  backButton.addEventHandler(this, "backButton1_click1");
  Help = new GButton(this, 250, 645, 300, 150);
  Help.setText("Equation Reference");
  Help.addEventHandler(this, "reference_click1");
}

// Variable declarations 
// autogenerated do not edit
GTextField DIFF_EQ; 
GSlider slider1; 
GSlider slider2; 
GButton Classic_Mode; 
GButton Duck_Hunt; 
GLabel Slope_Field_Plinko_Title; 
GTextArea textarea1; 
GImageButton backButton; 
GButton Help; 

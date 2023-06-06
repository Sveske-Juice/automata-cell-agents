CellGrid m_Grid;
Scene m_Scene;
boolean m_Paused = false;
boolean m_MouseInWin = true;
boolean m_ShowDebugWin = true;
int m_SimSpeed = 1;
float m_GenerationTime = 0f; // Time it takes for generation in this frame
int m_Seed = -1; // if m_Seed < 0: use random m_Seed

void setup()
{
  size(990, 1000);
  // frameRate(500);
  m_Grid = new CellGrid();
  m_Scene = new Scene(m_Grid);

  if (m_Seed < 0)
    m_Seed = int(random(0, Integer.MAX_VALUE));

  randomSeed(m_Seed);
}

void draw()
{
  Time.Tick(millis());
  background(255);

  // Validate sim speed
  if (m_SimSpeed < 1) m_SimSpeed = 1;

  /* GRID LOOP. */
  gridLoop();


  // After grid is generated display grid
  m_Grid.display();

  /* SCENE LOOP. */
  sceneLoop();

  // Display animals on top of grid
  m_Scene.display();

  // Show debug window
  if (m_ShowDebugWin)
    showDebugWindow();

  // Show information about hovering cell
  showHoverInfo();
}

void gridLoop()
{
  if (m_Paused)
    return;
  
  
  int currentSimGen = 0; // How many times the m_Grid have been generated this frame
  m_GenerationTime = 0f;
  do {
    // Generate new m_Grid
    m_Grid.generate();
    m_GenerationTime += m_Grid.getGenTime();

  } while (++currentSimGen < m_SimSpeed); // Generate x number of generations this frame depending on the m_SimSpeed
}

void sceneLoop()
{
  if (m_Paused)
    return;
  
  int currentSimGen = 0; // How many times the m_Grid have been generated this frame
  do {
    // Update m_Animals
    m_Scene.update();
  } while (++currentSimGen < m_SimSpeed); // Generate x number of generations this frame depending on the m_SimSpeed 
}

void showHoverInfo()
{
  if (!m_MouseInWin)
    return;
  
  // Get current hovering cell
  Cell hoveringCell = m_Grid.getCellAt(mouseX, mouseY);
  
  // Get current hovering animal
  Animal hoveringAnimal = m_Scene.getAnimalAt(mouseX, mouseY);

  // TODO improvement could be to abstract everything that info can be showed about into an interface

  // Decide if animal info or cell info display should be showed
  if (hoveringAnimal != null)
  {
    showAnimalInfo(hoveringAnimal);
  }
  else if (hoveringCell != null)
  {
    showCellInfo(hoveringCell);
  }
}

void showCellInfo(Cell hoveringCell)
{
  String cellName = hoveringCell.getCellName();
  int cellDepth = hoveringCell.getNeightbourDepth();

  // Create info window
  int elemStep = 25; // padding
  int windowXPos = mouseX + 25; // move so cursor is not blocking view
  int windowYPos = mouseY;

  int winWidth = width / 5;
  int winHeight = height / 7;

  // If window will be out of window border, reposition the window pos
  if (windowXPos + winWidth > width)
    windowXPos = mouseX - winWidth;
  
  if (windowYPos + winHeight > height)
    windowYPos = mouseY - winHeight;

  int currentElem = windowYPos + 5; // start pos

  // background
  fill(25, 25, 25);
  rect(windowXPos, windowYPos, winWidth, winHeight);

  fill(255);
  textAlign(LEFT, TOP);

  // cell name
  textSize(24);
  text(cellName, windowXPos, currentElem);
  currentElem += elemStep;

  // depth 
  textSize(14);
  text("Neighbour search depth: " + cellDepth, windowXPos, currentElem);
  currentElem += elemStep;
}

void showAnimalInfo(Animal hoveringAnimal)
{
  hoveringAnimal.enableDebug();
  String animalName = hoveringAnimal.getName();
  float animalHealth = hoveringAnimal.getHealth();
  float animalWeight = hoveringAnimal.getMass();

  // Create info window
  int elemStep = 25; // padding
  int windowXPos = mouseX + 25; // move so cursor is not blocking view
  int windowYPos = mouseY;

  int winWidth = width / 5;
  int winHeight = height / 7;

  // If window will be out of window border, reposition the window pos
  if (windowXPos + winWidth > width)
    windowXPos = mouseX - winWidth;
  
  if (windowYPos + winHeight > height)
    windowYPos = mouseY - winHeight;

  int currentElem = windowYPos + 5; // start pos

  // background
  fill(25, 25, 25);
  rect(windowXPos, windowYPos, winWidth, winHeight);

  fill(255);
  textAlign(LEFT, TOP);

  // animal name
  textSize(24);
  text(animalName, windowXPos, currentElem);
  currentElem += elemStep;

  // health
  textSize(14);
  text("HP: " + animalHealth, windowXPos, currentElem);
  currentElem += elemStep;

  // mass
  textSize(14);
  text("Mass: " + animalWeight + "kg", windowXPos, currentElem);
  currentElem += elemStep;

  // TODO abstract this
  // prey specific
  if (hoveringAnimal instanceof Prey)
  {
    Prey prey = (Prey) hoveringAnimal;

    // state
    textSize(14);
    text("State: " + prey.getState(), windowXPos, currentElem);
    currentElem += elemStep;

    // nutrition
    textSize(14);
    text("Nutrition: " + prey.getNutrition() + "/" + prey.getMaxNutrition(), windowXPos, currentElem);
    currentElem += elemStep;
  }
}

void showDebugWindow()
{
  rectMode(CORNER);

  int winWidth = 300;
  int windowXPos = width - winWidth;
  int winHeight = 325;
  int windowYPos = 0;
  
  int elemStep = 25; // padding
  int currentElem = windowYPos + 5; // start pos

  fill(25, 25, 25, 225);
  rect(windowXPos, windowYPos, winWidth, winHeight);

  // data
  float frameTime = Time.dt();
  float drawTime = m_Grid.getDrawTime();
  int genCnt = m_Grid.getGenCount();

  // settings
  fill(255);
  textAlign(LEFT, TOP);
  textSize(14);

  // frame time
  text("frametime, dt: " + frameTime + "s" + " ---  FPS: " + frameRate, windowXPos, currentElem);
  currentElem += elemStep;

  // gen time
  text("Generate time: " + m_GenerationTime / 1000 + "s", windowXPos, currentElem);
  currentElem += elemStep;

  // draw time
  text("Draw time: " + drawTime / 1000 + "s", windowXPos, currentElem);
  currentElem += elemStep;

  // scene update time
  text("Scene tick time: " + m_Scene.GetUpdateTime() / 1000 + "s", windowXPos, currentElem);
  currentElem += elemStep;

  // scene draw time 
  text("Scene draw time: " + m_Scene.GetDisplayTime() / 1000 + "s", windowXPos, currentElem);
  currentElem += elemStep;

  // simulation speed
  text("Simulation speed: " + m_SimSpeed + " (use up and down arrow)", windowXPos, currentElem);
  currentElem += elemStep;

  // generation
  text("Generation: " + genCnt, windowXPos, currentElem);
  currentElem += elemStep;

  // m_Seed
  text("m_Seed: " + m_Seed, windowXPos, currentElem);
  currentElem += elemStep;

  // animals in scene / max animals
  text("Animals in scene: " + m_Scene.GetAnimalsInScene() + " / " + m_Scene.GetMaxAnimalsInScene(), windowXPos, currentElem);
  currentElem += elemStep;
  

  fill(220, 140, 25);
  // pause txt
  textAlign(LEFT, BOTTOM);
  text("Pause simulation with 'mouse'", windowXPos, windowYPos + winHeight - elemStep*2);

  // single step txt
  textAlign(LEFT, BOTTOM);
  text("Single step with 'space' in pause", windowXPos, windowYPos + winHeight - elemStep);

  // toggle txt
  textAlign(LEFT, BOTTOM);
  text("Toggle this debug window with 'i' key", windowXPos, windowYPos + winHeight);

}

void mouseReleased()
{
  m_Paused = !m_Paused; 
}

void keyPressed()
{
  // Single step on space down and while its m_Paused
  if (key == 32 && m_Paused)
  {
    m_Grid.singleStep();
    m_Scene.update();
  }
  else if (key == 'i')
    m_ShowDebugWin = !m_ShowDebugWin;
  else if (keyCode == UP)
    m_SimSpeed++;
  else if (keyCode == DOWN)
    m_SimSpeed--;
}

void mouseEntered()
{
  m_MouseInWin = true;
}

void mouseExited()
{
  m_MouseInWin = false;
}

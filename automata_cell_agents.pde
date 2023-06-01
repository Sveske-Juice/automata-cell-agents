CellGrid grid;
ArrayList<Animal> animals = new ArrayList<Animal>();
boolean paused = false;
boolean mouseInWin = true;
boolean showDebugWin = true;
int simSpeed = 1;
float generationTime = 0f; // Time it takes for generation in this frame
int seed = -1; // if seed < 0: use random seed

void setup()
{
  size(990, 1000);
  // frameRate(500);
  grid = new CellGrid();
  animals.add(new Prey("prey test"));

  if (seed < 0)
    seed = int(random(0, Integer.MAX_VALUE));

  randomSeed(seed);
}

void draw()
{
  Time.Tick(millis());
  background(255);

  // Validate sim speed
  if (simSpeed < 1) simSpeed = 1;

  if (!paused)
  {
    int currentSimGen = 0; // How many times the grid have been generated this frame
    generationTime = 0f;
    do {
      // Generate new grid
      grid.generate();
      generationTime += grid.getGenTime();

      // Update animals
      for (int i = 0; i < animals.size(); i++)
      {
        // TODO give info about grid
        animals.get(i).update();
      }
    } while (++currentSimGen < simSpeed); // Generate x number of generations this frame depending on the simspeed
  }

  grid.display();

  // Show debug window
  if (showDebugWin)
    showDebugWindow();

  // Show information about hovering cell
  showCellInfo();
}

void showCellInfo()
{
  if (!mouseInWin)
    return;
  
  // Get current hovering cell
  Cell hoveringCell = grid.getCellAt(mouseX, mouseY);
  if (hoveringCell == null)
    return;
  
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

void showDebugWindow()
{
  int winWidth = 300;
  int windowXPos = width - winWidth;
  int winHeight = 275;
  int windowYPos = 0;
  
  int elemStep = 25; // padding
  int currentElem = windowYPos + 5; // start pos

  fill(25, 25, 25, 225);
  rect(windowXPos, windowYPos, winWidth, winHeight);

  // data
  float frameTime = Time.dt();
  float drawTime = grid.getDrawTime();
  int genCnt = grid.getGenCount();

  // settings
  fill(255);
  textAlign(LEFT, TOP);
  textSize(14);

  // frame time
  text("frametime, dt: " + frameTime + "s" + " ---  FPS: " + frameRate, windowXPos, currentElem);
  currentElem += elemStep;

  // gen time
  text("Generate time: " + generationTime / 1000 + "s", windowXPos, currentElem);
  currentElem += elemStep;

  // draw time
  text("Draw time: " + drawTime / 1000 + "s", windowXPos, currentElem);
  currentElem += elemStep;

  // simulation speed
  text("Simulation speed: " + simSpeed + " (use up and down arrow)", windowXPos, currentElem);
  currentElem += elemStep;

  // generation
  text("Generation: " + genCnt, windowXPos, currentElem);
  currentElem += elemStep;

  // seed
  text("Seed: " + seed, windowXPos, currentElem);
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
  paused = !paused; 
}

void keyPressed()
{
  // Single step on space down and while its paused
  if (key == 32 && paused)
  {
    grid.singleStep();
  }
  else if (key == 'i')
    showDebugWin = !showDebugWin;
  else if (keyCode == UP)
    simSpeed++;
  else if (keyCode == DOWN)
    simSpeed--;
}

void mouseEntered()
{
  mouseInWin = true;
}

void mouseExited()
{
  mouseInWin = false;
}
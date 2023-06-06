import java.util.Map;

class CellGrid {

  /// How many pixels each cell should fill on the screen
  private int m_CellPxSize = 50;

  // Stores how many colums and rows there are in the cell m_Grid
  private int m_Cols, m_Rows;

  // Store 2D array representing the cell m_Grid
  private Cell[][] m_Grid;

  // Millis it takes for a generation to be generated
  private float m_GenerationTime = 0f;

  private int m_GenerationCount = 0;

  // Millis it takes for a generation to be generated
  private float m_DrawTime = 0f;

  CellGrid() {
    m_Cols = width / m_CellPxSize;
    m_Rows = height / m_CellPxSize;

    m_Grid = new Cell[m_Rows][m_Cols];

    // Initialize cell m_Grid
    init();
  }

  /// Translates the pixel coordinates to array indices and return the cell. If its out of bounds return null
  public Cell getCellAt(int xPos, int yPos)
  {
    // colums is y cords and rows is x cords
    int row = yPos / m_CellPxSize;
    int col = xPos / m_CellPxSize;

    if (row >= m_Rows || col >= m_Cols)
      return null;

    return m_Grid[row][col];
  }

  public void setCellAt(Cell cell, int xPos, int yPos)
  {
    // colums is y cords and rows is x cords
    int row = yPos / m_CellPxSize;
    int col = xPos / m_CellPxSize;

    if (row >= m_Rows || col >= m_Cols)
      return;

    m_Grid[row][col] = cell;
  }

  // Translates world/pixel position to index into the cell grid
  public ZVector translateWP2Idx(ZVector WP)
  {
    return new ZVector((int) WP.y / m_CellPxSize, (int) WP.x / m_CellPxSize);
  }

  // Translates idx postiion to world/pixel position. inverse of translateWP2Idx.
  public ZVector translateIdx2WP(ZVector Idx)
  {
    return new ZVector(Idx.y * m_CellPxSize, Idx.x * m_CellPxSize);
  }

  public ZVector getWPCenterOfCell(ZVector cellWPPosition)
  {
    return cellWPPosition.add(new ZVector(m_CellPxSize / 2, m_CellPxSize / 2));
  }

  float getGenTime() { return m_GenerationTime; }
  float getDrawTime() { return m_DrawTime; }
  int getGenCount() { return m_GenerationCount; }
  int getCellSize() { return m_CellPxSize; }

  void init()
  {
    for (int i = 0; i < m_Rows; i++)
    {
      for (int j = 0; j < m_Cols; j++)
      {
        // 1 out of 50 chance of grass cell at start
        int rand = int(random(0, 50));
        if (rand == 0)
          m_Grid[i][j] = new GrassCell();
        else if (rand == 1)
          m_Grid[i][j] = new WaterCell();
        else
          m_Grid[i][j] = new DirtCell();
      }
    }
  }

  /// Generates a new generation of cells based on the current
  void generate()
  {
    float startTime = millis();
    Cell[][] nextGrid = new Cell[m_Rows][m_Cols];

    for (int row = 0; row < m_Rows; row++)
    {
      for (int col = 0; col < m_Cols; col++)
      {
        Cell currentCell = m_Grid[row][col];
        int depth = currentCell.getNeightbourDepth();
        HashMap<CellType, Integer> neighbours = getNeighbours(row, col, depth);

        // Subtract cell's own value from neighbours
        int quantity = neighbours.get(m_Grid[row][col].getCellType());
        neighbours.put(m_Grid[row][col].getCellType(), --quantity);

        m_Grid[row][col].increaseLifeTime();

        // Rules of Life
        Cell newCell = m_Grid[row][col].updateState(neighbours);
        if (newCell == null) // Same cell survived: Stasis
          nextGrid[row][col] = m_Grid[row][col];
        else
          nextGrid[row][col] = newCell;
      }
    }

    m_Grid = nextGrid;
    m_GenerationTime = millis() - startTime;
    m_GenerationCount++;
  }

  /// Display the cell m_Grid
  void display()
  {
    float startTime = millis();
    for (int i = 0; i < m_Rows; i++)
    {
      for (int j = 0; j < m_Cols; j++)
      {
        // x-cord is column (j) and y-cord is row (i)
        m_Grid[i][j].display(j, i, m_CellPxSize);
      }
    }
    m_DrawTime = millis() - startTime;
  }

  void singleStep()
  {
    generate();
  }

  // Gets a hashmap which maps a quantity of cells to a specific cell type from a center position and a depth from that center
  HashMap<CellType, Integer> getNeighbours(int row, int col, int depth)
  {
    HashMap<CellType, Integer> neighbours = new HashMap<CellType, Integer>();
    // Generate hashmap that maps cell types to the amount of those spotted as neighbours
    for (int i = -depth; i <= depth; i++)
    {
      for (int j = -depth; j <= depth; j++)
      {
        int neighbourRow = i + row;
        int neighbourCol = j + col;

        if (neighbourRow < 0 || neighbourRow >= m_Rows)
          continue;

        if (neighbourCol < 0 || neighbourCol >= m_Cols)
          continue;
        
        Cell cell = m_Grid[neighbourRow][neighbourCol];
        Integer qauntity = neighbours.get(cell.getCellType());

        if (qauntity != null)
          neighbours.put(cell.getCellType(), ++qauntity);
        else
          neighbours.put(cell.getCellType(), 1);
      }
    }
    return neighbours;
  }

  // Gets a list tuples which map cell types to the idx position of that celltype in a search area.
  ArrayList<Tuple<CellType, ZVector>> getNeighbourLocations(int row, int col, int depth)
  {
    ArrayList<Tuple<CellType, ZVector>> neighbours = new ArrayList<Tuple<CellType, ZVector>>();

    // Generate hashmap that maps cell types to the amount of those spotted as neighbours
    for (int i = -depth; i <= depth; i++)
    {
      for (int j = -depth; j <= depth; j++)
      {
        int neighbourRow = i + row;
        int neighbourCol = j + col;

        if (neighbourRow < 0 || neighbourRow >= m_Rows)
          continue;

        if (neighbourCol < 0 || neighbourCol >= m_Cols)
          continue;
        
        Cell cell = m_Grid[neighbourRow][neighbourCol];

        neighbours.add(new Tuple<CellType, ZVector>(cell.getCellType(), new ZVector(neighbourRow, neighbourCol)));
      }
    }
    return neighbours;
  }
}
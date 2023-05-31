public abstract class Cell
{
    protected color m_Color = color(255, 0, 200); // Default to pink
    protected String m_Name = "Default Cell";

    /// Stores the lifetime of the cell. Specifically how many generations the cell have survived.
    protected int m_LifeTime = 0;

    /// Decides the depth of how many neighbours this cell depends on. 1 means it's the very near neighbours
    protected int m_NeighbourDepth = 1;

    public int getNeightbourDepth() { return m_NeighbourDepth; }
    public void increaseLifeTime() { m_LifeTime++; }
    public String getCellName() { return m_Name; }
    public color getColor() { return m_Color; }

    public abstract CellType getCellType();
    public abstract Cell updateState(HashMap<CellType, Integer> neighbours);

    public void display(int x, int y, int cellPxSize)
    {
        fill(m_Color);
        stroke(0);

        rect(x * cellPxSize, y * cellPxSize, cellPxSize, cellPxSize);
    }

    /// Calculates and returns the amount of neighbours around this cell based on what it's search depth is.
    /// If for example percent is 0.5, then half of the count of neighbours are returned etc. percent is normalized.
    /// Result is floored (rounded down to nearest integer)
    /// Uses formula: neighbours = (2n+1)^2 - 1
    protected int getNeighbourByPercent(float percent)
    {
        return (int) (((2*m_NeighbourDepth+1)*(2*m_NeighbourDepth+1) - 1) * percent);
    }
}
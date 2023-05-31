public class ObsidianCell extends Cell
{
    ObsidianCell()
    {
        m_Color = color(20, 5, 25); // Very dark purple
        m_Name = "Obsidian Cell";
    }

    @Override CellType getCellType() { return CellType.OBSIDIAN; }

    @Override
    public Cell updateState(HashMap<CellType, Integer> neighbours)
    {
        return null;
    }
}
public class AshCell extends Cell
{
    AshCell()
    {
        m_Color = color(100, 100, 100); // Grey
        m_NeighbourDepth = 2;
        m_Name = "Ash Cell";
    }

    @Override CellType getCellType() { return CellType.ASH; }

    @Override
    public Cell updateState(HashMap<CellType, Integer> neighbours)
    {
        // Transform to obsidian if over half of neighbours are also ash
        Integer ashQuantity = neighbours.get(CellType.ASH);
        if (ashQuantity != null)
        {
            if (ashQuantity >= getNeighbourByPercent(1f))
                return new ObsidianCell();
        }

        if (m_LifeTime > 1000)
        {
            return int(random(0, 1000)) == 0 ? new DirtCell() : null;
        }

        return null;
    }
}
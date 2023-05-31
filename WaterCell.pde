public class WaterCell extends Cell
{
    WaterCell()
    {
        m_Color = color(30, 110, 255); // Blue
        m_Name = "Water Cell";
    }

    @Override CellType getCellType() { return CellType.WATER; }

    @Override
    public Cell updateState(HashMap<CellType, Integer> neighbours)
    {
        return null;
    }
}
public class AppleCell extends Cell
{
    AppleCell()
    {
        m_Color = color(255, 15, 80); // apple color :)
        m_Name = "Apple Cell";
    }

    @Override CellType getCellType() { return CellType.APPLE; }

    @Override
    public Cell updateState(HashMap<CellType, Integer> neighbours)
    {
        return null;
    }
}
public class DirtCell extends Cell
{
    DirtCell()
    {
        m_Color = color(90, 70, 25); // brown color
        m_Name = "Dirt Cell";
    }

    @Override CellType getCellType() { return CellType.DIRT; }

    @Override
    public Cell updateState(HashMap<CellType, Integer> neighbours)
    {
        // If at least one grass block is close then have chance of becoming grass
        Integer grassQuantity = neighbours.get(CellType.GRASS);
        if (grassQuantity != null)
        {
            return int(random(0, 150)) == 0 ? new GrassCell() : null;
        }

        Integer waterQuantity = neighbours.get(CellType.WATER);
        if (waterQuantity != null) // Water source nearby
        {
            return int(random(0, 50)) == 0 ? new GrassCell() : null;
        }
        return null;
    }

}

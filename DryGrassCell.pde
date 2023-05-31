public class DryGrassCell extends Cell
{
    DryGrassCell()
    {
        m_Color = color(160, 170, 14); // Yellowish greeen color
        m_NeighbourDepth = 3;
        m_Name = "Dry Grass Cell";
    }

    @Override CellType getCellType() { return CellType.DRYGRASS; }

    @Override
    public Cell updateState(HashMap<CellType, Integer> neighbours)
    {
        // Start fire, if there's alot of dry grass near
        Integer dryGrassQuantity = neighbours.get(CellType.DRYGRASS);
        if (dryGrassQuantity != null)
        {
            if (dryGrassQuantity >= getNeighbourByPercent(0.8f))
            {
                return int(random(0, 500)) == 0 ? new FireCell() : null;
            }
        }

        // Spread fire if there's fire nearby
        Integer fireQuantity = neighbours.get(CellType.FIRE);
        if (fireQuantity != null)
        {
            if (fireQuantity > 0)
            {
                return int(random(0, 600)) == 0 ? new FireCell() : null;
            }
        }
        return null;
    }
}
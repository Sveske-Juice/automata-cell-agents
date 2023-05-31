public class FireCell extends Cell
{
    private color m_Orange = color(200, 115, 10);
    private color m_Yellow = color(230, 220, 20);
    private int m_TimeSinceColorChange = 0;
    private int m_ChangeColorThreshold = 5;

    FireCell()
    {
        m_Color = m_Orange; // Orange
        m_Name = "Fire Cell";
    }

    @Override CellType getCellType() { return CellType.FIRE; }

    @Override
    public Cell updateState(HashMap<CellType, Integer> neighbours)
    {
        // Toggle color
        if (m_TimeSinceColorChange > m_ChangeColorThreshold)
        {
            if (m_Color == m_Orange)
                m_Color = m_Yellow;
            else
                m_Color = m_Orange;

            m_TimeSinceColorChange = 0;
        }

        m_TimeSinceColorChange++;

        // Kill fire if it has been alive for too long
        if (m_LifeTime > 200)
        {
            return new AshCell();
        }

        // If theres to much fire nearby, then the fire choke and die, leaving ash
        Integer fireQuantity = neighbours.get(CellType.FIRE);
        if (fireQuantity != null)
        {
            if (fireQuantity > 7)
                return new AshCell();    
        }

        return null;
    }
}
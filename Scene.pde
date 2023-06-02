public class Scene
{
    private CellGrid m_Grid;

    private ArrayList<Animal> m_Animals = new ArrayList<Animal>();
    private ArrayList<Animal> m_Animals2Destroy = new ArrayList<Animal>();
    private float m_ScreenWrappingEpsilon = 1f;

    public CellGrid getGrid() { return m_Grid; }

    public Scene(CellGrid grid)
    {
        m_Grid = grid;
        m_Animals.add(new Prey("prey test"));
        init();
    }

    public void init()
    {
        for (int i = 0; i < m_Animals.size(); i++)
        {
            m_Animals.get(i).SetGameScene(this);
            m_Animals.get(i).setup();
        }
    }

    public void update()
    {
        for (int i = 0; i < m_Animals.size(); i++)
        {
            Animal animal = m_Animals.get(i);
            animal.SetCellStandingOn(m_Grid.getCellAt((int) animal.GetPosition().x, (int) animal.GetPosition().y));
            animal.update();
        }

        keepAnimalsWithinBounds();

        for (int i = 0; i < m_Animals2Destroy.size(); i++)
        {
            m_Animals.remove(m_Animals2Destroy.get(i));
        }

        m_Animals2Destroy.clear();
    }

    public void display()
    {
        for (int i = 0; i < m_Animals.size(); i++)
        {
            m_Animals.get(i).display();
        }
    }

    private void keepAnimalsWithinBounds()
    {
        // Check for each animal if they are within screen dimensions
        for (int i = 0; i < m_Animals.size(); i++)
        {
            Animal animal = m_Animals.get(i);
            ZVector center = animal.getCenter();
            ZVector halfExtents = animal.getHalfExtents();

            // top side
            if (center.y - halfExtents.y < 0f)
            {
                animal.SetPostion(new ZVector(center.x, height - halfExtents.y - m_ScreenWrappingEpsilon));
            }
            // bottom side
            else if (center.y + halfExtents.y > height)
            {
                animal.SetPostion(new ZVector(center.x, halfExtents.y + m_ScreenWrappingEpsilon));
            }

            // right side
            if (center.x - halfExtents.x < 0f)
            {
                animal.SetPostion(new ZVector(width - halfExtents.x - m_ScreenWrappingEpsilon, center.y));
            }
            // left side
            else if (center.x + halfExtents.x > width)
            {
                animal.SetPostion(new ZVector(halfExtents.x + m_ScreenWrappingEpsilon, center.y));
            }
        }
    }

    public void DestroyAnimal(Animal animal)
    {
        m_Animals2Destroy.add(animal); // add animal to destruction queue
    }

    // Does a simple point overlap to see if any animals are at (xPos, yPos)
    public Animal getAnimalAt(int xPos, int yPos)
    {
        for (int i = 0; i < m_Animals.size(); i++)
        {
            if (pointOverlap(xPos, yPos, (IObjectWithBounds) m_Animals.get(i)))
                return m_Animals.get(i);
        }
        return null;
    }

    // Simple point vs AABB
    public boolean pointOverlap(int xPos, int yPos, IObjectWithBounds bounds)
    {
        ZVector point = new ZVector(xPos, yPos);
        ZVector center = bounds.getCenter();
        ZVector halfExtents = bounds.getHalfExtents();

        if (point.x < center.x - halfExtents.x)
            return false;
        
        if (point.x > center.x + halfExtents.x)
            return false;

        if (point.y < center.y - halfExtents.y)
            return false;

        if (point.y > center.y + halfExtents.y)
            return false;
        
        return true;
    }
}
public class Scene
{
    private CellGrid m_Grid;

    private ArrayList<Animal> m_Animals = new ArrayList<Animal>();
    private ArrayList<Animal> m_Animals2Destroy = new ArrayList<Animal>();
    private float m_ScreenWrappingEpsilon = 1f;
    private boolean m_SimStarted = false; // true after init() is called (the sim is started)
    private int m_AnimalsInScene = 0;
    private int m_MaxAnimalsInScene = 25;
    private float m_UpdateTime = 0f;
    private float m_DisplayTime = 0f;

    public CellGrid getGrid() { return m_Grid; }

    public int GetAnimalsInScene() { return m_AnimalsInScene; }
    public int GetMaxAnimalsInScene() { return m_MaxAnimalsInScene; }
    public float GetUpdateTime() { return m_UpdateTime; }
    public float GetDisplayTime() { return m_DisplayTime; }

    public Scene(CellGrid grid)
    {
        m_Grid = grid;
        addAnimal(new Prey("Original Prey"), new ZVector(random(0, width), random(0, height)));
        addAnimal(new Predator("Original Predator"), new ZVector(random(0, width), random(0, height)));
        init();
    }

    public void init()
    {
        for (int i = 0; i < m_Animals.size(); i++)
        {
            m_Animals.get(i).SetGameScene(this);
            m_Animals.get(i).setup();
        }

        m_SimStarted = true;
    }

    public void update()
    {
        float start = millis();
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
        m_UpdateTime = millis() - start;
    }

    public void display()
    {
        float start = millis();
        for (int i = 0; i < m_Animals.size(); i++)
        {
            m_Animals.get(i).display();
        }

        m_DisplayTime = millis() - start;
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
                animal.SetPosition(new ZVector(center.x, height - halfExtents.y - m_ScreenWrappingEpsilon));
            }
            // bottom side
            else if (center.y + halfExtents.y > height)
            {
                animal.SetPosition(new ZVector(center.x, halfExtents.y + m_ScreenWrappingEpsilon));
            }

            // right side
            if (center.x - halfExtents.x < 0f)
            {
                animal.SetPosition(new ZVector(width - halfExtents.x - m_ScreenWrappingEpsilon, center.y));
            }
            // left side
            else if (center.x + halfExtents.x > width)
            {
                animal.SetPosition(new ZVector(halfExtents.x + m_ScreenWrappingEpsilon, center.y));
            }
        }
    }

    public void DestroyAnimal(Animal animal)
    {
        m_Animals2Destroy.add(animal); // add animal to destruction queue
        m_AnimalsInScene--;
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

    // AABB vs AABB
    public boolean AABBvsAABB(IObjectWithBounds aabb1, IObjectWithBounds aabb2)
    {
      ZVector rangePos = aabb2.getCenter();
      ZVector rangeSize = aabb2.getHalfExtents();
      return !( aabb1.getCenter().x > rangePos.x + rangeSize.x || 
            aabb1.getCenter().x + aabb1.getHalfExtents().x < rangePos.x ||
            aabb1.getCenter().y > rangePos.y + rangeSize.y ||
            aabb1.getCenter().y + aabb1.getHalfExtents().y < rangePos.y);
    }

    public void addAnimal(Animal animal, ZVector pos)
    {
        if (m_AnimalsInScene >= m_MaxAnimalsInScene)
            return;

        m_Animals.add(animal);
        m_AnimalsInScene++;

        animal.SetPosition(pos);

        if (m_SimStarted)
        {
            animal.SetGameScene(this);
            animal.setup();
        }
    }

    public <T extends Animal> T getClosestAnimalOfType(Class<T> type, ZVector position)
    {
      float closestDist = Float.MAX_VALUE;
      Animal closestAnimal = null;
      
      for (int i = 0; i < m_Animals.size(); i++)
      {
        float dist = ZVector.sub(m_Animals.get(i).GetPosition(), position).mag();
        if (dist >= closestDist)
          continue;

        if (!type.isAssignableFrom(m_Animals.get(i).getClass()))
          continue;

        closestDist = dist;
        closestAnimal = m_Animals.get(i);
      }
      
      if (closestAnimal != null)
        return type.cast(closestAnimal);
      return null;
    }
}

public class Scene
{
    private ArrayList<Animal> m_Animals = new ArrayList<Animal>();
    private float m_ScreenWrappingEpsilon = 1f;

    public Scene()
    {
        m_Animals.add(new Prey("prey test"));
    }

    public void update()
    {
        for (int i = 0; i < m_Animals.size(); i++)
        {
            // TODO give info about m_Grid
            m_Animals.get(i).update();
        }

        keepAnimalsWithinBounds();
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
}
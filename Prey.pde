public class Prey extends Animal
{
    private PreyState m_State = PreyState.WANDER;

    public Prey(String name)
    {
        m_Name = name;
    }

    @Override
    public void setup()
    {
        m_Sprite = loadShape("prey.svg");
        m_HalfExtents = new ZVector(m_Sprite.width, m_Sprite.height);
    }

    @Override
    public void update()
    {
        switch (m_State)
        {
            case WANDER:
                m_CurrentMovementSpeed = m_WanderMovementSpeed;
                wander();
                break;

            default:
                break;
        }
    }

    @Override
    public ZVector getCenter() { return m_Position; }

    @Override
    public ZVector getHalfExtents() { return new ZVector(50, 20); }
}
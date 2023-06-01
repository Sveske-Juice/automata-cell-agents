public class Prey extends Animal
{
    private PreyState m_State = PreyState.WANDER;

    public Prey(String name)
    {
        m_Name = name;
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
}
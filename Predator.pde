public class Predator extends Animal
{
  private PredatorState m_State = PredatorState.WANDER;

  public PredatorState getState() { return m_State; }

  public Predator(String name)
  {
    m_Name = name;
  }

  @Override
  public void setup()
  {
    super.setup();

    m_Sprite = loadShape("predator.svg");
  }

  @Override
  public void update()
  {
    super.update();

    switch (m_State)
    {
      case WANDER:
        m_CurrentMovementSpeed = m_WanderMovementSpeed;
        wander();
        break;
    }
  }

  @Override
  public ZVector getCenter() { return m_Position; }

  @Override
  public ZVector getHalfExtents() { return new ZVector(50, 20); }
}

public class Predator extends Animal
{
  private PredatorState m_State = PredatorState.WANDER;
  private float m_HuntMovementSpeed = 20f;
  private Prey m_TargetedPrey;
  private float m_HuntRadius = 25f;

  private boolean m_ShowHuntRadius = false;

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

    checkForHunt();

    switch (m_State)
    {
      case WANDER:
        m_CurrentMovementSpeed = m_WanderMovementSpeed;
        wander();
        break;

      case HUNT:
        m_CurrentMovementSpeed = m_HuntMovementSpeed;
        seek(m_TargetedPrey.GetPosition());
        break;

    }
  }

  @Override
  public void enableDebug()
  {
    super.enableDebug();

    m_ShowHuntRadius = true;
  }


  @Override
  public void disableDebug()
  {
    super.disableDebug();

    m_ShowHuntRadius = false;
  }

  @Override
  public ZVector getCenter() { return m_Position; }

  @Override
  public ZVector getHalfExtents() { return new ZVector(50, 20); }

  private void checkForHunt()
  {
    if (m_ShowHuntRadius)
    {
      fill(0, 0, 0, 100);
      circle(m_Position.x, m_Position.y, m_HuntRadius*2);
    }

    // Check if a prey is nearby and if so, switch state to HUNT
    Prey closest = m_Scene.getClosestAnimalOfType(Prey.class, m_Position);
    if (closest == null)
    {
      m_State = PredatorState.WANDER;
      return;
    }

    // Validate that closest prey is within hunt radius
    if (ZVector.sub(closest.GetPosition(), m_Position).mag() > m_HuntRadius)
      return;

    m_State = PredatorState.HUNT;
    m_TargetedPrey = closest;
  }
}

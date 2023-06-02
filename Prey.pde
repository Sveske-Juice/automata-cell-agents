public class Prey extends Animal
{
    private PreyState m_State = PreyState.WANDER;
    private float m_Nutrition = 100f;
    private float m_NutritionMax = 100f;
    private float m_NutritionGainFromApple = 40f;
    private float m_NutritionLossPrSecond = 2f;

    public Prey(String name)
    {
        m_Name = name;
    }

    @Override
    public void setup()
    {
        super.setup();

        m_Sprite = loadShape("prey.svg");

        m_HalfExtents = new ZVector(m_Sprite.width, m_Sprite.height);
    }

    @Override
    public void update()
    {
        super.update();
        
        subNutrition(m_NutritionLossPrSecond * Time.dt());

        if (m_StandingOnCell != null)
        {
            if (m_StandingOnCell.getCellType() == CellType.APPLE)
            {
                addNutrition(m_NutritionGainFromApple);
                m_Scene.getGrid().setCellAt(new GrassCell(), (int) getCenter().x, (int) getCenter().y);
            }
        }

        println("nut: " + m_Nutrition);

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

    private void subNutrition(float amt)
    {
        m_Nutrition -= amt;
        if (m_Nutrition <= 0f) // Dies of hunger
        {
            m_GameScene.DestroyAnimal(this);
        }
    }

    private void addNutrition(float amt)
    {
        m_Nutrition += amt;
        if (m_Nutrition > m_NutritionMax)
            m_Nutrition = m_NutritionMax;
    }
}
public class Prey extends Animal
{
    private PreyState m_State = PreyState.WANDER;
    private float m_Nutrition = 100f;
    private float m_NutritionMax = 100f;
    private float m_NutritionGainFromApple = 40f;
    private float m_NutritionLossPrSecond = 2f;
    private float m_SplitNutritionPercent = 0.75f; // How much percent of nutrition does the prey need to have before it can split
    private float m_SplitCooldown = 8f; // Minimum time before it can split again
    private float m_TimeSinceSplit = 0f; 
    private int m_SeachRadius = 4;
    private boolean m_ShowChaseFoodInfo = false;
    private boolean m_ShowSearchRadius = false;

    public PreyState getState() { return m_State; }
    public float getNutrition() { return m_Nutrition; }
    public float getMaxNutrition() { return m_NutritionMax; }

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
    public void enableDebug()
    {
      super.enableDebug();

      m_ShowSearchRadius = true;
      m_ShowChaseFoodInfo = true;
    }

    @Override
    public void disableDebug()
    {
      super.disableDebug();

      m_ShowSearchRadius = false;
      m_ShowChaseFoodInfo = false;
    }

    @Override
    public void update()
    {
        super.update();

        handleSplitting();

        ZVector translatedPos = m_GameScene.getGrid().translateWP2Idx(m_Position);

        // Get a vector to every cell type in a radius of m_SeachRadius
        ArrayList<Tuple<CellType, ZVector>> neigbours = m_GameScene.getGrid().getNeighbourLocations((int) translatedPos.x, (int) translatedPos.y, m_SeachRadius);
        ArrayList<ZVector> apples = new ArrayList<ZVector>();

        // Filter for all the apples
        for (int i = 0; i < neigbours.size(); i++)
        {
            if (neigbours.get(i).x == CellType.APPLE)
                apples.add(neigbours.get(i).y);
        }

        // Find the dir vector towards closest apple
        ZVector appleIdxPos = ZVector.getShortest(apples);
        ZVector applePos = new ZVector();
        
        if (appleIdxPos != null)
        {
            applePos = m_GameScene.getGrid().getWPCenterOfCell(m_GameScene.getGrid().translateIdx2WP(appleIdxPos));
            m_State = PreyState.CHASE_FOOD;
        }
        else
        {
            m_State = PreyState.WANDER;
        }
        
        subNutrition(m_NutritionLossPrSecond * Time.dt());

        if (m_StandingOnCell != null)
        {
            if (m_StandingOnCell.getCellType() == CellType.APPLE)
            {
                addNutrition(m_NutritionGainFromApple);
                m_Scene.getGrid().setCellAt(new GrassCell(), (int) getCenter().x, (int) getCenter().y);
            }
        }

        if (m_ShowSearchRadius)
        {
            fill(0, 0, 0, 100);
            circle(m_Position.x, m_Position.y, m_SeachRadius*2*m_GameScene.getGrid().getCellSize());
        }

        switch (m_State)
        {
            case WANDER:
                m_CurrentMovementSpeed = m_WanderMovementSpeed;
                wander();
                break;
            
            case CHASE_FOOD:
                if (m_ShowChaseFoodInfo)
                    line(m_Position.x, m_Position.y, applePos.x, applePos.y);
    
                seek(applePos);
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

    private void handleSplitting()
    {
        m_TimeSinceSplit += Time.dt();
        if (!canSplit())
            return;

        m_TimeSinceSplit = 0f;
        m_GameScene.addAnimal(new Prey("child of " + getName()));
    }

    private boolean canSplit()
    {
        if (m_TimeSinceSplit < m_SplitCooldown)
            return false;

        if (m_Nutrition / m_NutritionMax < m_SplitNutritionPercent)
            return false;

        return true;
    }
}

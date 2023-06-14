public class Prey extends Animal
{
    private PreyState m_State = PreyState.WANDER;
    private float m_NutritionGainFromApple = 40f;
    private float m_ChaseFoodSpeed = 15f; 
    private int m_SeachRadius = 4;
    private boolean m_ShowChaseFoodInfo = false;
    private boolean m_ShowSearchRadius = false;
    private boolean m_ShowFoodPoints = false;
    private boolean m_ShowRayToFood = false;

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

        m_NutritionMax = 100f;
        modifyNutrition(m_NutritionMax / 2); // Default to half of max
        m_NutritionLossPrSecond = 2f;

        m_SplitNutritionPercent = 0.75f;
        m_SplitCooldown = 8f;

        m_HalfExtents = new ZVector(m_Sprite.width, m_Sprite.height);
    }

    @Override
    public void enableDebug()
    {
        super.enableDebug();

        m_ShowSearchRadius = true;
        m_ShowChaseFoodInfo = true;
        m_ShowFoodPoints = true;
        m_ShowRayToFood = true;
    }

    @Override
    public void disableDebug()
    {
        super.disableDebug();

        m_ShowSearchRadius = false;
        m_ShowChaseFoodInfo = false;
        m_ShowFoodPoints = false;
        m_ShowRayToFood = false;
    }

    @Override
    public void update()
    {
        super.update();

        ZVector translatedPos = m_GameScene.getGrid().translateWS2Idx(m_Position);
        fill(0, 0, 255);

        // Get a vector to every cell type in a radius of m_SeachRadius
        ArrayList<Tuple<CellType, ZVector>> neighbours = m_GameScene.getGrid().getNeighbourLocations((int) translatedPos.x, (int) translatedPos.y, m_SeachRadius);

        ArrayList<ZVector> apples = new ArrayList<ZVector>();

        // Filter for all the apples
        for (int i = 0; i < neighbours.size(); i++)
        {
            if (neighbours.get(i).x == CellType.APPLE)
                apples.add(neighbours.get(i).y);
        }

        // Translate all apple positions from idx space to WS positions
        ArrayList<ZVector> translatedAppleWSPos = new ArrayList<ZVector>();

        for (int i = 0; i < apples.size(); i++)
        {
            ZVector appleIdxPos = apples.get(i);
            ZVector appleWSPos = m_GameScene.getGrid().getWSCenterOfCell(m_GameScene.getGrid().translateIdx2WS(appleIdxPos));

            translatedAppleWSPos.add(appleWSPos);

            if (m_ShowRayToFood)
                line(m_Position.x, m_Position.y, appleWSPos.x, appleWSPos.y);
            
            if (m_ShowFoodPoints)
                circle(appleWSPos.x, appleWSPos.y, 15);
        }

        // Find the shortest path to an apple
        ZVector applePos = ZVector.getClosest(m_Position, translatedAppleWSPos);

        if (applePos != null)
        {
            m_State = PreyState.CHASE_FOOD;
        }
        else
        {
            m_State = PreyState.WANDER;
        }
        
        if (m_StandingOnCell != null)
        {
            if (m_StandingOnCell.getCellType() == CellType.APPLE)
            {
                modifyNutrition(m_NutritionGainFromApple);
                m_GameScene.getGrid().setCellAt(new GrassCell(), (int) getCenter().x, (int) getCenter().y);
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
    
                m_CurrentMovementSpeed = m_ChaseFoodSpeed;
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


    @Override
    protected void handleSplitting()
    {
        m_TimeSinceSplit = 0f;
        m_GameScene.addAnimal(new Prey("child of " + getName()), m_Position);
    }

}

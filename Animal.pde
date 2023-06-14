public abstract class Animal implements IObjectWithBounds
{
    protected Scene m_GameScene;
    protected String m_Name;
    protected PShape m_Sprite;
    protected PShape m_DamageEffect;
    protected float m_SpeedMultiplier = 1f;
    protected float m_CurrentMovementSpeed;
    protected float m_ControlMovementSpeed = 4f;
    protected float m_MaxSpeed = 75f;
    protected float m_WanderMovementSpeed = 15f;
    protected float m_WanderRadius = 50f; // How much the radius of the wandering is
    protected float m_WanderAngleChange = 0.5f; // How many radians the angle wander angle can change every wander call
    protected float m_WanderAngle = 0f; // Determines a new position to wander towards together with the current pos
    protected float m_WanderDirectionExtend = 100f; // How much of the animal's direction (v) will be extended when wandering
    protected boolean m_ShowWandererInfo = false;
    protected boolean m_Debug = false;

    protected ZVector m_Position = new ZVector(width / 2, height / 2);
    protected float m_Rotation = 0f;
    protected ZVector m_Velocity = new ZVector(-100, 0);
    protected ZVector m_Acceleration = new ZVector();
    protected ZVector m_HalfExtents;
    protected float m_Mass = 3f;

    protected float m_Health = 100f;

    protected float m_IFrameDelay = 0.5f;
    protected float m_CurrentIFrameDuration = 0f;
    protected boolean m_HasIFrame = false;

    protected float m_FireDamage = 20f;

    protected Cell m_StandingOnCell;

    public ZVector GetPosition() { return m_Position; }
    public void SetPosition(ZVector pos) { m_Position = pos; }
    public String getName() { return m_Name; }
    public float getHealth() { return m_Health; }
    public float getMass() { return m_Mass; }

    public void SetPostion(ZVector pos) { m_Position = pos; }
    public void SetCellStandingOn(Cell cell) { m_StandingOnCell = cell; }
    public void SetGameScene(Scene scene) { m_GameScene = scene; }


    public void setup()
    {
        m_DamageEffect = loadShape("damage_effect.svg");
    }

    public void update()
    {
        // Point animal towards front of movement
        m_Rotation = m_Velocity.copy().normalize().angle();

        if (m_StandingOnCell != null) {
            if (m_StandingOnCell.getCellType() == CellType.FIRE)
                takeDamage(m_FireDamage);
        }

        if (m_HasIFrame)
        {
            m_CurrentIFrameDuration += Time.dt();
            if (m_CurrentIFrameDuration >= m_IFrameDelay)
            {
                m_HasIFrame = false;
                m_CurrentIFrameDuration = 0f;
            }
        }

    }

    public void enableDebug()
    {
        m_Debug = true;
        m_ShowWandererInfo = true;
    }

    public void disableDebug()
    {
        m_Debug = false;
        m_ShowWandererInfo = false;
    }

    public void display()
    {
        pushMatrix();
        
        translate(getCenter().x, getCenter().y);
        rotate(m_Rotation);

        shapeMode(CENTER);

        shape(m_Sprite);

        if (m_HasIFrame)
            shape(m_DamageEffect);

        popMatrix();

        if (m_Debug)
        {
            disableDebug();
        }
    }

    /*
     * Will be called every frame the animal is in the wandering state of the FSM.
     * This method will handle wandering of the animal.
    */
    protected void wander()
    {
        // Get a position scaled by 'm_WanderDirectionExtend' in the animal's movement direction
        ZVector nextPos = ZVector.add(m_Position, ZVector.mult(m_Velocity.copy().normalize(), m_WanderDirectionExtend));

        // Generate polar coordinates from a circle to constrain the m_Animals movement to it's velocity
        m_WanderAngle += random(-m_WanderAngleChange, m_WanderAngleChange);
        ZVector wanderedPos = nextPos.copy();
        wanderedPos.x += m_WanderRadius * cos(m_WanderAngle); // Convert to cartesian
        wanderedPos.y += m_WanderRadius * sin(m_WanderAngle); // Convert to cartesian

        if (m_ShowWandererInfo) // Show debug information
        {
            ZVector pos = m_Position;
            line(pos.x, pos.y, nextPos.x, nextPos.y);

            noFill();
            stroke(0);
            circle(nextPos.x, nextPos.y, m_WanderRadius*2);
            
            line(nextPos.x, nextPos.y, wanderedPos.x, wanderedPos.y);

            fill(0);
            circle(wanderedPos.x, wanderedPos.y, 10f);
        }

        // Apply force in new wander direction
        seek(wanderedPos);
    }

    protected void seek(ZVector pos)
    {
        ZVector force = ZVector.sub(pos, m_Position).normalize().mult(m_CurrentMovementSpeed);
        addForce(force);
        
        move();
    }

    protected void addForce(ZVector force)
    {
        m_Acceleration = ZVector.add(m_Acceleration, force.div(m_Mass));
    }

    protected void move()
    {
        m_Velocity = ZVector.add(m_Velocity, m_Acceleration);
        m_Velocity.limit(m_MaxSpeed);
        m_Position = ZVector.add(m_Position, ZVector.mult(m_Velocity, Time.dt()));

        m_Acceleration.mult(0);
    }

    protected void takeDamage(float amt)
    {
        if (m_HasIFrame)
            return;

        m_Health -= amt;
        if (m_Health <= 0f)
        {
            m_GameScene.DestroyAnimal(this);
        }

        m_HasIFrame = true;
    }
}

public abstract class Animal implements IObjectWithBounds
{
    protected String m_Name;
    protected PShape m_Sprite;
    protected float m_SpeedMultiplier = 1f;
    protected float m_CurrentMovementSpeed;
    protected float m_ControlMovementSpeed = 4f;
    protected float m_WanderMovementSpeed = 15f;
    protected float m_WanderRadius = 50f; // How much the radius of the wandering is
    protected float m_WanderAngleChange = 0.5f; // How many radians the angle wander angle can change every wander call
    protected float m_WanderAngle = 0f; // Determines a new position to wander towards together with the current pos
    protected float m_WanderDirectionExtend = 10f; // How much of the animal's direction (v) will be extended when wandering
    protected boolean m_ShowWandererInfo = true;

    protected ZVector m_Position = new ZVector(width / 2, height / 2);
    protected ZVector m_Velocity = new ZVector(-1, 0);
    protected ZVector m_Acceleration = new ZVector();
    protected float m_Mass = 10f;

    public void SetPostion(ZVector pos) { m_Position = pos; }

    public abstract void update();

    public void display()
    {
        fill(255,0,0);
        rectMode(CENTER);
        rect(m_Position.x, m_Position.y, getHalfExtents().x*2, getHalfExtents().y*2);
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
        ZVector force = ZVector.sub(wanderedPos, m_Position).normalize().mult(m_CurrentMovementSpeed);
        addForce(force);
        // println("force: " + force);
        println("vel: " + m_Velocity);
        
        move();
    }

    protected void addForce(ZVector force)
    {
        m_Acceleration = ZVector.add(m_Acceleration, force.div(m_Mass));
    }

    protected void move()
    {
        m_Velocity = ZVector.add(m_Velocity, m_Acceleration);
        m_Position = ZVector.add(m_Position, ZVector.mult(m_Velocity, Time.dt()));

        m_Acceleration.mult(0);
    }
}
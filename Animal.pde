public abstract class Animal
{
    protected PShape m_Sprite;
    protected float m_SpeedMultiplier = 1f;
    private float m_CurrentMovementSpeed;
    protected float m_ControlMovementSpeed = 400f;
    protected float m_WanderRadius = 50f; // How much the radius of the wandering is
    protected float m_WanderAngleChange = 0.5f;
    protected float m_WanderAngle = 0f;
    protected float m_WanderDirectionExtend = 100f; // How much of the animal's direction (v) will be extended when wandering
    protected boolean m_ShowWandererInfo = false;

    protected ZVector m_Position;
    protected ZVector m_Velocity;

    public void display()
    {

    }

    /*
     * Will be called every frame the animal is in the wandering state of the FSM.
     * This method will handle wandering of the animal.
    */
    protected void wander()
    {
        // Get a position scaled by 'm_WanderDirectionExtend' in the animal's movement direction
        ZVector nextPos = ZVector.add(m_Position, ZVector.mult(m_Velocity.copy().normalize(), m_WanderDirectionExtend));

        // Generate polar coordinates from a circle to constrain the animals movement to it's velocity
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
        println("force: " + force);
    }
}
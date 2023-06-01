public class Scene
{
    private ArrayList<Animal> m_Animals = new ArrayList<Animal>();

    public Scene()
    {
        m_Animals.add(new Prey("prey test"));
    }

    public void update()
    {
        for (int i = 0; i < m_Animals.size(); i++)
        {
            // TODO give info about m_Grid
            m_Animals.get(i).update();
        }
    }

    public void display()
    {
        for (int i = 0; i < m_Animals.size(); i++)
        {
            m_Animals.get(i).display();
        }
    }
}
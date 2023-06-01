/* Each object implementing this interface represents some object confined within an axis-aligned bounding box AABB. */
public interface IObjectWithBounds
{
    public abstract ZVector getHalfExtents();
    public abstract ZVector getCenter();
}
using Godot;

public class NullChecksTest: WAT.Test
{
    [Test]
    public void NullChecks()
    {
        Node node = new Node();
        Assert.IsNotNull(node);
        node.Free();
    }
    
    [Test]
    public void NullChecks2()
    {
        Assert.IsNull(null);
    }
    
}

using Godot;
using System;

public class SimpleTest: WAT.Test
{
    [Test]
    public void IsTrue()
    {
        Assert.IsTrue(true, "true is true");
    }
}

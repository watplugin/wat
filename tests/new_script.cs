using Godot;
using System;

public class new_script : WAT.Test
{
	[Test]
	public void AssertSimple()
	{
		Assert.IsTrue(true, "true is true");
	}
}

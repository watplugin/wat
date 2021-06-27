using Godot;
using System;
using WAT;

public class SimpleTest : WAT.Test
{
	[Test]
	public void Simple()
	{
		Assert.IsTrue(true, "true is true");
	}
}

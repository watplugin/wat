using Godot;
using System;

public class MyTest : WAT.Test
{
	[Test]
	public void AutoPass()
	{
		Assert.AutoPass("Auto Pass C#");
	}
}

 using Godot;
using System;

public class BooleanTest : WAT.Test
{
	public override String Title()
	{
		return "Given A Boolean Assertion";
	}
	
	[Test]
	public void TrueIsTrue()
	{
		Assert.IsTrue(true, "True is True");
	}
	
	[Test]
	public void FalseIsFalse()
	{
		Assert.IsFalse(false, "False is False");
	}
	
}

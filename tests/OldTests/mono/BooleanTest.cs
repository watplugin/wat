 using Godot;
using System;
 
 [Title("Given A Boolean Assertion")]
public class BooleanTest : WAT.Test
{
	[Test]
	public void TrueIsTrue()
	{
		Describe("A Tautology");
		Assert.IsTrue(true, "True is True");
	}
	
	[Test]
	public void FalseIsFalse()
	{
		Assert.IsFalse(false, "False is False");
	}
	
}

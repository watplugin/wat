using Godot;
using System;

public class EqualityTest : WAT.Test
{
	public override String Title()
	{
		return "Given an Equality Assertion";
	}
	
	[Test]
	public void WhenCallingIsEqual() 
	{ 
		Assert.IsEqual(1, 1, "Then it passes"); 
	}
	
	[Test]
	public void WhenCallingIsGreaterThan() 
	{ 
		Assert.IsGreaterThan(2, 1, "Then it passes");
	}
	
	[Test]
	public void WhenCallingIsLessThan()
	{
		Assert.IsLessThan(1, 2, "Then it passes");
	}
	
	[Test]
	public void WhenCallingIsEqualOrGreaterThan()
	{
		Assert.IsEqualOrGreaterThan(2, 1, "Then it passes");
	}
	
	[Test]
	public void WhenCallingIsEqualOrGreaterThanWithEqualValues()
	{
		Assert.IsEqualOrGreaterThan(1, 1, "Then it passes");
	}
	
	[Test]
	public void WhenCallingIsEqualOrLessThanWithEqualValues()
	{
		Assert.IsEqualOrLessThan(1, 1, "Then it passes");
	}
	
	[Test]
	public void WhenCallingIsNotEqual()
	{
		Assert.IsNotEqual(5, 6, "Then it passes");
	}
}

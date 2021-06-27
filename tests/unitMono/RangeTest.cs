using Godot;
using System;

public class RangeTest : WAT.Test

{
	public override String Title()
	{
		return "Range Assertions";
	}
	
	[Test]
	public void WhenCallingIsInRange()
	{
		int val = 0;
		int low = 0;
		int high = 10;
		Assert.IsInRange(val, low, high, "Then it passes");
	}
	
	[Test]
	public void WhenCallingIsNotInRange()
	{
		int val = 10;
		int low = 0;
		int high = 10;
		Assert.IsNotInRange(val, low, high, "Then it passes");
	}
}

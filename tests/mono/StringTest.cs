using Godot;
using System;

public class StringTest : WAT.Test
{
	public override String Title()
	{
		return "Given A String Assertion";
	}
	
	[Test]
	public void WhenCallingStringBeginWith()
	{
		const string prefix = "lorem";
		const string str = "lorem impsum";
		
		Assert.StringBeginsWith(prefix, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringDoesNotBeginWith()
	{
		const string prefix = "bleh lorem";
		const string str = "impsum";
		
		Assert.StringDoesNotBeginWith(prefix, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringContains()
	{
		const string contents = "em im";
		const string str = "lorem impsum";
		Assert.StringContains(contents, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringDoesNotContain()
	{
		const string contents = "beem im";
		const string str = "impsum";
		Assert.StringDoesNotContain(contents, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringEndsWith()
	{
		const string postfix = "impsum";
		const string str = "lorem impsum";
		Assert.StringEndsWith(postfix, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringDoesNotEndWith()
	{
		const string postfix = "lorem";
		const string str = "impsum";
		Assert.StringDoesNotEndWith(postfix, str, "Then it passes");
	}
}

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
		string prefix = "lorem";
		string str = "lorem impsum";
		
		Assert.StringBeginsWith(prefix, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringDoesNotBeginWith()
	{
		string prefix = "bleh lorem";
		string str = "impsum";
		
		Assert.StringDoesNotBeginWith(prefix, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringContains()
	{
		string contents = "em im";
		string str = "lorem impsum";
		Assert.StringContains(contents, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringDoesNotContain()
	{
		string contents = "beem im";
		string str = "impsum";
		Assert.StringDoesNotContain(contents, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringEndsWith()
	{
		string postfix = "impsum";
		string str = "lorem impsum";
		Assert.StringEndsWith(postfix, str, "Then it passes");
	}
	
	[Test]
	public void WhenCallingStringDoesNotEndWith()
	{
		string postfix = "lorem";
		string str = "impsum";
		Assert.StringDoesNotEndWith(postfix, str, "Then it passes");
	}
}

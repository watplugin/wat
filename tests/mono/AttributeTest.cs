using System;
using Godot;

[Start(nameof(StartX))]
[Pre(nameof(PreX))]
[Post(nameof(Post))]
[End(nameof(End))]
public class AttributeTest : WAT.Test
{
	private bool _calledStart = false;
	private bool _calledPre = false;
	public void StartX()
	{
		Console.WriteLine("Calling Start X in Non Yield");
		_calledStart = true;
	}

	public void PreX()
	{
		Console.WriteLine("Calling Pre Y");
		_calledPre = true;
	}

	[Test]
	public void SimpleTest()
	{
		Assert.IsTrue(_calledStart, "Start was called");
		Assert.IsTrue(_calledPre, "Pre was called");
	}

	public void Post()
	{
		Console.WriteLine("Post Called");
	}

	public void End()
	{
		Console.WriteLine("End Called");
	}
	
}

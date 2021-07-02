using System;
using System.Threading.Tasks;

[Start(nameof(StartX))]
[Pre(nameof(PreX))]
[Post(nameof(Post))]
[End(nameof(End))]
public class AttributeYieldTest : WAT.Test
{
	private bool _calledStart = false;
	private bool _calledPre = false;
	public async Task StartX()
	{
		Console.WriteLine("Yolo!");
		await UntilTimeout(0.2);
		Console.WriteLine("Calling Start X in Yield Test");
		_calledStart = true;
	}

	public async Task PreX()
	{
		await UntilTimeout(0.2);
		Console.WriteLine("Calling Pre Y in Yield Test");
		_calledPre = true;
	}

	[Test]
	public async Task SimpleTest()
	{
		await UntilTimeout(0.2);
		Assert.IsTrue(_calledStart, "Start was called in Yield Test");
		Assert.IsTrue(_calledPre, "Pre was called in Yield Test");
	}

	public async Task Post()
	{
		await UntilTimeout(0.2);
		Console.WriteLine("Post Called in Yield Test");
	}

	public async Task End()
	{
		await UntilTimeout(0.2);
		Console.WriteLine("End Called in Yield Test");
	}
	
}

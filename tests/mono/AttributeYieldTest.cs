using Godot;

using System;
using System.Threading.Tasks;
using Godot;

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
        await UntilTimeout(0.2);
        Console.WriteLine("Calling Start X");
        _calledStart = true;
    }

    public async Task PreX()
    {
        await UntilTimeout(0.2);
        Console.WriteLine("Calling Pre Y");
        _calledPre = true;
    }

    [Test]
    public async Task SimpleTest()
    {
        await UntilTimeout(0.2);
        Assert.IsTrue(_calledStart, "Start was called");
        Assert.IsTrue(_calledPre, "Pre was called");
    }

    public async Task Post()
    {
        await UntilTimeout(0.2);
        Console.WriteLine("Post Called");
    }

    public async Task End()
    {
        await UntilTimeout(0.2);
        Console.WriteLine("End Called");
    }
    
}
